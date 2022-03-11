import 'package:glider/models/user.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/utils/async_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final StateNotifierProviderFamily<AsyncNotifier<User>, AsyncValue<User>, String>
    userNotifierProvider = StateNotifierProvider.family(
  (StateNotifierProviderRef<AsyncNotifier<User>, AsyncValue<User>> ref,
          String id) =>
      AsyncNotifier<User>(
    () => ref.read(apiRepositoryProvider).getUser(id),
  ),
);
