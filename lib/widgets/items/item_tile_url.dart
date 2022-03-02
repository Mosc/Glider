import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:glider/models/item.dart';
import 'package:glider/utils/text_style_extension.dart';
import 'package:glider/utils/url_util.dart';
import 'package:glider/widgets/common/block.dart';
import 'package:glider/widgets/common/fade_hero.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemTileUrl extends HookConsumerWidget {
  const ItemTileUrl(
    this.item, {
    Key? key,
  }) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () => UrlUtil.tryLaunch(context, ref, item.url!),
      child: FadeHero(
        tag: 'item_${item.id}_url',
        child: Block(
          child: Row(
            children: <Widget>[
              Icon(
                FluentIcons.window_arrow_up_24_regular,
                size: textTheme.bodyMedium?.scaledFontSize(context),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.url!,
                  style: textTheme.bodyMedium
                      ?.copyWith(decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
