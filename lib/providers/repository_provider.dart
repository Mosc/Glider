import 'package:dio/dio.dart';
import 'package:glider/repositories/api_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final Provider<Dio> _dioProvider = Provider<Dio>((_) => Dio());

final Provider<ApiRepository> apiRepositoryProvider = Provider<ApiRepository>(
  (ProviderReference ref) => ApiRepository(ref.read(_dioProvider)),
);
