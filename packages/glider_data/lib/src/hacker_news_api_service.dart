import 'dart:convert';

import 'package:compute/compute.dart';
import 'package:glider_data/src/dtos/item_dto.dart';
import 'package:glider_data/src/dtos/user_dto.dart';
import 'package:http/http.dart' as http;

class HackerNewsApiService {
  const HackerNewsApiService(this._client);

  final http.Client _client;

  static const authority = 'hacker-news.firebaseio.com';

  Future<List<int>> getTopStoryIds() async => _getIds('v0/topstories.json');

  Future<List<int>> getNewStoryIds() async => _getIds('v0/newstories.json');

  Future<List<int>> getBestStoryIds() async => _getIds('v0/beststories.json');

  Future<List<int>> getAskStoryIds() async => _getIds('v0/askstories.json');

  Future<List<int>> getShowStoryIds() async => _getIds('v0/showstories.json');

  Future<List<int>> getJobStoryIds() async => _getIds('v0/jobstories.json');

  Future<List<int>> _getIds(String path) async {
    final response = await _client.get(Uri.https(authority, path));
    return compute(
      (body) {
        final list = jsonDecode(body) as List<dynamic>;
        return list.map((e) => e as int).toList(growable: false);
      },
      response.body,
    );
  }

  Future<ItemDto> getItem(int id) async {
    final path = 'v0/item/$id.json';
    final response = await _client.get(Uri.https(authority, path));
    return compute(
      (body) {
        final map = jsonDecode(body) as Map<String, dynamic>;
        return ItemDto.fromJson(map);
      },
      response.body,
    );
  }

  Future<UserDto> getUser(String id) async {
    final path = 'v0/user/$id.json';
    final response = await _client.get(Uri.https(authority, path));
    return compute(
      (body) {
        final map = jsonDecode(body) as Map<String, dynamic>;
        return UserDto.fromJson(map);
      },
      response.body,
    );
  }
}
