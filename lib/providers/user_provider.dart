import 'package:glider/models/user.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/utils/async_state_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final StateNotifierProviderFamily<AsyncStateNotifier<User>, AsyncValue<User>,
    String> userNotifierProvider = StateNotifierProvider.family(
  (StateNotifierProviderRef<AsyncStateNotifier<User>, AsyncValue<User>> ref,
          String id) =>
      AsyncStateNotifier<User>(
    () => ref.read(apiRepositoryProvider).getUser(id),
  ),
);
