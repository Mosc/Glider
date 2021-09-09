import 'package:flutter/material.dart';
import 'package:glider/models/item.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/utils/text_style_extension.dart';
import 'package:glider/widgets/common/smooth_animated_switcher.dart';
import 'package:glider/widgets/items/item_tile_favicon.dart';
import 'package:glider/widgets/items/item_tile_title.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemTileHeader extends HookConsumerWidget {
  const ItemTileHeader(
    this.item, {
    Key? key,
    this.dense = false,
    this.interactive = false,
    this.opacity = 1,
  }) : super(key: key);

  final Item item;
  final bool dense;
  final bool interactive;
  final double opacity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool showFavicon =
        interactive || (ref.watch(showFaviconProvider).data?.value ?? true);

    return ConstrainedBox(
      constraints: showFavicon
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
              opacity: opacity,
            ),
          ),
          if (item.url != null)
            SmoothAnimatedSwitcher.all(
              condition: showFavicon,
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 12),
                  ItemTileFavicon(
                    item,
                    opacity: opacity,
                  ),
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
