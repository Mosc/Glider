import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/app/container/app_container.dart';
import 'package:glider/app/models/app_route.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/common/mixins/data_mixin.dart';
import 'package:glider/item/models/item_style.dart';
import 'package:glider/item/widgets/item_loading_tile.dart';
import 'package:glider/item/widgets/item_tile.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';
import 'package:glider/settings/cubit/settings_cubit.dart';
import 'package:glider/stories_search/bloc/stories_search_bloc.dart';
import 'package:glider_domain/glider_domain.dart';
import 'package:go_router/go_router.dart';

class SliverStoriesSearchBody extends StatelessWidget {
  const SliverStoriesSearchBody(
    this._storiesSearchBloc,
    this._itemCubitFactory,
    this._authCubit,
    this._settingsCubit, {
    super.key,
  });

  final StoriesSearchBloc _storiesSearchBloc;
  final ItemCubitFactory _itemCubitFactory;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoriesSearchBloc, StoriesSearchState>(
      bloc: _storiesSearchBloc,
      builder: (context, state) => BlocBuilder<SettingsCubit, SettingsState>(
        bloc: _settingsCubit,
        buildWhen: (previous, current) =>
            previous.useLargeStoryStyle != current.useLargeStoryStyle ||
            previous.showStoryMetadata != current.showStoryMetadata ||
            previous.useActionButtons != current.useActionButtons,
        builder: (context, settingsState) => state.whenOrDefaultSlivers(
          loading: () => SliverList.builder(
            itemBuilder: (context, index) => ItemLoadingTile(
              type: ItemType.story,
              useLargeStoryStyle: settingsState.useLargeStoryStyle,
              showMetadata: settingsState.showStoryMetadata,
              style: ItemStyle.overview,
            ),
          ),
          nonEmpty: () => SliverMainAxisGroup(
            slivers: [
              SliverList.list(
                children: [
                  for (final id in state.loadedData!)
                    ItemTile.create(
                      _itemCubitFactory,
                      _authCubit,
                      key: ValueKey<int>(id),
                      id: id,
                      loadingType: ItemType.story,
                      useLargeStoryStyle: settingsState.useLargeStoryStyle,
                      showMetadata: settingsState.showStoryMetadata,
                      useActionButtons: settingsState.useActionButtons,
                      style: ItemStyle.overview,
                      onTap: (context, item) async => context.push(
                        AppRoute.item.location(parameters: {'id': id}),
                      ),
                    ),
                ],
              ),
              if (state.loadedData!.length < state.data!.length)
                SliverPadding(
                  padding: AppSpacing.defaultTilePadding,
                  sliver: SliverToBoxAdapter(
                    child: OutlinedButton.icon(
                      onPressed: _storiesSearchBloc.showMore,
                      style: OutlinedButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: const Icon(Icons.expand_more_outlined),
                      label: Text(context.l10n.showMore),
                    ),
                  ),
                ),
            ],
          ),
          onRetry: () async =>
              _storiesSearchBloc.add(const LoadStoriesSearchEvent()),
        ),
      ),
    );
  }
}
