import 'package:dio/dio.dart';
import 'package:glider/repositories/repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final Provider<Dio> _dioProvider = Provider<Dio>((_) => Dio());

final Provider<Repository> repositoryProvider = Provider<Repository>(
  (ProviderReference ref) => Repository(ref.read(_dioProvider)),
);
