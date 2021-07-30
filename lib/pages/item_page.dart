import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/widgets/common/floating_app_bar_scroll_view.dart';
import 'package:glider/widgets/items/item_body.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemPage extends HookWidget {
  const ItemPage({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    useMemoized(() => _setVisited(context));

    return Scaffold(
      body: FloatingAppBarScrollView(
        body: ItemBody(id: id),
      ),
    );
  }

  Future<void> _setVisited(BuildContext context) async {
    await context.read(storageRepositoryProvider).setVisited(id: id);
    unawaited(context.refresh(visitedProvider(id)));
  }
}
