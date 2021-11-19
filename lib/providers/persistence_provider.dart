import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:glider/models/dark_theme.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final AutoDisposeFutureProvider<ThemeMode?> themeModeProvider =
    FutureProvider.autoDispose<ThemeMode?>(
  (AutoDisposeFutureProviderRef<ThemeMode?> ref) =>
      ref.read(storageRepositoryProvider).themeMode,
);

final AutoDisposeFutureProvider<DarkTheme?> darkThemeProvider =
    FutureProvider.autoDispose<DarkTheme?>(
  (AutoDisposeFutureProviderRef<DarkTheme?> ref) =>
      ref.read(storageRepositoryProvider).darkTheme,
);

final AutoDisposeFutureProvider<Color?> themeColorProvider =
    FutureProvider.autoDispose<Color?>(
  (AutoDisposeFutureProviderRef<Color?> ref) =>
      ref.read(storageRepositoryProvider).themeColor,
);

final AutoDisposeFutureProvider<bool> showUrlProvider =
    FutureProvider.autoDispose<bool>(
  (AutoDisposeFutureProviderRef<bool> ref) =>
      ref.read(storageRepositoryProvider).showUrl,
);

final AutoDisposeFutureProvider<bool> showFaviconProvider =
    FutureProvider.autoDispose<bool>(
  (AutoDisposeFutureProviderRef<bool> ref) =>
      ref.read(storageRepositoryProvider).showFavicon,
);

final AutoDisposeFutureProvider<bool> showMetadataProvider =
    FutureProvider.autoDispose<bool>(
  (AutoDisposeFutureProviderRef<bool> ref) =>
      ref.read(storageRepositoryProvider).showMetadata,
);

final AutoDisposeFutureProvider<bool> useCustomTabsProvider =
    FutureProvider.autoDispose<bool>(
  (AutoDisposeFutureProviderRef<bool> ref) =>
      ref.read(storageRepositoryProvider).useCustomTabs,
);

final AutoDisposeFutureProvider<bool> useGesturesProvider =
    FutureProvider.autoDispose<bool>(
  (AutoDisposeFutureProviderRef<bool> ref) =>
      ref.read(storageRepositoryProvider).useGestures,
);

final AutoDisposeFutureProvider<bool> completedWalkthroughProvider =
    FutureProvider.autoDispose<bool>(
  (AutoDisposeFutureProviderRef<bool> ref) =>
      ref.read(storageRepositoryProvider).completedWalkthrough,
);

final AutoDisposeFutureProviderFamily<bool, int> visitedProvider =
    FutureProvider.autoDispose.family(
  (AutoDisposeFutureProviderRef<bool> ref, int id) =>
      ref.read(storageRepositoryProvider).visited(id: id),
);

final FutureProviderFamily<bool, int> collapsedProvider = FutureProvider.family(
  (FutureProviderRef<bool> ref, int id) =>
      ref.read(storageRepositoryProvider).collapsed(id: id),
);

final AutoDisposeFutureProvider<bool> loggedInProvider =
    FutureProvider.autoDispose<bool>(
  (AutoDisposeFutureProviderRef<bool> ref) =>
      ref.read(authRepositoryProvider).loggedIn,
);

final AutoDisposeFutureProvider<String?> usernameProvider =
    FutureProvider.autoDispose<String?>(
  (AutoDisposeFutureProviderRef<String?> ref) =>
      ref.read(authRepositoryProvider).username,
);

final AutoDisposeFutureProviderFamily<bool, int> favoritedProvider =
    FutureProvider.autoDispose.family(
  (AutoDisposeFutureProviderRef<bool> ref, int id) =>
      ref.read(storageRepositoryProvider).favorited(id: id),
);

final AutoDisposeFutureProviderFamily<bool, int> upvotedProvider =
    FutureProvider.autoDispose.family(
  (AutoDisposeFutureProviderRef<bool> ref, int id) =>
      ref.read(storageRepositoryProvider).upvoted(id: id),
);

final AutoDisposeProviderFamily<ImageProvider, String> imageProvider =
    Provider.autoDispose.family<ImageProvider, String>(
  (_, String url) => CachedNetworkImageProvider(url),
);
