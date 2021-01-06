import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class HtmlRepository {
  const HtmlRepository(this._dio);

  final Dio _dio;

  Future<String> getTitle({@required String url}) async {
    try {
      final Response<List<int>> response = await _dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      final dom.Document document = parser.parse(response.data);
      return document?.head?.querySelector('title')?.text;
    } on DioError {
      return null;
    }
  }

  Future<Map<String, String>> getFormValues(String path, dynamic data) async {
    try {
      final Response<List<int>> response = await _dio.post<List<int>>(
        path,
        data: data,
        options: Options(
          responseType: ResponseType.bytes,
          validateStatus: (int status) => status == 200,
        ),
      );
      final dom.Document document = parser.parse(response.data);
      final dom.Element form =
          document?.body?.getElementsByTagName('form')?.first;
      final Iterable<dom.Element> hiddenInputs =
          form?.querySelectorAll("input[type='hidden']");
      return <String, String>{
        if (hiddenInputs != null)
          for (dom.Element hiddenInput in hiddenInputs)
            hiddenInput.attributes['name']: hiddenInput.attributes['value']
      };
    } on DioError {
      return null;
    }
  }
}
