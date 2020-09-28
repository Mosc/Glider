import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:glider/repositories/api_repository.dart';
import 'package:glider/repositories/auth_repository.dart';
import 'package:glider/repositories/website_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod/src/future_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Provider<Dio> _dioProvider = Provider<Dio>((_) => Dio());

final Provider<WebsiteRepository> _websiteRepositoryProvider =
    Provider<WebsiteRepository>(
  (ProviderReference ref) => WebsiteRepository(
    ref.read(_dioProvider),
  ),
);

final AutoDisposeFutureProvider<SharedPreferences> _sharedPreferences =
    FutureProvider.autoDispose<SharedPreferences>(
  (_) => SharedPreferences.getInstance(),
);

final Provider<FlutterSecureStorage> _secureStorageProvider =
    Provider<FlutterSecureStorage>(
  (_) => const FlutterSecureStorage(),
);

final Provider<AuthRepository> authRepositoryProvider =
    Provider<AuthRepository>(
  (ProviderReference ref) => AuthRepository(
    ref.read(_websiteRepositoryProvider),
    ref.read(_secureStorageProvider),
    ref.read(_sharedPreferences.future),
  ),
);

final Provider<ApiRepository> apiRepositoryProvider = Provider<ApiRepository>(
  (ProviderReference ref) => ApiRepository(
    ref.read(_dioProvider),
  ),
);
