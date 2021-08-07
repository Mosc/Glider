import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:glider/models/item_menu_action.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/widgets/common/scrollable_bottom_sheet.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemBottomSheet extends HookConsumerWidget {
  const ItemBottomSheet({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool upvoted = ref.watch(upvotedProvider(id)).data?.value ?? false;
    final bool favorited =
        ref.watch(favoritedProvider(id)).data?.value ?? false;

    return ScrollableBottomSheet(
      children: <Widget>[
        for (ItemMenuAction menuAction in ItemMenuAction.values)
          ListTile(
            title: Text(
              menuAction.title(context, upvoted: upvoted, favorited: favorited),
            ),
            onTap: () async {
              Navigator.of(context).pop();
              await menuAction
                  .command(context, ref,
                      id: id, upvoted: upvoted, favorited: favorited)
                  .execute();
            },
          ),
      ],
    );
  }
}
