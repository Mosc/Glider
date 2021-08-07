import 'package:flutter/material.dart';
import 'package:glider/commands/vote_command.dart';
import 'package:glider/models/item.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/widgets/items/item_tile_metadata.dart';
import 'package:glider/widgets/items/item_tile_text.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemTileContentPollOption extends HookConsumerWidget {
  const ItemTileContentPollOption(
    this.item, {
    Key? key,
    this.root,
    this.interactive = false,
  }) : super(key: key);

  final Item item;
  final Item? root;
  final bool interactive;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: <Widget>[
          Checkbox(
            value: ref.watch(upvotedProvider(item.id)).maybeWhen(
                  data: (bool upvoted) => upvoted,
                  orElse: () => false,
                ),
            onChanged: interactive
                ? (bool? upvote) => VoteCommand(context, ref,
                        id: item.id, upvote: upvote ?? false)
                    .execute()
                : null,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          if (item.text != null)
            Expanded(
              child: ItemTileText(item),
            )
          else
            const Spacer(),
          ItemTileMetadata(item, root: root),
        ],
      ),
    );
  }
}
