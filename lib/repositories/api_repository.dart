import 'package:dio/dio.dart';
import 'package:glider/models/item.dart';
import 'package:glider/models/story_type.dart';
import 'package:glider/models/user.dart';
import 'package:glider/utils/service_exception.dart';

class ApiRepository {
  const ApiRepository(this._dio);

  static const String authority = 'hacker-news.firebaseio.com';
  static const String basePath = 'v0';

  final Dio _dio;

  Future<Iterable<int>> getStoryIds(StoryType storyType) async {
    final Uri uri = Uri.https(authority, '$basePath/${storyType.apiPath}.json');

    try {
      final Response<Iterable<dynamic>> response =
          await _dio.getUri<Iterable<dynamic>>(uri);
      return response.data?.map((dynamic id) => id as int) ?? <int>[];
    } on DioError catch (e) {
      throw ServiceException(e.message);
    }
  }

  Future<Item> getItem(int id) async {
    final Uri uri = Uri.https(authority, '$basePath/item/$id.json');

    try {
      final Response<Map<String, dynamic>> response =
          await _dio.getUri<Map<String, dynamic>>(uri);

      if (response.data == null) {
        throw ServiceException();
      }

      return Item.fromJson(response.data!);
    } on DioError catch (e) {
      throw ServiceException(e.message);
    }
  }

  Future<User> getUser(String id) async {
    final Uri uri = Uri.https(authority, '$basePath/user/$id.json');

    try {
      final Response<Map<String, dynamic>> response =
          await _dio.getUri<Map<String, dynamic>>(uri);

      if (response.data == null) {
        throw ServiceException();
      }

      return User.fromJson(response.data!);
    } on DioError catch (e) {
      throw ServiceException(e.message);
    }
  }
}
