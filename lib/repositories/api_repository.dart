import 'package:dio/dio.dart';
import 'package:glider/models/item.dart';
import 'package:glider/models/story_type.dart';
import 'package:glider/models/user.dart';
import 'package:glider/utils/service_exception.dart';

class ApiRepository {
  const ApiRepository(this._dio);

  static const String baseUrl = 'https://hacker-news.firebaseio.com/v0';

  final Dio _dio;

  Future<Iterable<int>> getStoryIds(StoryType storyType) async {
    final String url = '$baseUrl/${storyType.apiPath}.json';

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
        throw ServiceException();
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

      if (response.data == null) {
        throw ServiceException();
      }

      return User.fromJson(response.data);
    } on DioError catch (e) {
      throw ServiceException(e.message);
    }
  }
}
