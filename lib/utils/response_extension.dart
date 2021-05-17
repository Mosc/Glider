import 'package:dio/dio.dart';

extension ResponseExtension<T> on Response<T> {
  bool get isSuccess =>
      statusCode != null && statusCode! >= 200 && statusCode! < 300;

  bool get isCache => statusCode == null;
}
