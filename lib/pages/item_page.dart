import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/widgets/items/item_body.dart';

class ItemPage extends HookWidget {
  const ItemPage({Key key, @required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (_, bool innerBoxIsScrolled) => <Widget>[
          SliverAppBar(
            forceElevated: innerBoxIsScrolled,
            floating: true,
          ),
        ],
        body: ItemBody(id: id),
      ),
    );
  }
}
