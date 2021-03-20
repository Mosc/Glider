import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/item.dart';
import 'package:glider/widgets/common/decorated_html.dart';

class ItemTileText extends HookWidget {
  const ItemTileText(this.item, {Key? key}) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'item_text_${item.id}',
      child: DecoratedHtml(item.text!),
    );
  }
}
