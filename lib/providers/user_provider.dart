import 'package:glider/models/user.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final StateNotifierProviderFamily<UserNotifier, AsyncValue<User>, String>
    userNotifierProvider = StateNotifierProvider.family(
  (StateNotifierProviderRef<UserNotifier, AsyncValue<User>> ref, String id) =>
      UserNotifier(ref.read, id: id),
);

class UserNotifier extends StateNotifier<AsyncValue<User>> {
  UserNotifier(this.read, {required this.id})
      : super(const AsyncValue<User>.loading()) {
    load();
  }

  final Reader read;
  final String id;

  void setData(User user) => state = AsyncValue<User>.data(user);

  Future<User> load() async {
    return state.maybeWhen(
      data: (User state) => state,
      orElse: forceLoad,
    );
  }

  Future<User> forceLoad() async {
    final User item = await read(apiRepositoryProvider).getUser(id);
    setData(item);
    return item;
  }
}
