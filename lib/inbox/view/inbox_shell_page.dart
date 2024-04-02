import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/app/container/app_container.dart';
import 'package:glider/app/extensions/super_sliver_list_extension.dart';
import 'package:glider/app/models/app_route.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/common/mixins/data_mixin.dart';
import 'package:glider/common/mixins/paginated_list_mixin.dart';
import 'package:glider/common/widgets/app_bar_progress_indicator.dart';
import 'package:glider/common/widgets/refreshable_scroll_view.dart';
import 'package:glider/inbox/cubit/inbox_cubit.dart';
import 'package:glider/item/widgets/indented_widget.dart';
import 'package:glider/item/widgets/item_loading_tile.dart';
import 'package:glider/item/widgets/item_tile.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';
import 'package:glider/navigation_shell/models/navigation_shell_action.dart';
import 'package:glider/settings/cubit/settings_cubit.dart';
import 'package:glider_domain/glider_domain.dart';
import 'package:go_router/go_router.dart';

class InboxShellPage extends StatefulWidget {
  const InboxShellPage(
    this._inboxCubit,
    this._itemCubitFactory,
    this._authCubit,
    this._settingsCubit, {
    super.key,
  });

  final InboxCubit _inboxCubit;
  final ItemCubitFactory _itemCubitFactory;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;

  @override
  State<InboxShellPage> createState() => _InboxShellPageState();
}

class _InboxShellPageState extends State<InboxShellPage> {
  @override
  void initState() {
    super.initState();
    unawaited(widget._inboxCubit.load());
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: RefreshableScrollView(
        onRefresh: () async => unawaited(widget._inboxCubit.load()),
        slivers: [
          _SliverInboxAppBar(
            widget._inboxCubit,
            widget._authCubit,
            widget._settingsCubit,
          ),
          SliverSafeArea(
            top: false,
            sliver: _SliverInboxBody(
              widget._inboxCubit,
              widget._itemCubitFactory,
              widget._authCubit,
              widget._settingsCubit,
            ),
          ),
          const SliverPadding(
            padding: AppSpacing.floatingActionButtonPageBottomPadding,
          ),
        ],
      ),
    );
  }
}

class _SliverInboxAppBar extends StatelessWidget {
  const _SliverInboxAppBar(
    this._inboxCubit,
    this._authCubit,
    this._settingsCubit,
  );

  final InboxCubit _inboxCubit;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(context.l10n.inbox),
      flexibleSpace: AppBarProgressIndicator(_inboxCubit),
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

class _SliverInboxBody extends StatelessWidget {
  const _SliverInboxBody(
    this._inboxCubit,
    this._itemCubitFactory,
    this._authCubit,
    this._settingsCubit,
  );

  final InboxCubit _inboxCubit;
  final ItemCubitFactory _itemCubitFactory;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InboxCubit, InboxState>(
      bloc: _inboxCubit,
      builder: (context, state) => state.whenOrDefaultSlivers(
        loading: () => SuperSliverListExtension.builder(
          itemCount: PaginatedListMixin.pageSize,
          itemBuilder: (context, index) =>
              const ItemLoadingTile(type: ItemType.comment),
        ),
        nonEmpty: () => SuperSliverListExtension.builder(
          itemCount: state.data!.length,
          itemBuilder: (context, index) {
            final (parentId, id) = state.data![index];
            return Column(
              children: [
                ItemTile.create(
                  _itemCubitFactory,
                  _authCubit,
                  _settingsCubit,
                  id: parentId,
                  loadingType: ItemType.story,
                  onTap: (context, item) async => context.push(
                    AppRoute.item.location(parameters: {'id': parentId}),
                  ),
                ),
                IndentedWidget(
                  depth: 1,
                  child: ItemTile.create(
                    _itemCubitFactory,
                    _authCubit,
                    _settingsCubit,
                    id: id,
                    loadingType: ItemType.comment,
                    onTap: (context, item) async => context.push(
                      AppRoute.item.location(parameters: {'id': id}),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        onRetry: () async => _inboxCubit.load(),
      ),
    );
  }
}
