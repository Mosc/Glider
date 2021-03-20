import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ItemTilePreview extends HookWidget {
  const ItemTilePreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Note: The following is a preview. It may not accurately depict '
      'what the result will look like once it has been processed.',
      style: Theme.of(context).textTheme.caption,
    );
  }
}
