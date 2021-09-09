import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:glider/models/item.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/utils/animation_util.dart';
import 'package:glider/utils/url_util.dart';
import 'package:glider/widgets/common/fade_hero.dart';
import 'package:glider/widgets/common/tile_loading_block.dart';
import 'package:glider/widgets/items/item_tile_header.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:octo_image/octo_image.dart';

class ItemTileFavicon extends HookConsumerWidget {
  const ItemTileFavicon(
    this.item, {
    Key? key,
    this.opacity = 1,
  }) : super(key: key);

  final Item item;
  final double opacity;

  static final BorderRadius _borderRadius = BorderRadius.circular(4);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double? size = ItemTileHeader.calculateHeight(context);

    return GestureDetector(
      onTap: () => UrlUtil.tryLaunch(context, item.url!),
      child: FadeHero(
        tag: 'item_${item.id}_favicon',
        child: AnimatedOpacity(
          opacity: opacity,
          duration: AnimationUtil.defaultDuration,
          child: item.preview
              ? _placeholderBuilder(context, size: size)
              : OctoImage(
                  image: ref.read(imageProvider(item.faviconUrl(48)!)),
                  imageBuilder: (_, Widget child) => ClipRRect(
                    borderRadius: _borderRadius,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      color: Theme.of(context).colorScheme.surface,
                      child: child,
                    ),
                  ),
                  placeholderBuilder: (BuildContext context) =>
                      _placeholderBuilder(context, size: size),
                  errorBuilder: (_, __, ___) => Icon(
                    FluentIcons.chevron_right_24_regular,
                    size: size,
                  ),
                  width: size,
                  height: size,
                ),
        ),
      ),
    );
  }

  static Widget _placeholderBuilder(BuildContext context, {double? size}) {
    return TileLoadingBlock(
      width: size,
      height: size,
      color: Theme.of(context).colorScheme.surface,
    );
  }
}
