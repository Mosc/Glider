import 'dart:async';
import 'dart:math';

import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/app/models/app_route.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';
import 'package:glider/navigation_shell/cubit/navigation_shell_cubit.dart';
import 'package:glider/settings/cubit/settings_cubit.dart';
import 'package:go_router/go_router.dart';

// Height based on `_NavigationBarDefaultsM3`.
const _navigationBarHeight = 80.0;

class NavigationShellScaffold extends StatefulWidget {
  const NavigationShellScaffold(
    this._navigationShellCubit,
    this._authCubit,
    this._settingsCubit,
    this._navigationShell, {
    super.key,
  });

  final NavigationShellCubit _navigationShellCubit;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;
  final StatefulNavigationShell _navigationShell;

  @override
  State<NavigationShellScaffold> createState() =>
      _NavigationShellScaffoldState();
}

class _NavigationShellScaffoldState extends State<NavigationShellScaffold> {
  late final ValueNotifier<double> _currentNavigationBarHeightNotifier;

  int get _currentIndex => widget._navigationShell.currentIndex;

  double get _paddedNavigationBarHeight =>
      _navigationBarHeight + MediaQuery.viewPaddingOf(context).bottom;

  void onDestinationSelected(int index) => widget._navigationShell
      .goBranch(index, initialLocation: index == _currentIndex);

  @override
  void initState() {
    super.initState();
    unawaited(widget._navigationShellCubit.init());
    _currentNavigationBarHeightNotifier = ValueNotifier(0);
  }

