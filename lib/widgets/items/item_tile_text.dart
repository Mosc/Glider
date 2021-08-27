import 'package:flutter/material.dart';
import 'package:glider/models/item.dart';
import 'package:glider/utils/animation_util.dart';
import 'package:glider/widgets/common/decorated_html.dart';
import 'package:glider/widgets/common/fade_hero.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemTileText extends HookConsumerWidget {
  const ItemTileText(
    this.item, {
    Key? key,
    this.opacity = 1,
  }) : super(key: key);

  final Item item;
  final double opacity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FadeHero(
      tag: 'item_${item.id}_text',
      child: AnimatedOpacity(
        opacity: opacity,
        duration: AnimationUtil.defaultDuration,
        child: DecoratedHtml(item.text!),
      ),
    );
  }
}
