import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/app/container/app_container.dart';
import 'package:glider/app/models/app_route.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';
import 'package:glider/common/mixins/data_mixin.dart';
import 'package:glider/common/widgets/app_bar_progress_indicator.dart';
import 'package:glider/common/widgets/empty_widget.dart';
import 'package:glider/common/widgets/refreshable_scroll_view.dart';
import 'package:glider/history/cubit/history_cubit.dart';
import 'package:glider/item/widgets/item_loading_tile.dart';
import 'package:glider/item/widgets/item_tile.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';
import 'package:glider/navigation_shell/models/navigation_shell_action.dart';
import 'package:glider/settings/cubit/settings_cubit.dart';
import 'package:glider_domain/glider_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HistoryShellPage extends StatefulWidget {
  const HistoryShellPage(
    this._historyCubit,
    this._itemCubitFactory,
    this._authCubit,
    this._settingsCubit, {
    super.key,
  });

  final HistoryCubit _historyCubit;
  final ItemCubitFactory _itemCubitFactory;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;

  @override
  State<HistoryShellPage> createState() => _HistoryShellPageState();
}

class _HistoryShellPageState extends State<HistoryShellPage> {
  @override
  void initState() {
    unawaited(widget._historyCubit.load());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: RefreshableScrollView(
        onRefresh: () async => unawaited(widget._historyCubit.load()),
        slivers: [
          _SliverHistoryAppBar(
            widget._historyCubit,
            widget._authCubit,
          ),
          SliverSafeArea(
            top: false,
            sliver: _SliverHistoryBody(
              widget._historyCubit,
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

class _SliverHistoryAppBar extends StatelessWidget {
  const _SliverHistoryAppBar(this._historyCubit, this._authCubit);

  final HistoryCubit _historyCubit;
  final AuthCubit _authCubit;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(context.l10n.history),
      flexibleSpace: AppBarProgressIndicator(_historyCubit),
      actions: [
        BlocBuilder<AuthCubit, AuthState>(
          bloc: _authCubit,
          buildWhen: (previous, current) =>
              previous.isLoggedIn != current.isLoggedIn,
          builder: (context, authState) => MenuAnchor(
            menuChildren: [
              for (final action in NavigationShellAction.values)
                if (action.isVisible(null, authState))
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
      ],
      floating: true,
    );
  }
}

class _SliverHistoryBody extends StatelessWidget {
  const _SliverHistoryBody(
    this._historyCubit,
    this._itemCubitFactory,
    this._authCubit,
    this._settingsCubit,
  );

  final HistoryCubit _historyCubit;
  final ItemCubitFactory _itemCubitFactory;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMMd().add_Hm();

    return BlocBuilder<HistoryCubit, HistoryState>(
      bloc: _historyCubit,
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
          success: () => switch (state.data) {
            final data when data == null || data.isEmpty =>
              const SliverFillRemaining(
                hasScrollBody: false,
                child: SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyWidget(),
                ),
              ),
            _ => SliverList.list(
                children: [
                  for (final MapEntry(key: id, value: readAt) in state
                      .data!.entries
                      .sortedBy((element) => element.value ?? DateTime(0))
                      .reversed) ...[
                    if (readAt != null) Text(dateFormat.format(readAt)),
                    ItemTile.create(
                      _itemCubitFactory,
                      _authCubit,
                      key: ValueKey<int>(id),
                      id: id,
                      loadingType: ItemType.story,
                      useLargeStoryStyle: settingsState.useLargeStoryStyle,
                      useActionButtons: settingsState.useActionButtons,
                      onTap: (context, item) async => context.push(
                        AppRoute.item.location(parameters: {'id': id}),
                      ),
                    ),
                  ],
                ],
              ),
          },
          onRetry: () async => _historyCubit.load(),
        ),
      ),
    );
  }
}
