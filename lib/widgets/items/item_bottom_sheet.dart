import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glider/models/item.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/repositories/website_repository.dart';
import 'package:glider/utils/scaffold_messenger_state_extension.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';

class ItemBottomSheet extends StatelessWidget {
  const ItemBottomSheet(this.item, {Key? key}) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    final AsyncData<bool>? favorited =
        context.read(favoritedProvider(item.id)).data;

    return SafeArea(
      child: Wrap(
        children: <Widget>[
          if (favorited != null)
            if (favorited.value)
              ListTile(
                title: const Text('Unfavorite'),
                onTap: () {
                  _favorite(context, favorite: false);
                  Navigator.of(context).pop();
                },
              )
            else
              ListTile(
                title: const Text('Favorite'),
                onTap: () {
                  _favorite(context, favorite: true);
                  Navigator.of(context).pop();
                },
              ),
          if (item.text != null)
            ListTile(
              title: const Text('Copy text'),
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: item.text));
                ScaffoldMessenger.of(context).showSnackBarQuickly(
                  const SnackBar(content: Text('Text has been copied')),
                );
                Navigator.of(context).pop();
              },
            ),
          if (item.url != null)
            ListTile(
              title: const Text('Share link'),
              onTap: () async {
                await Share.share(
                  item.url!,
                  subject: item.title,
                );
                Navigator.of(context).pop();
              },
            ),
          ListTile(
            title: const Text('Share thread link'),
            onTap: () async {
              await Share.share(
                Uri.https(
                  WebsiteRepository.authority,
                  'item',
                  <String, String>{'id': item.id.toString()},
                ).toString(),
                subject: item.title,
              );
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
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
