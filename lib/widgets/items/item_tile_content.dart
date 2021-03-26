import 'package:flutter/widgets.dart';
import 'package:glider/models/item.dart';
import 'package:glider/widgets/common/smooth_animated_switcher.dart';
import 'package:glider/widgets/items/item_tile_header.dart';
import 'package:glider/widgets/items/item_tile_metadata.dart';
import 'package:glider/widgets/items/item_tile_preview.dart';
import 'package:glider/widgets/items/item_tile_text.dart';
import 'package:glider/widgets/items/item_tile_url.dart';

class ItemTileContent extends StatelessWidget {
  const ItemTileContent(
    this.item, {
    Key? key,
    this.root,
    this.dense = false,
    this.interactive = false,
  }) : super(key: key);

  final Item item;
  final Item? root;
  final bool dense;
  final bool interactive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (item.localOnly) ...<Widget>[
            const ItemTilePreview(),
            const SizedBox(height: 12),
          ],
          if (item.title != null) ...<Widget>[
            ItemTileHeader(item, dense: dense),
            const SizedBox(height: 12),
          ],
          ItemTileMetadata(
            item,
            root: root,
            dense: dense,
            interactive: interactive,
          ),
          if (item.text != null || item.url != null)
            SmoothAnimatedSwitcher.vertical(
              condition: !dense,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (item.text != null) ...<Widget>[
                    const SizedBox(height: 12),
                    ItemTileText(item),
                  ],
                  if (item.url != null) ...<Widget>[
                    const SizedBox(height: 12),
                    ItemTileUrl(item),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}
