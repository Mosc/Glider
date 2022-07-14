import 'package:flutter/widgets.dart';
import 'package:glider/models/item.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/widgets/common/smooth_animated_switcher.dart';
import 'package:glider/widgets/items/item_tile_header.dart';
import 'package:glider/widgets/items/item_tile_metadata.dart';
import 'package:glider/widgets/items/item_tile_text.dart';
import 'package:glider/widgets/items/item_tile_url.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemTileContent extends HookConsumerWidget {
  const ItemTileContent(
    this.item, {
    super.key,
    this.root,
    this.dense = false,
    this.interactive = false,
  });

  final Item item;
  final Item? root;
  final bool dense;
  final bool interactive;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool blocked = item.by != null &&
        (ref.watch(blockedProvider(item.by!)).value ?? false);
    final bool showHeader = item.title != null && !blocked;
    final bool showMetadata = !dense ||
        interactive ||
        (ref.watch(showMetadataProvider).value ?? false);
    final bool showTextAndUrl =
        (item.text != null || item.url != null) && !blocked;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (showHeader)
            ItemTileHeader(
              item,
              dense: dense,
              interactive: interactive,
            ),
          SmoothAnimatedSwitcher.vertical(
            condition: showMetadata,
            child: Column(
              children: <Widget>[
                if (showHeader) const SizedBox(height: 12),
                ItemTileMetadata(
                  item,
                  root: root,
                  dense: dense,
                  interactive: interactive,
                ),
              ],
            ),
          ),
          if (showTextAndUrl)
            SmoothAnimatedSwitcher.vertical(
              condition: !dense,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (item.text != null) ...<Widget>[
                    const SizedBox(height: 12),
                    ItemTileText(
                      item,
                    ),
                  ],
                  if (item.url != null) ...<Widget>[
                    const SizedBox(height: 12),
                    ItemTileUrl(
                      item,
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
