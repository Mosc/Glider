import 'dart:ui';

import 'package:glider/models/theme_base.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final AutoDisposeFutureProvider<ThemeBase> themeBaseProvider =
    FutureProvider.autoDispose(
  (ProviderReference ref) => ref.read(storageRepositoryProvider).themeBase,
);

final AutoDisposeFutureProvider<Color> themeColorProvider =
    FutureProvider.autoDispose(
  (ProviderReference ref) => ref.read(storageRepositoryProvider).themeColor,
);

final AutoDisposeFutureProvider<bool> loggedInProvider =
    FutureProvider.autoDispose(
  (ProviderReference ref) => ref.read(authRepositoryProvider).loggedIn,
);

final AutoDisposeFutureProvider<String> usernameProvider =
    FutureProvider.autoDispose(
  (ProviderReference ref) => ref.read(authRepositoryProvider).username,
);

final AutoDisposeFutureProviderFamily<bool, int> favoritedProvider =
    FutureProvider.autoDispose.family(
  (ProviderReference ref, int id) =>
      ref.read(storageRepositoryProvider).favorited(id: id),
);

final AutoDisposeFutureProviderFamily<bool, int> upvotedProvider =
    FutureProvider.autoDispose.family(
  (ProviderReference ref, int id) =>
      ref.read(storageRepositoryProvider).upvoted(id: id),
);

final AutoDisposeFutureProviderFamily<bool, int> visitedProvider =
    FutureProvider.autoDispose.family(
  (ProviderReference ref, int id) =>
      ref.read(storageRepositoryProvider).visited(id: id),
);
