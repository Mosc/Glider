import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/models/item.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/repositories/website_repository.dart';
import 'package:glider/utils/formatting_util.dart';
import 'package:glider/widgets/common/options_dialog.dart';
import 'package:glider/widgets/common/scrollable_bottom_sheet.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemBottomSheet extends StatelessWidget {
  const ItemBottomSheet(this.item, {Key? key}) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    final AsyncData<bool>? favorited =
        context.read(favoritedProvider(item.id)).data;

    final List<OptionsDialogOption> optionsDialogOptions =
        <OptionsDialogOption>[
      if (item.text != null)
        OptionsDialogOption(
          title: appLocalizations.text,
          text: FormattingUtil.convertHtmlToHackerNews(item.text!),
        ),
      if (item.url != null)
        OptionsDialogOption(
          title: appLocalizations.link,
          text: item.url!,
        ),
      OptionsDialogOption(
        title: appLocalizations.threadLink,
        text: Uri.https(
          WebsiteRepository.authority,
          'item',
          <String, String>{'id': item.id.toString()},
        ).toString(),
      ),
    ];

    return ScrollableBottomSheet(
      children: <Widget>[
        if (favorited != null)
          if (favorited.value)
            ListTile(
              title: Text(appLocalizations.unfavorite),
              onTap: () {
                _favorite(context, favorite: false);
                Navigator.of(context).pop();
              },
            )
          else
            ListTile(
              title: Text(appLocalizations.favorite),
              onTap: () {
                _favorite(context, favorite: true);
                Navigator.of(context).pop();
              },
            ),
        ListTile(
          title: Text.rich(
            TextSpan(
              children: <InlineSpan>[
                TextSpan(text: appLocalizations.copy),
                const TextSpan(text: '...'),
              ],
            ),
          ),
          onTap: () async {
            await showDialog<void>(
              context: context,
              builder: (_) => OptionsDialog.copy(
                options: optionsDialogOptions,
              ),
            );
            Navigator.of(context).pop();
          },
        ),
        ListTile(
          title: Text.rich(
            TextSpan(
              children: <InlineSpan>[
                TextSpan(text: appLocalizations.share),
                const TextSpan(text: '...'),
              ],
            ),
          ),
          onTap: () async {
            await showDialog<void>(
              context: context,
              builder: (_) => OptionsDialog.share(
                options: optionsDialogOptions,
                subject: item.title,
              ),
            );
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  void _favorite(BuildContext context, {required bool favorite}) =>
      context.read(authRepositoryProvider).favorite(
            id: item.id,
            favorite: favorite,
            onUpdate: () => context
              ..refresh(favoritedProvider(item.id))
              ..refresh(favoriteIdsProvider),
          );
}
