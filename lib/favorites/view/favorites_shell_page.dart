import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/app/container/app_container.dart';
import 'package:glider/app/models/app_route.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';
import 'package:glider/common/mixins/data_mixin.dart';
import 'package:glider/common/widgets/app_bar_progress_indicator.dart';
import 'package:glider/common/widgets/refreshable_scroll_view.dart';
import 'package:glider/favorites/cubit/favorites_cubit.dart';
import 'package:glider/item/widgets/item_loading_tile.dart';
import 'package:glider/item/widgets/item_tile.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';
import 'package:glider/navigation_shell/models/navigation_shell_action.dart';
import 'package:glider/settings/cubit/settings_cubit.dart';
import 'package:glider_domain/glider_domain.dart';
import 'package:go_router/go_router.dart';

class FavoritesShellPage extends StatefulWidget {
  const FavoritesShellPage(
    this._favoritesCubit,
    this._itemCubitFactory,
    this._authCubit,
    this._settingsCubit, {
    super.key,
  });

  final FavoritesCubit _favoritesCubit;
  final ItemCubitFactory _itemCubitFactory;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;

  @override
  State<FavoritesShellPage> createState() => _FavoritesShellPageState();
}

class _FavoritesShellPageState extends State<FavoritesShellPage> {
  @override
  void initState() {
    unawaited(widget._favoritesCubit.load());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: RefreshableScrollView(
        onRefresh: () async => unawaited(widget._favoritesCubit.load()),
        slivers: [
          _SliverFavoritesAppBar(
            widget._favoritesCubit,
            widget._authCubit,
            widget._settingsCubit,
          ),
          SliverSafeArea(
            top: false,
            sliver: _SliverFavoritesBody(
              widget._favoritesCubit,
              widget._itemCubitFactory,
              widget._authCubit,
              widget._settingsCubit,
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverFavoritesAppBar extends StatelessWidget {
  const _SliverFavoritesAppBar(
    this._favoritesCubit,
    this._authCubit,
    this._settingsCubit,
  );

  final FavoritesCubit _favoritesCubit;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(context.l10n.favorites),
      flexibleSpace: AppBarProgressIndicator(_favoritesCubit),
      actions: [
        BlocBuilder<AuthCubit, AuthState>(
          bloc: _authCubit,
          builder: (context, authState) =>
              BlocBuilder<SettingsCubit, SettingsState>(
            bloc: _settingsCubit,
            builder: (context, settingsState) => MenuAnchor(
              menuChildren: [
                for (final action in NavigationShellAction.values)
                  if (action.isVisible(null, authState, settingsState))
                    MenuItemButton(
                      onPressed: () async => action.execute(context),
                      child: Text(action.label(context, null)),
                    ),
              ],
              builder: (context, controller, child) => IconButton(
                icon: Icon(Icons.adaptive.more_outlined),
                tooltip: MaterialLocalizations.of(context).showMenuTooltip,
                onPressed: () =>
                    controller.isOpen ? controller.close() : controller.open(),
              ),
            ),
          ),
        ),
      ],
      floating: true,
    );
  }
}

class _SliverFavoritesBody extends StatelessWidget {
  const _SliverFavoritesBody(
    this._favoritesCubit,
    this._itemCubitFactory,
    this._authCubit,
    this._settingsCubit,
  );

  final FavoritesCubit _favoritesCubit;
  final ItemCubitFactory _itemCubitFactory;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      bloc: _favoritesCubit,
      builder: (context, state) => BlocBuilder<SettingsCubit, SettingsState>(
        bloc: _settingsCubit,
        buildWhen: (previous, current) =>
            previous.useLargeStoryStyle != current.useLargeStoryStyle ||
            previous.useActionButtons != current.useActionButtons,
        builder: (context, settingsState) => state.whenOrDefaultSlivers(
          loading: () => SliverList.builder(
            itemBuilder: (context, index) => ItemLoadingTile(
              type: ItemType.story,
              useLargeStoryStyle: settingsState.useLargeStoryStyle,
            ),
          ),
          nonEmpty: () => SliverList.list(
            children: [
              for (final id in state.data!)
                ItemTile.create(
                  _itemCubitFactory,
                  _authCubit,
                  _settingsCubit,
                  key: ValueKey<int>(id),
                  id: id,
                  loadingType: ItemType.story,
                  onTap: (context, item) async => context.push(
                    AppRoute.item.location(parameters: {'id': id}),
                  ),
                ),
            ],
          ),
          onRetry: () async => _favoritesCubit.load(),
        ),
      ),
    );
  }
}
