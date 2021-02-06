import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/item.dart';
import 'package:glider/utils/text_style_extension.dart';
import 'package:glider/utils/url_util.dart';
import 'package:glider/widgets/common/block.dart';

class ItemTileUrl extends HookWidget {
  const ItemTileUrl(this.item, {Key key}) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Hero(
      tag: 'item_url_${item.id}',
      child: GestureDetector(
        onTap: () => UrlUtil.tryLaunch(item.url),
        child: Block(
          child: Row(
            children: <Widget>[
              Icon(FluentIcons.window_arrow_up_24_regular,
                  size: textTheme.bodyText2.scaledFontSize(context)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.url,
                  style: textTheme.bodyText2
                      .copyWith(decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
