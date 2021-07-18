import 'package:flutter/material.dart';
import 'package:glider/l10n/app_localizations.dart';
import 'package:glider/models/user.dart';
import 'package:glider/repositories/website_repository.dart';
import 'package:glider/utils/formatting_util.dart';
import 'package:glider/widgets/common/options_dialog.dart';
import 'package:glider/widgets/common/scrollable_bottom_sheet.dart';

class UserBottomSheet extends StatelessWidget {
  const UserBottomSheet(this.user, {Key? key}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    final List<OptionsDialogOption> copyShareOptions = <OptionsDialogOption>[
      if (user.about != null)
        OptionsDialogOption(
          title: appLocalizations.text,
          text: FormattingUtil.convertHtmlToHackerNews(user.about!),
        ),
      OptionsDialogOption(
        title: appLocalizations.userLink,
        text: Uri.https(
          WebsiteRepository.authority,
          'user',
          <String, String>{'id': user.id},
        ).toString(),
      ),
    ];

    return ScrollableBottomSheet(
      children: <Widget>[
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
              builder: (_) => OptionsDialog.copy(options: copyShareOptions),
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
                options: copyShareOptions,
                subject: user.id,
              ),
            );
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
