import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/item.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/utils/animation_util.dart';
import 'package:glider/widgets/common/smooth_animated_switcher.dart';
import 'package:glider/widgets/items/item_tile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pedantic/pedantic.dart';

class CollapsibleItemTile extends HookWidget {
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
  final Widget Function() loading;

  @override
  Widget build(BuildContext context) {
    final bool collapsed = _collapsed(id);

    return SmoothAnimatedSwitcher.vertical(
      condition: !ancestors
          .any((int ancestor) => ancestor != root?.id && _collapsed(ancestor)),
      child: ItemTile(
        id: id,
        ancestors: ancestors,
        root: root,
        onTap: (BuildContext context) async {
          unawaited(_setCollapsed(context, collapsed: !collapsed));
          unawaited(_scrollToTop(context));
        },
        dense: collapsed,
        interactive: true,
        fadeable: fadeable,
        loading: loading,
      ),
    );
  }

  bool _collapsed(int id) =>
      useProvider(collapsedProvider(id)).data?.value ?? false;

  Future<void> _setCollapsed(BuildContext context,
      {required bool collapsed}) async {
    await context
        .read(storageRepositoryProvider)
        .setCollapsed(id: id, collapsed: collapsed);
    return context.refresh(collapsedProvider(id));
  }

  Future<void> _scrollToTop(BuildContext context) async {
    final RenderObject? renderObject = context.findRenderObject();

    if (renderObject != null) {
      return Scrollable.of(context)?.position.ensureVisible(
            renderObject,
            duration: AnimationUtil.defaultDuration,
            curve: Curves.easeInOut,
            alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart,
          );
    }
  }
}
