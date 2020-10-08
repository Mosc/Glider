import 'package:glider/providers/repository_provider.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod/src/framework.dart';

final AutoDisposeFutureProvider<bool> loggedInProvider =
    FutureProvider.autoDispose(
  (AutoDisposeProviderReference ref) =>
      ref.read(authRepositoryProvider).loggedIn,
);

final AutoDisposeFutureProvider<String> usernameProvider =
    FutureProvider.autoDispose(
  (AutoDisposeProviderReference ref) =>
      ref.read(authRepositoryProvider).username,
);

final AutoDisposeFutureProviderFamily<bool, int> upvotedProvider =
    FutureProvider.autoDispose.family(
  (AutoDisposeProviderReference ref, int id) =>
      ref.read(storageRepositoryProvider).upvoted(id: id),
);
