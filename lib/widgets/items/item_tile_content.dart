import 'package:flutter/widgets.dart';
import 'package:glider/models/item.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/widgets/common/smooth_animated_switcher.dart';
import 'package:glider/widgets/items/item_tile_header.dart';
import 'package:glider/widgets/items/item_tile_metadata.dart';
import 'package:glider/widgets/items/item_tile_preview.dart';
import 'package:glider/widgets/items/item_tile_text.dart';
import 'package:glider/widgets/items/item_tile_url.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemTileContent extends HookConsumerWidget {
  const ItemTileContent(
    this.item, {
    Key? key,
    this.root,
    this.dense = false,
    this.interactive = false,
    this.opacity = 1,
  }) : super(key: key);

  final Item item;
  final Item? root;
  final bool dense;
  final bool interactive;
  final double opacity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool showMetadata =
        interactive || (ref.watch(showMetadataProvider).data?.value ?? true);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (item.preview) ...<Widget>[
            const ItemTilePreview(),
            const SizedBox(height: 12),
          ],
          if (item.title != null)
            ItemTileHeader(
              item,
              dense: dense,
              interactive: interactive,
              opacity: opacity,
            ),
          SmoothAnimatedSwitcher.vertical(
            condition: showMetadata,
            child: Column(
              children: <Widget>[
                if (item.title != null) const SizedBox(height: 12),
                ItemTileMetadata(
                  item,
                  root: root,
                  dense: dense,
                  interactive: interactive,
                  opacity: opacity,
                ),
              ],
            ),
          ),
          if (item.text != null || item.url != null)
            SmoothAnimatedSwitcher.vertical(
              condition: !dense,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (item.text != null) ...<Widget>[
                    const SizedBox(height: 12),
                    ItemTileText(
                      item,
                      opacity: opacity,
                    ),
                  ],
                  if (item.url != null) ...<Widget>[
                    const SizedBox(height: 12),
                    ItemTileUrl(
                      item,
                      opacity: opacity,
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}
