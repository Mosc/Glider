import 'dart:async';

import 'package:compute/compute.dart';
import 'package:glider_data/glider_data.dart';
import 'package:glider_domain/src/entities/item.dart';
import 'package:glider_domain/src/entities/item_descendant.dart';
import 'package:glider_domain/src/extensions/behavior_subject_map_extension.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';

class ItemRepository {
  ItemRepository(
    this._algoliaApiService,
    this._hackerNewsApiService,
  ) : _itemStreamControllers = {};

  final AlgoliaApiService _algoliaApiService;
  final HackerNewsApiService _hackerNewsApiService;

  final Map<int, BehaviorSubject<Item>> _itemStreamControllers;

  Future<List<int>> getTopStoryIds() async =>
      _hackerNewsApiService.getTopStoryIds();

  Future<List<int>> getNewStoryIds() async =>
      _hackerNewsApiService.getNewStoryIds();

  Future<List<int>> getBestStoryIds() async =>
      _hackerNewsApiService.getBestStoryIds();

  Future<List<int>> getAskStoryIds() async =>
      _hackerNewsApiService.getAskStoryIds();

  Future<List<int>> getShowStoryIds() async =>
      _hackerNewsApiService.getShowStoryIds();

  Future<List<int>> getJobStoryIds() async =>
      _hackerNewsApiService.getJobStoryIds();

  Future<List<Item>> searchStories({
    String? text,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final dto = await _algoliaApiService.searchStories(
      query: text,
      startDate: startDate,
      endDate: endDate,
    );
    final items = await compute(
      (hits) => hits.map(Item.fromAlgoliaSearchHitDto).toList(growable: false),
      dto.hits,
    );

    for (final item in items) {
      _itemStreamControllers.getOrAdd(item.id).add(item);
    }

    return items;
  }

  Future<List<Item>> searchStoryItems(int id, {String? text}) async {
    final dto = await _algoliaApiService.searchStoryItems(id, query: text);
    final items = await compute(
      (hits) => hits.map(Item.fromAlgoliaSearchHitDto).toList(growable: false),
      dto.hits,
    );

    for (final item in items) {
      _itemStreamControllers.getOrAdd(item.id).add(item);
    }

    return items;
  }

  Future<List<Item>> getSimilarStories(int id, {required String url}) async {
    final dto = await _algoliaApiService.getSimilarStories(id, url: url);
    final items = await compute(
      (hits) => hits.map(Item.fromAlgoliaSearchHitDto).toList(growable: false),
      dto.hits,
    );

    for (final item in items) {
      _itemStreamControllers.getOrAdd(item.id).add(item);
    }

    return items;
  }

  Future<List<Item>> searchUserItems(String username, {String? text}) async {
    final dto = await _algoliaApiService.searchUserItems(username, query: text);
    final items = await compute(
      (hits) => hits.map(Item.fromAlgoliaSearchHitDto).toList(growable: false),
      dto.hits,
    );

    for (final item in items) {
      _itemStreamControllers.getOrAdd(item.id).add(item);
    }

    return items;
  }

  Future<List<Item>> getUserReplies(String username) async {
    final userDto = await _hackerNewsApiService.getUser(username);

    if (userDto.submitted case final submitted?) {
      // Limit ID count to prevent running into HTTP status 414 URI Too Long or
      // Algolia internal server errors.
      final dto = await _algoliaApiService.getUserReplies(submitted.take(30));
      final items = await compute(
        (hits) =>
            hits.map(Item.fromAlgoliaSearchHitDto).toList(growable: false),
        dto.hits,
      );

      for (final item in items) {
        _itemStreamControllers.getOrAdd(item.id).add(item);
      }

      return items;
    } else {
      return [];
    }
  }

  Stream<Item> getItemStream(int id) =>
      _itemStreamControllers.getOrAdd(id, asyncSeed: () => getItem(id)).stream;

  Future<Item> getItem(int id) async {
    try {
      final dto = await _hackerNewsApiService.getItem(id);
      final item = await compute(Item.fromDto, dto);
      _itemStreamControllers.getOrAdd(id).add(item);
      return item;
    } on Object catch (e, s) {
      _itemStreamControllers.getOrAdd(id).addError(e, s);
      rethrow;
    }
  }

  Stream<List<ItemDescendant>> getFlatItemDescendantsStream(int id) async* {
    var descendants = <ItemDescendant>[];

    try {
      await for (final item in _getItemTreeStream(id)) {
        if (item.partIds != null && item.partIds!.isNotEmpty ||
            item.childIds != null && item.childIds!.isNotEmpty) {
          yield descendants = await compute(
            (descendants) {
              final index = descendants
                  .indexWhere((descendant) => descendant.id == item.id);
              final ancestorIds = [
                if (index == -1)
                  id
                else ...[
                  ...descendants[index].ancestorIds,
                  descendants[index].id,
                ],
              ];
              return [
                ...descendants.take(index + 1),
                if (item.partIds case final partIds?)
                  for (final partId in partIds)
                    ItemDescendant(
                      id: partId,
                      ancestorIds: ancestorIds,
                      isPart: true,
                    ),
                if (item.childIds case final childIds?)
                  for (final childId in childIds)
                    ItemDescendant(
                      id: childId,
                      ancestorIds: ancestorIds,
                    ),
                ...descendants.skip(index + 1),
              ];
            },
            descendants,
          );
        }

        if (item.isDeleted) {
          yield descendants = await compute(
            (descendants) => [
              ...descendants.where((descendant) => descendant.id != item.id),
            ],
            descendants,
          );
        }
      }
    } on Object catch (e, s) {
      yield* Stream.error(e, s);
    }
  }

  Stream<Item> _getItemTreeStream(int id, {int depth = 0}) async* {
    final item = await getItem(id);
    yield item;
    yield* MergeStream(
      [
        for (final childId in [...?item.partIds, ...?item.childIds])
          _getItemTreeStream(childId, depth: depth + 1),
      ],
    );
  }
}
