import 'dart:async';

import 'package:glider_data/glider_data.dart';
import 'package:rxdart/rxdart.dart';

class ItemInteractionRepository {
  ItemInteractionRepository(
    this._hackerNewsWebsiteService,
    this._secureStorageService,
    this._sharedPreferencesService,
  ) {
    unawaited(getVisitedIds());
    unawaited(getUpvotedIds());
    unawaited(getFavoritedIds());
    unawaited(getFlaggedIds());
  }

  final HackerNewsWebsiteService _hackerNewsWebsiteService;
  final SecureStorageService _secureStorageService;
  final SharedPreferencesService _sharedPreferencesService;

  final BehaviorSubject<List<int>> _visitedStreamController = BehaviorSubject();
  final BehaviorSubject<List<int>> _upvotedStreamController = BehaviorSubject();
  final BehaviorSubject<List<int>> _favoritedStreamController =
      BehaviorSubject();
  final BehaviorSubject<List<int>> _flaggedStreamController = BehaviorSubject();

  ValueStream<List<int>> get visitedStream => _visitedStreamController.stream;

  ValueStream<List<int>> get upvotedStream => _upvotedStreamController.stream;

  ValueStream<List<int>> get favoritedStream =>
      _favoritedStreamController.stream;

  ValueStream<List<int>> get flaggedStream => _flaggedStreamController.stream;

  Future<List<int>> getVisitedIds() async {
    try {
      final ids = await _sharedPreferencesService.getVisitedIds();
      _visitedStreamController.add(ids);
      return ids;
    } on Object catch (e) {
      _visitedStreamController.addError(e);
      rethrow;
    }
  }

  Future<List<int>> getUpvotedIds() async {
    try {
      final ids = await _sharedPreferencesService.getUpvotedIds();
      _upvotedStreamController.add(ids);
      return ids;
    } on Object catch (e) {
      _upvotedStreamController.addError(e);
      rethrow;
    }
  }

  Future<List<int>> getFavoritedIds() async {
    try {
      final ids = await _sharedPreferencesService.getFavoritedIds();
      _favoritedStreamController.add(ids);
      return ids;
    } on Object catch (e) {
      _favoritedStreamController.addError(e);
      rethrow;
    }
  }

  Future<List<int>> getFlaggedIds() async {
    try {
      final ids = await _sharedPreferencesService.getFlaggedIds();
      _flaggedStreamController.add(ids);
      return ids;
    } on Object catch (e) {
      _flaggedStreamController.addError(e);
      rethrow;
    }
  }

  Future<bool> visit(int id, {required bool visit}) async {
    try {
      await _sharedPreferencesService.setVisited(id: id, visit: visit);
      await getVisitedIds();
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
