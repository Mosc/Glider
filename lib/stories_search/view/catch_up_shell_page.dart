import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/app/container/app_container.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/common/widgets/app_bar_progress_indicator.dart';
import 'package:glider/common/widgets/refreshable_scroll_view.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';
import 'package:glider/navigation_shell/models/navigation_shell_action.dart';
import 'package:glider/settings/cubit/settings_cubit.dart';
import 'package:glider/stories_search/bloc/stories_search_bloc.dart';
import 'package:glider/stories_search/view/sliver_stories_search_body.dart';
import 'package:glider/stories_search/view/stories_search_range_view.dart';

class CatchUpShellPage extends StatefulWidget {
  const CatchUpShellPage(
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
  State<CatchUpShellPage> createState() => _CatchUpShellPageState();
}

class _CatchUpShellPageState extends State<CatchUpShellPage> {
  @override
  void initState() {
    super.initState();
    widget._storiesSearchBloc.add(const LoadStoriesSearchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: RefreshableScrollView(
        onRefresh: () async =>
            widget._storiesSearchBloc.add(const LoadStoriesSearchEvent()),
        slivers: [
          _SliverCatchUpAppBar(
            widget._storiesSearchBloc,
            widget._authCubit,
            widget._settingsCubit,
          ),
          SliverToBoxAdapter(
            child: StoriesSearchRangeView(widget._storiesSearchBloc),
          ),
          SliverSafeArea(
            top: false,
            sliver: SliverStoriesSearchBody(
              widget._storiesSearchBloc,
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

class _SliverCatchUpAppBar extends StatelessWidget {
  const _SliverCatchUpAppBar(
    this._storiesSearchBloc,
    this._authCubit,
    this._settingsCubit,
  );

  final StoriesSearchBloc _storiesSearchBloc;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(context.l10n.catchUp),
      flexibleSpace: AppBarProgressIndicator(_storiesSearchBloc),
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
