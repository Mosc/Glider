import 'package:dio/dio.dart';
import 'package:glider/models/item.dart';
import 'package:glider/models/user.dart';
import 'package:glider/models/navigation_item.dart';
import 'package:glider/utils/service_exception.dart';

class ApiRepository {
  ApiRepository(this._dio);

  static const String baseUrl = 'https://hacker-news.firebaseio.com/v0';

  final Dio _dio;

  Future<Iterable<int>> getStoryIds(NavigationItem navigationItem) async {
    final String url = '$baseUrl/${navigationItem.jsonName}.json';

    try {
      final Response<Iterable<dynamic>> response =
          await _dio.get<Iterable<dynamic>>(url);
      return response.data.map((dynamic id) => id as int);
    } on DioError catch (e) {
      throw ServiceException(e.message);
    }
  }

  Future<Item> getItem(int id) async {
    final String url = '$baseUrl/item/$id.json';

    try {
      final Response<Map<String, Object>> response =
          await _dio.get<Map<String, Object>>(url);

      if (response.data == null) {
        return null;
      }

      return Item.fromJson(response.data);
    } on DioError catch (e) {
      throw ServiceException(e.message);
    }
  }

  Future<User> getUser(String id) async {
    final String url = '$baseUrl/user/$id.json';

    try {
      final Response<Map<String, Object>> response =
          await _dio.get<Map<String, Object>>(url);
      return User.fromJson(response.data);
    } on DioError catch (e) {
      throw ServiceException(e.message);
    }
  }
}
