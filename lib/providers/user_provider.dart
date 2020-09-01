import 'package:glider/models/user.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/repositories/repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final FutureProviderFamily<User, String> userProvider =
    FutureProvider.family((ProviderReference ref, String id) async {
  final Repository repository = ref.read(repositoryProvider);
  return repository.getUser(id);
});
