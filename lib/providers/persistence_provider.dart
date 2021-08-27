import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/painting.dart';
import 'package:glider/models/theme_base.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final AutoDisposeFutureProvider<ThemeBase?> themeBaseProvider =
    FutureProvider.autoDispose<ThemeBase?>(
  (AutoDisposeFutureProviderRef<ThemeBase?> ref) =>
      ref.read(storageRepositoryProvider).themeBase,
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

final AutoDisposeFutureProvider<bool> showThumbnailProvider =
    FutureProvider.autoDispose<bool>(
  (AutoDisposeFutureProviderRef<bool> ref) =>
      ref.read(storageRepositoryProvider).showThumbnail,
);

final AutoDisposeFutureProvider<bool> showMetadataProvider =
    FutureProvider.autoDispose<bool>(
  (AutoDisposeFutureProviderRef<bool> ref) =>
      ref.read(storageRepositoryProvider).showMetadata,
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
