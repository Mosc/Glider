import 'dart:async';

import 'package:glider_data/glider_data.dart';
import 'package:rxdart/subjects.dart';

class ItemInteractionRepository {
  ItemInteractionRepository(
    this._hackerNewsWebsiteService,
    this._secureStorageService,
    this._sharedPreferencesService,
  ) {
    unawaited(getVisitedItems());
    unawaited(getUpvotedIds());
    unawaited(getFavoritedIds());
    unawaited(getFlaggedIds());
  }

  final HackerNewsWebsiteService _hackerNewsWebsiteService;
  final SecureStorageService _secureStorageService;
  final SharedPreferencesService _sharedPreferencesService;

  final BehaviorSubject<Map<int, DateTime?>> _visitedStreamController =
      BehaviorSubject();
  final BehaviorSubject<List<int>> _upvotedStreamController = BehaviorSubject();
  final BehaviorSubject<List<int>> _favoritedStreamController =
      BehaviorSubject();
  final BehaviorSubject<List<int>> _flaggedStreamController = BehaviorSubject();

  Stream<Map<int, DateTime?>> get visitedStream =>
      _visitedStreamController.stream;

  Stream<List<int>> get upvotedStream => _upvotedStreamController.stream;

  Stream<List<int>> get favoritedStream => _favoritedStreamController.stream;

  Stream<List<int>> get flaggedStream => _flaggedStreamController.stream;

  Future<Map<int, DateTime?>> getVisitedItems() async {
    try {
      final ids = await _sharedPreferencesService.getVisitedItems();
      _visitedStreamController.add(ids);
      return ids;
    } on Object catch (e, s) {
      _visitedStreamController.addError(e, s);
      rethrow;
    }
  }

  Future<List<int>> getUpvotedIds() async {
    try {
      final ids = await _sharedPreferencesService.getUpvotedIds();
      _upvotedStreamController.add(ids);
      return ids;
    } on Object catch (e, s) {
      _upvotedStreamController.addError(e, s);
      rethrow;
    }
  }

  Future<List<int>> getFavoritedIds() async {
    try {
      final ids = await _sharedPreferencesService.getFavoritedIds();
      _favoritedStreamController.add(ids);
      return ids;
    } on Object catch (e, s) {
      _favoritedStreamController.addError(e, s);
      rethrow;
    }
  }

  Future<List<int>> getFlaggedIds() async {
    try {
      final ids = await _sharedPreferencesService.getFlaggedIds();
      _flaggedStreamController.add(ids);
      return ids;
    } on Object catch (e, s) {
      _flaggedStreamController.addError(e, s);
      rethrow;
    }
  }

  Future<bool> visit(VisitedDto item, {required bool visit}) async {
    try {
      await _sharedPreferencesService.setVisited(item: item, visit: visit);
      await getVisitedItems();
      return true;
    } on Object {
      return false;
    }
  }

  Future<bool> upvote(int id, {required bool upvote}) async {
    try {
      final userCookie = await _secureStorageService.getUserCookie();
      await _hackerNewsWebsiteService.upvote(
        id: id,
        upvote: upvote,
        userCookie: userCookie!,
      );
      await _sharedPreferencesService.setUpvoted(id: id, upvote: upvote);
      await getUpvotedIds();
      return true;
    } on Object {
      return false;
    }
  }

  Future<bool> favorite(int id, {required bool favorite}) async {
    try {
      final userCookie = await _secureStorageService.getUserCookie();

      if (userCookie != null) {
        await _hackerNewsWebsiteService.favorite(
          id: id,
          favorite: favorite,
          userCookie: userCookie,
        );
      }

      await _sharedPreferencesService.setFavorited(id: id, favorite: favorite);
      await getFavoritedIds();
      return true;
    } on Object {
      return false;
    }
  }

  Future<bool> flag(int id, {required bool flag}) async {
    try {
      final userCookie = await _secureStorageService.getUserCookie();
      await _hackerNewsWebsiteService.flag(
        id: id,
        flag: flag,
        userCookie: userCookie!,
      );
      await getFlaggedIds();
      return true;
    } on Object {
      return false;
    }
  }

  Future<bool> edit(int id, {String? title, String? text}) async {
    try {
      final userCookie = await _secureStorageService.getUserCookie();
      await _hackerNewsWebsiteService.edit(
        id: id,
        title: title,
        text: text,
        userCookie: userCookie!,
      );
      return true;
    } on Object {
      return false;
    }
  }

  Future<bool> delete(int id) async {
    try {
      final userCookie = await _secureStorageService.getUserCookie();
      await _hackerNewsWebsiteService.delete(
        id: id,
        userCookie: userCookie!,
      );
      return true;
    } on Object {
      return false;
    }
  }

  Future<bool> reply(int parentId, {required String text}) async {
    try {
      final userCookie = await _secureStorageService.getUserCookie();
      await _hackerNewsWebsiteService.reply(
        parentId: parentId,
        text: text,
        userCookie: userCookie!,
      );
      return true;
    } on Object {
      return false;
    }
  }

  Future<bool> submit({
    required String title,
    String? url,
    String? text,
  }) async {
    try {
      final userCookie = await _secureStorageService.getUserCookie();
      await _hackerNewsWebsiteService.submit(
        title: title,
        url: url,
        text: text,
        userCookie: userCookie!,
      );
      return true;
    } on Object {
      return false;
    }
  }
}
