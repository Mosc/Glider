import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/item.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/widgets/items/item_tile_metadata.dart';
import 'package:glider/widgets/items/item_tile_text.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemTileContentPollOption extends HookWidget {
  const ItemTileContentPollOption(
    this.item, {
    Key key,
    this.root,
    this.interactive = false,
    @required this.vote,
  }) : super(key: key);

  final Item item;
  final Item root;
  final bool interactive;
  final Future<void> Function(BuildContext, {bool up}) vote;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Checkbox(
          value: useProvider(upvotedProvider(item.id)).maybeWhen(
            data: (bool upvoted) => upvoted,
            orElse: () => false,
          ),
          onChanged: interactive ? (bool up) => vote(context, up: up) : null,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        Expanded(child: ItemTileText(item)),
        ItemTileMetadata(item, root: root),
      ],
    );
  }
}
