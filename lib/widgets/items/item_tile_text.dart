import 'package:flutter/material.dart';
import 'package:glider/models/item.dart';
import 'package:glider/widgets/common/decorated_html.dart';
import 'package:glider/widgets/common/fade_hero.dart';
import 'package:glider/widgets/common/smooth_animated_size.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemTileText extends HookConsumerWidget {
  const ItemTileText(
    this.item, {
    Key? key,
  }) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FadeHero(
      tag: 'item_${item.id}_text',
      child: SmoothAnimatedSize(
        child: DecoratedHtml(item.text!),
      ),
    );
  }
}
