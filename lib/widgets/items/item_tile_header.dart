import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/item.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/utils/text_style_extension.dart';
import 'package:glider/widgets/common/smooth_animated_switcher.dart';
import 'package:glider/widgets/items/item_tile_thumbnail.dart';
import 'package:glider/widgets/items/item_tile_title.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemTileHeader extends HookWidget {
  const ItemTileHeader(
    this.item, {
    Key? key,
    this.dense = false,
    this.interactive = false,
  }) : super(key: key);

  final Item item;
  final bool dense;
  final bool interactive;

  @override
  Widget build(BuildContext context) {
    final bool showThumbnail =
        interactive || (useProvider(showThumbnailProvider).data?.value ?? true);

    return ConstrainedBox(
      constraints: showThumbnail
          ? BoxConstraints(minHeight: calculateHeight(context) ?? 0)
          : const BoxConstraints(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ItemTileTitle(
              item,
              dense: dense,
              interactive: interactive,
            ),
          ),
          if (item.url != null)
            SmoothAnimatedSwitcher.all(
              condition: showThumbnail,
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 12),
                  ItemTileThumbnail(item),
                ],
              ),
            ),
        ],
      ),
    );
  }

  static double? calculateHeight(BuildContext context) {
    final double? fontSize =
        Theme.of(context).textTheme.subtitle1?.scaledFontSize(context);
    return fontSize != null ? fontSize * 2 + 6 : null;
  }
}
