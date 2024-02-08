import 'dart:convert';

import 'package:glider_data/glider_data.dart';
import 'package:glider_domain/src/entities/wallabag_auth.dart';

class AuthRepository {
  const AuthRepository(
    this._secureStorageService,
    this._sharedPreferencesService,
  );

  final SecureStorageService _secureStorageService;
  final SharedPreferencesService _sharedPreferencesService;

  Future<(String? username, String? userCookie)> getUserAuth() async {
    final userCookie = await _secureStorageService.getUserCookie();
    final username = userCookie?.split('&').first;
    return (username, userCookie);
  }

  Future<WallabagAuthData?> getWallabagAuth() async {
    final authData = await _secureStorageService.getWallabagAuth();
    if (authData != null) {
      return WallabagAuthData.fromMap(
        jsonDecode(authData) as Map<String, dynamic>,
      );
    }

    return null;
  }

  Future<void> setWallabagAuth(WallabagAuthData? auth) => (auth != null)
      ? _secureStorageService.setWallabagAuth(jsonEncode(auth.toJson()))
      : _secureStorageService.clearWallabagAuth();

  Future<void> login(String value) async =>
      _secureStorageService.setUserCookie(value);

  Future<void> logout() async {
    await _secureStorageService.clearUserCookie();
    await _sharedPreferencesService.setUpvotedIds(ids: []);
    await _sharedPreferencesService.setFavoritedIds(ids: []);
    await _sharedPreferencesService.setFlaggedIds(ids: []);
  }
}
