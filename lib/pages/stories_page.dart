import 'dart:async';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/models/search_range.dart';
import 'package:glider/models/stories_menu_action.dart';
import 'package:glider/models/story_type.dart';
import 'package:glider/pages/account_page.dart';
import 'package:glider/pages/favorites_page.dart';
import 'package:glider/pages/stories_search_page.dart';
import 'package:glider/pages/submit_page.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/repositories/auth_repository.dart';
import 'package:glider/utils/pagination_mixin.dart';
import 'package:glider/utils/scaffold_messenger_state_extension.dart';
import 'package:glider/widgets/appearance/appearance_bottom_sheet.dart';
import 'package:glider/widgets/common/floating_app_bar_scroll_view.dart';
import 'package:glider/widgets/items/stories_body.dart';
import 'package:glider/widgets/settings/settings_bottom_sheet.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final AutoDisposeStateProvider<StoryType> storyTypeStateProvider =
    StateProvider.autoDispose<StoryType>(
  (AutoDisposeStateProviderRef<StoryType> ref) => StoryType.topStories,
);

final AutoDisposeStateProvider<int> storyPaginationStateProvider =
    StateProvider.autoDispose<int>(
  (AutoDisposeStateProviderRef<int> ref) => PaginationMixin.initialPage,
);

class StoriesPage extends HookConsumerWidget with PaginationMixin {
  const StoriesPage({Key? key}) : super(key: key);

  @override
  AutoDisposeStateProvider<int> get paginationStateProvider =>
      storyPaginationStateProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: FloatingAppBarScrollView(
        title: Text(ref.watch(storyTypeStateProvider).title(context)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(FluentIcons.search_24_regular),
            tooltip: AppLocalizations.of(context).search,
            onPressed: () => _searchSelected(context, ref),
          ),
          PopupMenuButton<StoryType>(
            itemBuilder: (_) => <PopupMenuEntry<StoryType>>[
              for (StoryType storyType in StoryType.values)
                if (storyType.visible(context, ref))
                  PopupMenuItem<StoryType>(
                    value: storyType,
                    child: Text(storyType.title(context)),
                  ),
            ],
            onSelected: (StoryType storyType) {
              resetPagination(ref);
              ref.read(storyTypeStateProvider.state).update((_) => storyType);
            },
            tooltip: AppLocalizations.of(context).storyType,
            icon: const Icon(FluentIcons.filter_24_regular),
          ),
          PopupMenuButton<StoriesMenuAction>(
            itemBuilder: (_) => <PopupMenuEntry<StoriesMenuAction>>[
              for (StoriesMenuAction menuAction in StoriesMenuAction.values)
                PopupMenuItem<StoriesMenuAction>(
                  value: menuAction,
                  child: Text(menuAction.title(context)),
                ),
            ],
            onSelected: (StoriesMenuAction menuAction) async {
              switch (menuAction) {
                case StoriesMenuAction.catchUp:
                  return _catchUpSelected(context);
                case StoriesMenuAction.favorites:
                  return _favoritesSelected(context);
                case StoriesMenuAction.submit:
                  return _submitSelected(context, ref);
                case StoriesMenuAction.appearance:
                  return _appearanceSelected(context);
                case StoriesMenuAction.settings:
                  return _settingsSelected(context);
                case StoriesMenuAction.account:
                  return _accountSelected(context);
              }
            },
            icon: const Icon(FluentIcons.more_vertical_24_regular),
          ),
        ],
        body: const StoriesBody(),
      ),
    );
  }

  Future<void> _searchSelected(BuildContext context, WidgetRef ref) {
    ref
        .read(storySearchRangeStateProvider.state)
        .update((_) => SearchRange.pastYear);
    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const StoriesSearchPage(),
      ),
    );
  }

  Future<void> _catchUpSelected(BuildContext context) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const StoriesSearchPage.catchUp(),
      ),
    );
  }

  Future<void> _favoritesSelected(BuildContext context) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const FavoritesPage(),
      ),
    );
  }

  Future<void> _submitSelected(BuildContext context, WidgetRef ref) async {
    final AuthRepository authRepository = ref.read(authRepositoryProvider);

    if (await authRepository.loggedIn) {
      final bool success = await Navigator.of(context).push<bool>(
            MaterialPageRoute<bool>(
              builder: (_) => const SubmitPage(),
              fullscreenDialog: true,
            ),
          ) ??
          false;

      if (success) {
        unawaited(
          ref
              .read(storyIdsNotifierProvider(StoryType.newStories).notifier)
              .forceLoad(),
        );
        ref
            .read(storyTypeStateProvider.state)
            .update((_) => StoryType.newStories);
        ScaffoldMessenger.of(context).replaceSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).processingInfo),
            action: SnackBarAction(
              label: AppLocalizations.of(context).refresh,
              onPressed: () => ref
                  .read(storyIdsNotifierProvider(StoryType.newStories).notifier)
                  .forceLoad(),
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).replaceSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).submitNotLoggedIn),
          action: SnackBarAction(
            label: AppLocalizations.of(context).logIn,
            onPressed: () => Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (_) => const AccountPage(),
              ),
            ),
          ),
        ),
      );
    }
  }

  Future<void> _appearanceSelected(BuildContext context) async {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const AppearanceBottomSheet(),
    );
  }

  Future<void> _settingsSelected(BuildContext context) async {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const SettingsBottomSheet(),
    );
  }

  Future<void> _accountSelected(BuildContext context) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const AccountPage(),
      ),
    );
  }
}
