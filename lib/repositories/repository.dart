import 'package:dio/dio.dart';
import 'package:glider/models/item.dart';
import 'package:glider/models/user.dart';
import 'package:glider/models/navigation_item.dart';
import 'package:glider/utils/service_exception.dart';

class Repository {
  Repository(this.dio);

  static const String baseUrl = 'https://hacker-news.firebaseio.com/v0';

  final Dio dio;
  final Map<int, Item> _itemCache = <int, Item>{};

  void clearItemCache() => _itemCache.clear();

  Future<List<int>> getStoryIds(NavigationItem navigationItem) async {
    final String url = '$baseUrl/${navigationItem.jsonName}.json';

    try {
      final Response<List<dynamic>> response =
          await dio.get<List<dynamic>>(url);
      return response.data.map((dynamic id) => id as int).toList();
    } on DioError catch (e) {
      throw ServiceException(e.message);
    }
  }

  Future<Item> getItem(int id) async {
    if (_itemCache.containsKey(id)) {
      return _itemCache[id];
    }

    final String url = '$baseUrl/item/$id.json';

    try {
      final Response<Map<String, Object>> response =
          await dio.get<Map<String, Object>>(url);

      if (response.data == null) {
        return null;
      }

      return _itemCache[id] = Item.fromJson(response.data);
    } on DioError catch (e) {
      throw ServiceException(e.message);
    }
  }

  Future<List<Item>> getItemFamily(int id,
      {List<int> ancestors = const <int>[]}) async {
    final Item item = await getItem(id);

    if (item == null) {
      return <Item>[];
    }

    final List<Item> result = <Item>[item.copyWith(ancestors: ancestors)];

    if (item.kids != null) {
      final List<List<Item>> family = await Future.wait(
        item.kids.map(
          (int kidId) =>
              getItemFamily(kidId, ancestors: <int>[...ancestors, id]),
        ),
      );
      result.addAll(family.expand((List<Item> kid) => kid));
    }

    return Future<List<Item>>.value(result);
  }

  Stream<Item> getItemFamilyStream(int id,
      {List<int> ancestors = const <int>[]}) async* {
    final Item item = await getItem(id);

    if (item == null) {
      return;
    }

    yield item.copyWith(ancestors: ancestors);

    if (item.kids != null) {
      for (final int kidId in item.kids) {
        final Stream<Item> familyStream =
            getItemFamilyStream(kidId, ancestors: <int>[...ancestors, id]);

        await for (final Item kid in familyStream) {
          yield kid;
        }
      }
    }
  }

  Future<User> getUser(String id) async {
    final String url = '$baseUrl/user/$id.json';

    try {
      final Response<Map<String, Object>> response =
          await dio.get<Map<String, Object>>(url);
      return User.fromJson(response.data);
    } on DioError catch (e) {
      throw ServiceException(e.message);
    }
  }
}
