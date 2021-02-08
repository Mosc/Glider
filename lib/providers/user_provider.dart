import 'package:glider/models/user.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final AutoDisposeFutureProviderFamily<User, String> userProvider =
    FutureProvider.autoDispose.family((ProviderReference ref, String id) =>
        ref.read(apiRepositoryProvider).getUser(id));
