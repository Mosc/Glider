import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/app/container/app_container.dart';
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

class SliverItemTreeBody extends StatelessWidget {
  const SliverItemTreeBody(
    this._itemTreeCubit,
    this._itemCubitFactory,
    this._authCubit,
    this._settingsCubit, {
    super.key,
    this.childCount,
    this.storyUsername,
  });

  final ItemTreeCubit _itemTreeCubit;
  final ItemCubitFactory _itemCubitFactory;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;
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
      builder: (context, state) => BlocBuilder<SettingsCubit, SettingsState>(
        bloc: _settingsCubit,
        buildWhen: (previous, current) =>
            previous.useActionButtons != current.useActionButtons,
        builder: (context, settingsState) => state.whenOrDefaultSlivers(
          loading: () => SliverList.builder(
            itemBuilder: (context, index) => const IndentedWidget(
              depth: 1,
              child: ItemLoadingTile(type: ItemType.comment),
            ),
            itemCount: childCount,
          ),
          nonEmpty: () => SliverList.builder(
            itemCount: state.viewableData!.length,
            itemBuilder: (context, index) => _buildItemTile(
              state.viewableData![index],
              state,
              settingsState,
            ),
          ),
          onRetry: () async => _itemTreeCubit.load(),
        ),
      ),
    );
  }

  Widget _buildItemTile(
    ItemDescendant descendant,
    ItemTreeState state,
    SettingsState settingsState,
  ) {
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
        highlight:
            !(state.previousData?.map((e) => e.id).contains(descendant.id) ??
                true),
        onTap: (context, item) async {
          if (!item.isDeleted) {
            _itemTreeCubit.toggleCollapsed(item.id);
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
