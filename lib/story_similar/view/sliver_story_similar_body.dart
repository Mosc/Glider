import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/app/container/app_container.dart';
import 'package:glider/app/models/app_route.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/common/extensions/theme_data_extension.dart';
import 'package:glider/common/extensions/widget_list_extension.dart';
import 'package:glider/common/mixins/data_mixin.dart';
import 'package:glider/common/widgets/metadata_widget.dart';
import 'package:glider/item/models/item_style.dart';
import 'package:glider/item/widgets/item_tile.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';
import 'package:glider/settings/cubit/settings_cubit.dart';
import 'package:glider/story_similar/cubit/story_similar_cubit.dart';
import 'package:glider_domain/glider_domain.dart';
import 'package:go_router/go_router.dart';

class SliverStorySimilarBody extends StatelessWidget {
  const SliverStorySimilarBody(
    this._storySimilarCubit,
    this._itemCubitFactory,
    this._authCubit,
    this._settingsCubit, {
    super.key,
    this.storyUsername,
  });

  final StorySimilarCubit _storySimilarCubit;
  final ItemCubitFactory _itemCubitFactory;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;
  final String? storyUsername;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StorySimilarCubit, StorySimilarState>(
      bloc: _storySimilarCubit,
      builder: (context, state) => state.whenOrDefaultSlivers(
        loading: SliverToBoxAdapter.new,
        empty: SliverToBoxAdapter.new,
        nonEmpty: () => _buildData(context, state),
        failure: SliverToBoxAdapter.new,
      ),
    );
  }

  Widget _buildData(BuildContext context, StorySimilarState state) {
    return SliverPadding(
      padding: AppSpacing.defaultTilePadding.copyWith(top: 0),
      sliver: DecoratedSliver(
        decoration: Theme.of(context).elevationToBoxDecoration(1).copyWith(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
        sliver: SliverMainAxisGroup(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: AppSpacing.defaultShadowPadding +
                    AppSpacing.defaultTilePadding,
                child: Row(
                  children: [
                    const MetadataWidget(icon: Icons.forum_outlined),
                    Text(
                      context.l10n.similarDiscussions,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ].spaced(width: AppSpacing.l),
                ),
              ),
            ),
            SliverList.list(
              children: [
                for (final id in state.data!)
                  Padding(
                    padding: AppSpacing.defaultShadowPadding,
                    child: Material(
                      type: MaterialType.transparency,
                      child: ItemTile.create(
                        _itemCubitFactory,
                        _authCubit,
                        _settingsCubit,
                        key: ValueKey<int>(id),
                        id: id,
                        storyUsername: storyUsername,
                        loadingType: ItemType.story,
                        style: ItemStyle.primary,
                        onTap: (context, item) async => context.push(
                          AppRoute.item.location(parameters: {'id': id}),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