  @override
  void didChangeDependencies() {
    _currentNavigationBarHeightNotifier.value = _paddedNavigationBarHeight;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _currentNavigationBarHeightNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocPresentationListener<NavigationShellCubit,
        NavigationShellCubitEvent>(
      bloc: widget._navigationShellCubit,
      listener: (context, event) => switch (event) {
        ShowWhatsNewEvent() => context.push(AppRoute.whatsNew.location()),
      },
      child: BlocSelector<AuthCubit, AuthState, bool>(
        bloc: widget._authCubit,
        selector: (state) => state.isLoggedIn,
        builder: (context, isLoggedIn) =>
            BlocBuilder<SettingsCubit, SettingsState>(
          bloc: widget._settingsCubit,
          buildWhen: (previous, current) =>
              previous.useNavigationDrawer != current.useNavigationDrawer,
          builder: (context, settingsState) {
            final destinations = [
              NavigationDestination(
                icon: const Icon(Icons.whatshot_outlined),
                selectedIcon: const Icon(Icons.whatshot),
                label: context.l10n.stories,
              ),
              NavigationDestination(
                icon: const Icon(Icons.fast_rewind_outlined),
                selectedIcon: const Icon(Icons.fast_rewind),
                label: context.l10n.catchUp,
              ),
              NavigationDestination(
                icon: const Icon(Icons.favorite_outline_outlined),
                selectedIcon: const Icon(Icons.favorite),
                label: context.l10n.favorites,
              ),
              if (isLoggedIn)
                NavigationDestination(
                  icon: const Icon(Icons.inbox_outlined),
                  selectedIcon: const Icon(Icons.inbox),
                  label: context.l10n.inbox,
                ),
            ];
            final floatingActionButton = isLoggedIn
                ? FloatingActionButton(
                    onPressed: () => context.push(AppRoute.submit.location()),
                    tooltip: context.l10n.submit,
                    child: const Icon(Icons.add_outlined),
                  )
                : null;

            return AdaptiveLayout(
              primaryNavigation: settingsState.useNavigationDrawer
                  ? null
                  : SlotLayout(
                      config: <Breakpoint, SlotLayoutConfig>{
                        Breakpoints.mediumAndUp: SlotLayout.from(
                          key: const Key('primaryNavigationMediumAndUp'),
                          builder: (context) => _buildPrimaryNavigation(
                            context,
                            destinations,
                            leading: floatingActionButton,
                          ),
                        ),
                      },
                    ),
              bottomNavigation: settingsState.useNavigationDrawer
                  ? null
                  : SlotLayout(
                      config: {
                        Breakpoints.small: SlotLayout.from(
                          key: const Key('bottomNavigationStandard'),
                          builder: (context) => _buildBottomNavigation(
                            context,
                            destinations,
                          ),
                        ),
                      },
                    ),
              body: SlotLayout(
                config: {
                  Breakpoints.standard: SlotLayout.from(
                    key: const Key('bodyStandard'),
                    builder: (context) => _buildBody(
                      context,
                      destinations,
                      floatingActionButton: floatingActionButton,
                      useNavigationDrawer: settingsState.useNavigationDrawer,
                    ),
                  ),
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPrimaryNavigation(
    BuildContext context,
    List<NavigationDestination> destinations, {
    Widget? leading,
  }) {
    final padding = MediaQuery.paddingOf(context);
    final directionality = Directionality.of(context);

    return Material(
      child: AdaptiveScaffold.standardNavigationRail(
        width: 80 +
            switch (directionality) {
              TextDirection.ltr => padding.left,
              TextDirection.rtl => padding.right,
            },
        labelType: NavigationRailLabelType.all,
        groupAlignment: 0,
        leading: leading,
        destinations: [
          for (final destination in destinations)
            NavigationRailDestination(
              icon: destination.icon,
              selectedIcon: destination.selectedIcon,
              label: Text(destination.label),
            ),
        ],
        selectedIndex: _currentIndex,
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }

  Widget _buildBottomNavigation(
    BuildContext context,
    List<NavigationDestination> destinations,
  ) {
    return ValueListenableBuilder(
      valueListenable: _currentNavigationBarHeightNotifier,
      builder: (context, currentNavigationBarHeight, child) => Align(
        heightFactor: currentNavigationBarHeight / _paddedNavigationBarHeight,
        alignment: Alignment.topCenter,
        child: child,
      ),
      child: AdaptiveScaffold.standardBottomNavigationBar(
        destinations: destinations,
        currentIndex: _currentIndex,
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    List<NavigationDestination> destinations, {
    Widget? floatingActionButton,
    bool useNavigationDrawer = false,
  }) {
    final directionality = Directionality.of(context);
    final mediaQuery = MediaQuery.of(context);
    final padding = mediaQuery.padding;
    final viewPadding = mediaQuery.viewPadding;
    final isSmallBreakpointActive = Breakpoints.small.isActive(context);
    final hasNavigationBar = !useNavigationDrawer && isSmallBreakpointActive;
    final hasNavigationRail = !useNavigationDrawer && !isSmallBreakpointActive;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        final distance = switch (notification) {
          // Process in-range updates as normal. Ignore at-edge updates, because
          // it appears to cause false positives on bounces back.
          ScrollUpdateNotification(
            metrics: ScrollMetrics(outOfRange: false, atEdge: false)
          ) ||
          // Also process out-of-range updates, but require that they are the
          // result of a drag. This enables showing and hiding the navigation
          // bar similar to when overscroll occurs.
          ScrollUpdateNotification(dragDetails: DragUpdateDetails()) =>
            notification.scrollDelta,
          OverscrollNotification() => notification.overscroll,
          _ => null,
        };

        if (distance != null && notification.metrics.axis == Axis.vertical) {
          _currentNavigationBarHeightNotifier.value = clampDouble(
            _currentNavigationBarHeightNotifier.value - distance,
            0,
            _navigationBarHeight + viewPadding.bottom,
          );
        }

        return false;
      },
      child: ValueListenableBuilder(
        valueListenable: _currentNavigationBarHeightNotifier,
        builder: (context, currentNavigationBarHeight, child) {
          double? calculateBottomPadding(EdgeInsets padding) => hasNavigationBar
              ? max(0, padding.bottom - currentNavigationBarHeight)
              : null;

          return MediaQuery(
            data: mediaQuery.copyWith(
              padding: padding.copyWith(
                left: hasNavigationRail && directionality == TextDirection.ltr
                    ? 0
                    : null,
                right: hasNavigationRail && directionality == TextDirection.rtl
                    ? 0
                    : null,
                bottom: calculateBottomPadding(padding),
              ),
              viewPadding: viewPadding.copyWith(
                bottom: calculateBottomPadding(viewPadding),
              ),
              viewInsets: EdgeInsets.zero,
            ),
            child: child!,
          );
        },
        child: Scaffold(
          drawer: useNavigationDrawer
              ? NavigationDrawer(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (index) {
                    onDestinationSelected(index);
                    Navigator.pop(context);
                  },
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      child: Text(
                        context.l10n.appName,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    for (final destination in destinations)
                      NavigationDrawerDestination(
                        icon: destination.icon,
                        selectedIcon: destination.selectedIcon,
                        label: Text(destination.label),
                      ),
                  ],
                )
              : null,
          body: widget._navigationShell,
          floatingActionButton: hasNavigationRail ? null : floatingActionButton,
        ),
      ),
    );
  }
}
