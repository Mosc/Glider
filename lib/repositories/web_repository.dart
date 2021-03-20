import 'package:dio/dio.dart';
import 'package:glider/utils/html_util.dart';
import 'package:glider/utils/service_exception.dart';

class WebRepository {
  const WebRepository(this._dio);

  final Dio _dio;

  Future<String?> extractTitle({required String url}) async {
    try {
      final Response<List<int>> response = await _dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      return HtmlUtil.getTitle(response.data);
    } on DioError catch (e) {
      throw ServiceException(e.message);
    }
  }
}
