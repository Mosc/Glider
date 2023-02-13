import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:glider/models/dark_theme.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final FutureProvider<ThemeMode?> themeModeProvider = FutureProvider<ThemeMode?>(
  (FutureProviderRef<ThemeMode?> ref) =>
      ref.read(storageRepositoryProvider).themeMode,
);

final FutureProvider<DarkTheme?> darkThemeProvider = FutureProvider<DarkTheme?>(
  (FutureProviderRef<DarkTheme?> ref) =>
      ref.read(storageRepositoryProvider).darkTheme,
);

final FutureProvider<Color?> themeColorProvider = FutureProvider<Color?>(
  (FutureProviderRef<Color?> ref) =>
      ref.read(storageRepositoryProvider).themeColor,
);

final FutureProvider<bool> showDomainProvider = FutureProvider<bool>(
  (FutureProviderRef<bool> ref) =>
      ref.read(storageRepositoryProvider).showDomain,
);

final FutureProvider<bool> showFaviconProvider = FutureProvider<bool>(
  (FutureProviderRef<bool> ref) =>
      ref.read(storageRepositoryProvider).showFavicon,
);

final FutureProvider<bool> showMetadataProvider = FutureProvider<bool>(
  (FutureProviderRef<bool> ref) =>
      ref.read(storageRepositoryProvider).showMetadata,
);

final FutureProvider<bool> showAvatarProvider = FutureProvider<bool>(
  (FutureProviderRef<bool> ref) =>
      ref.read(storageRepositoryProvider).showAvatar,
);

final FutureProvider<bool> showPositionProvider = FutureProvider<bool>(
  (FutureProviderRef<bool> ref) =>
      ref.read(storageRepositoryProvider).showPosition,
);

final FutureProvider<double?> textScaleFactorProvider = FutureProvider<double?>(
  (FutureProviderRef<double?> ref) =>
      ref.read(storageRepositoryProvider).textScaleFactor,
);

final FutureProvider<bool> useCustomTabsProvider = FutureProvider<bool>(
  (FutureProviderRef<bool> ref) =>
      ref.read(storageRepositoryProvider).useCustomTabs,
);

final FutureProvider<bool> useGesturesProvider = FutureProvider<bool>(
  (FutureProviderRef<bool> ref) =>
      ref.read(storageRepositoryProvider).useGestures,
);

final FutureProvider<bool> useInfiniteScrollProvider = FutureProvider<bool>(
  (FutureProviderRef<bool> ref) =>
      ref.read(storageRepositoryProvider).useInfiniteScroll,
);

final FutureProvider<bool> showJobsProvider = FutureProvider<bool>(
  (FutureProviderRef<bool> ref) => ref.read(storageRepositoryProvider).showJobs,
);

final FutureProvider<bool> completedWalkthroughProvider = FutureProvider<bool>(
  (FutureProviderRef<bool> ref) =>
      ref.read(storageRepositoryProvider).completedWalkthrough,
);

final FutureProviderFamily<bool, int> visitedProvider = FutureProvider.family(
  (FutureProviderRef<bool> ref, int id) =>
      ref.read(storageRepositoryProvider).visited(id: id),
);

final FutureProviderFamily<bool, int> collapsedProvider = FutureProvider.family(
  (FutureProviderRef<bool> ref, int id) =>
      ref.read(storageRepositoryProvider).collapsed(id: id),
);

final FutureProviderFamily<bool, String> blockedProvider =
    FutureProvider.family(
  (FutureProviderRef<bool> ref, String id) =>
      ref.read(storageRepositoryProvider).blocked(id: id),
);

final FutureProvider<bool> loggedInProvider = FutureProvider<bool>(
  (FutureProviderRef<bool> ref) => ref.read(authRepositoryProvider).loggedIn,
);

final FutureProvider<String?> usernameProvider = FutureProvider<String?>(
  (FutureProviderRef<String?> ref) => ref.read(authRepositoryProvider).username,
);

final FutureProviderFamily<bool, int> favoritedProvider = FutureProvider.family(
  (FutureProviderRef<bool> ref, int id) =>
      ref.read(storageRepositoryProvider).favorited(id: id),
);

final FutureProviderFamily<bool, int> upvotedProvider = FutureProvider.family(
  (FutureProviderRef<bool> ref, int id) =>
      ref.read(storageRepositoryProvider).upvoted(id: id),
);

final AutoDisposeProviderFamily<ImageProvider, String> imageProvider =
    Provider.autoDispose.family<ImageProvider, String>(
  (_, String url) => CachedNetworkImageProvider(url),
);
