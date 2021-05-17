import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:glider/utils/response_extension.dart';
import 'package:pedantic/pedantic.dart';

class CacheInterceptor extends Interceptor {
  final CacheManager _cacheManager = CacheManager(
    Config('libCachedDioData', stalePeriod: const Duration(days: 7)),
  );

  @override
  Future<void> onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) async {
    if (response.isSuccess && response.requestOptions.method == 'GET') {
      final RequestOptions requestOptions = response.requestOptions;
      final Uint8List bytes =
          await _serialize(requestOptions.responseType, response.data);
      unawaited(
        _cacheManager.putFile(
          requestOptions.path,
          bytes,
          fileExtension: describeEnum(requestOptions.responseType),
        ),
      );
    }

    handler.next(response);
  }

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    final RequestOptions requestOptions = err.requestOptions;
    final FileInfo? fileInfo =
        await _cacheManager.getFileFromCache(requestOptions.path);

    if (fileInfo != null) {
      final Uint8List bytes = await fileInfo.file.readAsBytes();
      final dynamic data = _deserialize(requestOptions.responseType, bytes);
      final Response<dynamic> response =
          Response<dynamic>(data: data, requestOptions: requestOptions);
      handler.resolve(response);
    } else {
      handler.next(err);
    }
  }

  Future<Uint8List> _serialize(ResponseType responseType, dynamic data) async {
    final List<int> bytes;

    switch (responseType) {
      case ResponseType.bytes:
        bytes = data as List<int>;
        break;
      case ResponseType.stream:
        final List<List<int>> bytesList =
            await (data as Stream<List<int>>).toList();
        bytes = bytesList.expand((List<int> x) => x).toList(growable: false);
        break;
      case ResponseType.plain:
        bytes = utf8.encode(data.toString());
        break;
      case ResponseType.json:
        bytes = utf8.encode(jsonEncode(data));
        break;
    }

    return Uint8List.fromList(bytes);
  }

  dynamic _deserialize(ResponseType responseType, Uint8List bytes) {
    final dynamic data;

    switch (responseType) {
      case ResponseType.bytes:
        data = bytes;
        break;
      case ResponseType.stream:
        data = Stream<List<int>>.value(bytes);
        break;
      case ResponseType.plain:
        data = utf8.decode(bytes);
        break;
      case ResponseType.json:
        data = jsonDecode(utf8.decode(bytes));
        break;
    }

    return data;
  }
}
