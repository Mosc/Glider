import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:glider/repositories/api_repository.dart';
import 'package:glider/repositories/auth_repository.dart';
import 'package:glider/repositories/search_api_repository.dart';
import 'package:glider/repositories/storage_repository.dart';
import 'package:glider/repositories/web_repository.dart';
import 'package:glider/repositories/website_repository.dart';
import 'package:glider/utils/cache_interceptor.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Provider<Dio> _dioProvider = Provider<Dio>(
  (_) => Dio()..interceptors.add(CacheInterceptor()),
);

final Provider<WebsiteRepository> _websiteRepositoryProvider =
    Provider<WebsiteRepository>(
  (ProviderRef<WebsiteRepository> ref) => WebsiteRepository(
    ref.read(_dioProvider),
  ),
);

final FutureProvider<SharedPreferences> _sharedPreferences =
    FutureProvider<SharedPreferences>(
  (_) => SharedPreferences.getInstance(),
);

final Provider<FlutterSecureStorage> _secureStorageProvider =
    Provider<FlutterSecureStorage>(
  (_) => const FlutterSecureStorage(),
);

final Provider<StorageRepository> storageRepositoryProvider =
    Provider<StorageRepository>(
  (ProviderRef<StorageRepository> ref) => StorageRepository(
    ref.read(_secureStorageProvider),
    ref.read(_sharedPreferences.future),
  ),
);

final Provider<AuthRepository> authRepositoryProvider =
    Provider<AuthRepository>(
  (ProviderRef<AuthRepository> ref) => AuthRepository(
    ref.read(_websiteRepositoryProvider),
    ref.read(storageRepositoryProvider),
  ),
);

final Provider<ApiRepository> apiRepositoryProvider = Provider<ApiRepository>(
  (ProviderRef<ApiRepository> ref) => ApiRepository(
    ref.read(_dioProvider),
  ),
);

final Provider<SearchApiRepository> searchApiRepositoryProvider =
    Provider<SearchApiRepository>(
  (ProviderRef<SearchApiRepository> ref) => SearchApiRepository(
    ref.read(_dioProvider),
  ),
);

final Provider<WebRepository> webRepositoryProvider = Provider<WebRepository>(
  (ProviderRef<WebRepository> ref) => WebRepository(
    ref.read(_dioProvider),
  ),
);
