import 'package:glider/providers/repository_provider.dart';
import 'package:glider/repositories/auth_repository.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod/src/framework.dart';

final AutoDisposeFutureProvider<bool> loggedInProvider =
    FutureProvider.autoDispose((AutoDisposeProviderReference ref) async {
  final AuthRepository repository = ref.read(authRepositoryProvider);
  return repository.loggedIn;
});

final AutoDisposeFutureProvider<String> usernameProvider =
    FutureProvider.autoDispose((AutoDisposeProviderReference ref) async {
  final AuthRepository repository = ref.read(authRepositoryProvider);
  return repository.username;
});
