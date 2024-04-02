import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/app/container/app_container.dart';
import 'package:glider/app/extensions/super_sliver_list_extension.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';
import 'package:glider/common/constants/app_animation.dart';
import 'package:glider/common/mixins/data_mixin.dart';
import 'package:glider/item/widgets/indented_widget.dart';
import 'package:glider/item/widgets/item_loading_tile.dart';
import 'package:glider/item/widgets/item_tile.dart';
import 'package:glider/item_tree/cubit/item_tree_cubit.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';
import 'package:glider/settings/cubit/settings_cubit.dart';
import 'package:glider_domain/glider_domain.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class SliverItemTreeBody extends StatelessWidget {
  const SliverItemTreeBody(
    this._itemTreeCubit,
    this._itemCubitFactory,
    this._authCubit,
    this._settingsCubit, {
    super.key,
    this.listController,
    this.childCount,
    this.storyUsername,
  });

  final ItemTreeCubit _itemTreeCubit;
  final ItemCubitFactory _itemCubitFactory;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;
  final ListController? listController;
  final int? childCount;
  final String? storyUsername;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ItemTreeCubit, ItemTreeState>(
      bloc: _itemTreeCubit,
      listenWhen: (previous, current) =>
          previous.newDescendantsCount != current.newDescendantsCount,
      listener: (context, state) {
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
        loading: () => SuperSliverListExtension.builder(
          itemCount: childCount ?? 0,
          itemBuilder: (context, index) => const IndentedWidget(
            depth: 1,
            child: ItemLoadingTile(type: ItemType.comment),
          ),
        ),
        nonEmpty: () => SuperSliverListExtension.builder(
          listController: listController,
          itemCount: state.viewableData!.length,
          itemBuilder: (context, index) {
            final descendant = state.viewableData![index];
            return IndentedWidget(
              depth: descendant.isPart ? 0 : descendant.depth,
              child: ItemTile.create(
                _itemCubitFactory,
                _authCubit,
                _settingsCubit,
                id: descendant.id,
                storyUsername: storyUsername,
                loadingType: ItemType.comment,
                collapsedCount: state.collapsedIds.contains(descendant.id)
                    ? state.getDescendants(descendant)?.length
                    : null,
                showVisited: false,
                highlight: !(state.previousData
                        ?.map((e) => e.id)
                        .contains(descendant.id) ??
                    true),
                onTap: (context, item) async {
                  if (!item.isDeleted) {
                    _itemTreeCubit.toggleCollapsed(item.id);
                  }

                  await Scrollable.ensureVisible(
                    context,
                    duration: AppAnimation.standard.duration,
                    curve: AppAnimation.standard.easing,
                    alignmentPolicy:
                        ScrollPositionAlignmentPolicy.keepVisibleAtStart,
                  );
                },
              ),
            );
          },
        ),
        onRetry: () async => _itemTreeCubit.load(),
      ),
    );
  }
}
