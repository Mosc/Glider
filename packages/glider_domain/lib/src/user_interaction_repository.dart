import 'dart:async';

import 'package:glider_data/glider_data.dart';
import 'package:rxdart/subjects.dart';

class UserInteractionRepository {
  UserInteractionRepository(
    this._hackerNewsWebsiteService,
    this._secureStorageService,
    this._sharedPreferencesService,
  ) {
    unawaited(getBlockedUsernames());
  }

  final HackerNewsWebsiteService _hackerNewsWebsiteService;
  final SecureStorageService _secureStorageService;
  final SharedPreferencesService _sharedPreferencesService;

  final BehaviorSubject<List<String>> _blockedStreamController =
      BehaviorSubject();
  final BehaviorSubject<bool> _synchronizingStreamController =
      BehaviorSubject.seeded(false);

  Stream<List<String>> get blockedStream => _blockedStreamController.stream;

  Stream<bool> get synchronizingStream => _synchronizingStreamController.stream;

  Future<List<String>> getBlockedUsernames() async {
    try {
      final usernames = await _sharedPreferencesService.getBlockedUsernames();
      _blockedStreamController.add(usernames);
      return usernames;
    } on Object catch (e, st) {
      _blockedStreamController.addError(e, st);
      rethrow;
    }
  }

  Future<bool> block(String username, {required bool block}) async {
    try {
      await _sharedPreferencesService.setBlocked(
        username: username,
        block: block,
      );
      await getBlockedUsernames();
      return true;
    } on Object {
      return false;
    }
  }

  Future<bool> synchronize() async {
    try {
      _synchronizingStreamController.add(true);
      final userCookie = await _secureStorageService.getUserCookie();
      final username = userCookie!.split('&').first;
      final upvoted = await _hackerNewsWebsiteService.getUpvoted(
        username: username,
        userCookie: userCookie,
      );
      await _sharedPreferencesService.setUpvotedIds(ids: upvoted);
      final favorited = await _hackerNewsWebsiteService.getFavorited(
        username: username,
      );
      await _sharedPreferencesService.setFavoritedIds(ids: favorited);
      final flagged = await _hackerNewsWebsiteService.getFlagged(
        username: username,
        userCookie: userCookie,
      );
      await _sharedPreferencesService.setFlaggedIds(ids: flagged);
      return true;
    } on Object {
      return false;
    } finally {
      _synchronizingStreamController.add(false);
    }
  }
}
