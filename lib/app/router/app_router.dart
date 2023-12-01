import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:glider/app/container/app_container.dart';
import 'package:glider/app/models/app_route.dart';
import 'package:glider/app/models/dialog_page.dart';
import 'package:glider/auth/view/auth_page.dart';
import 'package:glider/common/widgets/confirm_dialog.dart';
import 'package:glider/common/widgets/text_select_dialog.dart';
import 'package:glider/edit/view/edit_page.dart';
import 'package:glider/favorites/view/favorites_shell_page.dart';
import 'package:glider/inbox/view/inbox_shell_page.dart';
import 'package:glider/item/view/item_page.dart';
import 'package:glider/item/widgets/item_value_dialog.dart';
import 'package:glider/navigation_shell/widgets/navigation_shell_scaffold.dart';
import 'package:glider/reply/view/reply_page.dart';
import 'package:glider/settings/view/filters_dialog.dart';
import 'package:glider/settings/view/settings_page.dart';
import 'package:glider/settings/widgets/theme_color_dialog.dart';
import 'package:glider/stories/view/stories_shell_page.dart';
import 'package:glider/stories_search/view/catch_up_shell_page.dart';
import 'package:glider/submit/view/submit_page.dart';
import 'package:glider/user/view/user_page.dart';
import 'package:glider/user/widgets/user_value_dialog.dart';
import 'package:glider/whats_new/view/whats_new_page.dart';
import 'package:go_router/go_router.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  AppRouter._(this.config);

  factory AppRouter.create(AppContainer appContainer) {
    return AppRouter._(
      GoRouter(
        navigatorKey: rootNavigatorKey,
        initialLocation: AppRoute.stories.location(),
        debugLogDiagnostics: kDebugMode,
        routes: [
          StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) =>
                NavigationShellScaffold(
              appContainer.navigationShellCubit,
              appContainer.authCubit,
              navigationShell,
            ),
            branches: [
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: AppRoute.stories.path,
                    pageBuilder: (context, state) => NoTransitionPage<void>(
                      child: StoriesShellPage(
                        appContainer.storiesCubit,
                        appContainer.storiesSearchBloc,
                        appContainer.itemCubitFactory,
                        appContainer.authCubit,
                        appContainer.settingsCubit,
                      ),
                    ),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: AppRoute.catchUp.path,
                    pageBuilder: (context, state) => NoTransitionPage<void>(
                      child: CatchUpShellPage(
                        appContainer.catchUpBloc,
                        appContainer.itemCubitFactory,
                        appContainer.authCubit,
                        appContainer.settingsCubit,
                      ),
                    ),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: AppRoute.favorites.path,
                    pageBuilder: (context, state) => NoTransitionPage<void>(
                      child: FavoritesShellPage(
                        appContainer.favoritesCubit,
                        appContainer.itemCubitFactory,
                        appContainer.authCubit,
                        appContainer.settingsCubit,
                      ),
                    ),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: AppRoute.inbox.path,
                    pageBuilder: (context, state) => NoTransitionPage<void>(
                      child: InboxShellPage(
                        appContainer.inboxCubit,
                        appContainer.itemCubitFactory,
                        appContainer.authCubit,
                        appContainer.settingsCubit,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: AppRoute.whatsNew.path,
            pageBuilder: (context, state) => MaterialPage<void>(
              fullscreenDialog: true,
              child: WhatsNewPage(
                appContainer.settingsCubit,
              ),
            ),
            parentNavigatorKey: rootNavigatorKey,
          ),
          GoRoute(
            path: AppRoute.auth.path,
            pageBuilder: (context, state) => MaterialPage<void>(
              fullscreenDialog: true,
              child: AuthPage(
                appContainer.authCubit,
                appContainer.settingsCubit,
                appContainer.userCubitFactory,
                appContainer.itemCubitFactory,
                appContainer.userItemSearchBlocFactory,
              ),
            ),
            parentNavigatorKey: rootNavigatorKey,
          ),
          GoRoute(
            path: AppRoute.settings.path,
            pageBuilder: (context, state) => MaterialPage<void>(
              fullscreenDialog: true,
              child: SettingsPage(
                appContainer.settingsCubit,
              ),
            ),
            parentNavigatorKey: rootNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoute.themeColorDialog.path,
                pageBuilder: (context, state) => DialogPage<Color>(
                  builder: (context) => ThemeColorDialog(
                    selectedColor: state.extra as Color?,
                  ),
                ),
                parentNavigatorKey: rootNavigatorKey,
              ),
              GoRoute(
                path: AppRoute.filtersDialog.path,
                pageBuilder: (context, state) => DialogPage<void>(
                  builder: (context) => FiltersDialog(
                    appContainer.settingsCubit,
                  ),
                ),
                parentNavigatorKey: rootNavigatorKey,
              ),
            ],
          ),
          GoRoute(
            path: AppRoute.submit.path,
            pageBuilder: (context, state) => MaterialPage<void>(
              fullscreenDialog: true,
              child: SubmitPage(
                appContainer.submitCubit,
                appContainer.authCubit,
                appContainer.settingsCubit,
              ),
            ),
            parentNavigatorKey: rootNavigatorKey,
          ),
          GoRoute(
            path: AppRoute.item.path,
            pageBuilder: (context, state) => MaterialPage<void>(
              child: ItemPage(
                appContainer.itemCubitFactory,
                appContainer.itemTreeCubitFactory,
                appContainer.storySimilarCubitFactory,
                appContainer.storyItemSearchCubitFactory,
                appContainer.authCubit,
                appContainer.settingsCubit,
                id: int.parse(state.uri.queryParameters['id']!),
              ),
            ),
            parentNavigatorKey: rootNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoute.edit.path,
                pageBuilder: (context, state) => MaterialPage<void>(
                  fullscreenDialog: true,
                  child: EditPage(
                    appContainer.editCubitFactory,
                    appContainer.settingsCubit,
                    id: int.parse(state.uri.queryParameters['id']!),
                  ),
                ),
                parentNavigatorKey: rootNavigatorKey,
              ),
              GoRoute(
                path: AppRoute.reply.path,
                pageBuilder: (context, state) => MaterialPage<void>(
                  fullscreenDialog: true,
                  child: ReplyPage(
                    appContainer.replyCubitFactory,
                    appContainer.authCubit,
                    appContainer.settingsCubit,
                    id: int.parse(state.uri.queryParameters['id']!),
                  ),
                ),
                parentNavigatorKey: rootNavigatorKey,
              ),
              GoRoute(
                path: AppRoute.itemValueDialog.path,
                pageBuilder: (context, state) => DialogPage<void>(
                  builder: (context) => ItemValueDialog(
                    appContainer.itemCubitFactory,
                    appContainer.authCubit,
                    appContainer.settingsCubit,
                    id: int.parse(state.uri.queryParameters['id']!),
                    title: state.extra as String?,
                  ),
                ),
                parentNavigatorKey: rootNavigatorKey,
              ),
            ],
          ),
          GoRoute(
            path: AppRoute.user.path,
            pageBuilder: (context, state) => MaterialPage<void>(
              child: UserPage(
                appContainer.userCubitFactory,
                appContainer.itemCubitFactory,
                appContainer.userItemSearchBlocFactory,
                appContainer.authCubit,
                appContainer.settingsCubit,
                username: state.uri.queryParameters['id']!,
              ),
            ),
            parentNavigatorKey: rootNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoute.userValueDialog.path,
                pageBuilder: (context, state) => DialogPage<void>(
                  builder: (context) => UserValueDialog(
                    appContainer.userCubitFactory,
                    appContainer.authCubit,
                    appContainer.settingsCubit,
                    username: state.uri.queryParameters['id']!,
                    title: state.extra as String?,
                  ),
                ),
                parentNavigatorKey: rootNavigatorKey,
              ),
            ],
          ),
          GoRoute(
            path: AppRoute.textSelectDialog.path,
            pageBuilder: (context, state) => DialogPage<void>(
              builder: (context) => TextSelectDialog(
                text: state.extra! as String,
              ),
            ),
            parentNavigatorKey: rootNavigatorKey,
          ),
          GoRoute(
            path: AppRoute.confirmDialog.path,
            pageBuilder: (context, state) => DialogPage<void>(
              builder: (context) => ConfirmDialog(
                title: (state.extra as ConfirmDialogExtra?)?.title,
                text: (state.extra as ConfirmDialogExtra?)?.text,
              ),
            ),
            parentNavigatorKey: rootNavigatorKey,
          ),
        ],
      ),
    );
  }

  final RouterConfig<Object> config;
}
