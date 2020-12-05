import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/pages/item_page.dart';
import 'package:glider/widgets/items/item_tile.dart';
import 'package:glider/widgets/items/story_tile_loading.dart';

class StoryTile extends HookWidget {
  const StoryTile({Key key, this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return ItemTile(
      id: id,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => ItemPage(id: id)),
      ),
      dense: true,
      fadeable: true,
      loading: () => const StoryTileLoading(),
    );
  }
}
