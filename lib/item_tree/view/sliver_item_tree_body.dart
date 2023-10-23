import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/app/container/app_container.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';
import 'package:glider/common/constants/app_animation.dart';
import 'package:glider/common/mixins/data_mixin.dart';
import 'package:glider/item/cubit/item_cubit.dart';
import 'package:glider/item/widgets/indented_widget.dart';
import 'package:glider/item/widgets/item_loading_tile.dart';
import 'package:glider/item/widgets/item_tile.dart';
import 'package:glider/item_tree/cubit/item_tree_cubit.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';
import 'package:glider_domain/glider_domain.dart';

class SliverItemTreeBody extends StatefulWidget {
  const SliverItemTreeBody(
    this._itemTreeCubit,
    this._itemCubitFactory,
    this._authCubit, {
    super.key,
    this.childCount,
    this.storyUsername,
  });

  final ItemTreeCubit _itemTreeCubit;
  final ItemCubitFactory _itemCubitFactory;
  final AuthCubit _authCubit;
  final int? childCount;
  final String? storyUsername;

  @override
  State<SliverItemTreeBody> createState() => _SliverItemTreeBodyState();
}

class _SliverItemTreeBodyState extends State<SliverItemTreeBody> {
  final Map<int, ItemCubit> _itemCubits = {};

  @override
  void initState() {
    _updateItemCubits(widget._itemTreeCubit.state);
    super.initState();
  }

  @override
  void dispose() {
    for (final itemCubit in _itemCubits.values) {
      unawaited(itemCubit.close());
    }

    super.dispose();
  }

  void _updateItemCubits(ItemTreeState state) {
    if (state.data case final descendants?) {
      for (final descendant in descendants) {
        _itemCubits[descendant.id] ??= widget._itemCubitFactory(descendant.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ItemTreeCubit, ItemTreeState>(
      bloc: widget._itemTreeCubit,
      listenWhen: (previous, current) => previous.data != current.data,
      listener: (context, state) {
        _updateItemCubits(state);

        if (state.newDescendantsCount > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(context.l10n.newDescendants(state.newDescendantsCount)),
            ),
          );
        }
      },
      builder: (context, state) => state.whenOrDefaultSlivers(
        loading: () => SliverList.builder(
          itemBuilder: (context, index) => const IndentedWidget(
            depth: 1,
            child: ItemLoadingTile(type: ItemType.comment),
          ),
          itemCount: widget.childCount,
        ),
        nonEmpty: () => SliverList.list(
          children: [
            for (final descendant in state.viewableData!)
              _buildItemTile(descendant, state),
          ],
        ),
        onRetry: () async => widget._itemTreeCubit.load(),
      ),
    );
  }

  Widget _buildItemTile(ItemDescendant descendant, ItemTreeState state) {
    return IndentedWidget(
      depth: descendant.isPart ? 0 : descendant.depth,
      child: ItemTile(
        _itemCubits[descendant.id]!,
        widget._authCubit,
        key: ValueKey(descendant.id),
        storyUsername: widget.storyUsername,
        loadingType: ItemType.comment,
        collapsedCount: state.collapsedIds.contains(descendant.id)
            ? state.getDescendants(descendant)?.length
            : null,
        showVisited: false,
        highlight:
            !(state.previousData?.map((e) => e.id).contains(descendant.id) ??
                true),
        onTap: (context, item) async {
          if (!item.isDeleted) {
            widget._itemTreeCubit.toggleCollapsed(item.id);
          }

          await Scrollable.ensureVisible(
            context,
            duration: AppAnimation.standard.duration,
            curve: AppAnimation.standard.easing,
            alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart,
          );
        },
      ),
    );
  }
}
