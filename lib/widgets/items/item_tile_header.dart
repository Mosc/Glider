import 'package:flutter/material.dart';
import 'package:glider/models/item.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/utils/text_style_extension.dart';
import 'package:glider/widgets/common/smooth_animated_switcher.dart';
import 'package:glider/widgets/items/item_tile_favicon.dart';
import 'package:glider/widgets/items/item_tile_title.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils/animation_util.dart';
import '../common/smooth_animated_size.dart';

class ItemTileHeader extends HookConsumerWidget {
  const ItemTileHeader(
    this.item, {
    super.key,
    this.position,
    this.dense = false,
    this.interactive = false,
    this.opacity = 1,
  });

  final Item item;
  final int? position;
  final bool dense;
  final bool interactive;
  final double opacity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool showFavicon = ref.watch(showFaviconProvider).value ?? false;
    final bool showPosition =
        (ref.watch(showPositionProvider).value ?? false) && (position != null);

    return ConstrainedBox(
      constraints: showFavicon
          ? BoxConstraints(minHeight: calculateHeight(context) ?? 0)
          : const BoxConstraints(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SmoothAnimatedSwitcher.all(
            condition: showPosition,
            child: Row(
              children: <Widget>[
                const SizedBox(width: 6),
                Center(
                    child: AnimatedOpacity(
                  opacity: opacity,
                  duration: AnimationUtil.defaultDuration,
                  child: SmoothAnimatedSize(
                    child: Text(
                      '${(position ?? -2) + 1}.',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                )),
                const SizedBox(width: 6),
              ],
            ),
          ),
          Expanded(
            child: ItemTileTitle(
              item,
              dense: dense,
              interactive: interactive,
              opacity: opacity,
            ),
          ),
          if (item.urlHost != null)
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
    final double? lineHeight =
        Theme.of(context).textTheme.titleMedium?.lineHeight(context);
    return lineHeight != null ? lineHeight * 2 : null;
  }
}
