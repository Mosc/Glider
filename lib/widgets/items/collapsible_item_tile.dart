import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:glider/models/item.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/utils/animation_util.dart';
import 'package:glider/widgets/common/smooth_animated_switcher.dart';
import 'package:glider/widgets/items/item_tile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CollapsibleItemTile extends HookConsumerWidget {
  const CollapsibleItemTile({
    Key? key,
    required this.id,
    this.ancestors = const <int>[],
    this.root,
    this.fadeable = false,
    required this.loading,
  }) : super(key: key);

  final int id;
  final Iterable<int> ancestors;
  final Item? root;
  final bool fadeable;
  final Widget Function({int indentation}) loading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool _collapsed(int id) => ref.watch(collapsedProvider(id)).value ?? false;

    final bool collapsed = _collapsed(id);

    return SmoothAnimatedSwitcher.vertical(
      condition: !ancestors.any(
        (int ancestor) => ancestor != root?.id && _collapsed(ancestor),
      ),
      child: ItemTile(
        id: id,
        indentation: ancestors.length,
        root: root,
        onTap: (BuildContext context) async {
          unawaited(_setCollapsed(ref, collapsed: !collapsed));
          unawaited(_scrollToTop(context));
        },
        dense: collapsed,
        interactive: true,
        fadeable: fadeable,
        loading: loading,
      ),
    );
  }

  Future<void> _setCollapsed(WidgetRef ref, {required bool collapsed}) async {
    await ref
        .read(storageRepositoryProvider)
        .setCollapsed(id: id, collapsed: collapsed);
    ref.invalidate(collapsedProvider(id));
  }

  Future<void> _scrollToTop(BuildContext context) async {
    final RenderObject? renderObject = context.findRenderObject();

    if (renderObject != null) {
      return Scrollable.of(context)?.position.ensureVisible(
            renderObject,
            duration: AnimationUtil.defaultDuration,
            curve: AnimationUtil.defaultCurve,
            alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart,
          );
    }
  }
}
