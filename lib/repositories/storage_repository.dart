import 'dart:ui';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:glider/models/theme_base.dart';
import 'package:glider/utils/shared_preferences_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageRepository {
  const StorageRepository(this._secureStorage, this._sharedPreferences);

  static const String _themeBaseKey = 'theme_base';
  static const String _themeColorKey = 'theme_color';
  static const String _usernameKey = 'username';
  static const String _passwordKey = 'password';
  static const String _favoritedKey = 'favorited';
  static const String _upvotedKey = 'upvoted';
  static const String _visitedKey = 'visited';

  final FlutterSecureStorage _secureStorage;
  final Future<SharedPreferences> _sharedPreferences;

  Future<ThemeBase?> get themeBase async {
    final int? themeBaseValue =
        (await _sharedPreferences).getInt(_themeBaseKey);
    return themeBaseValue != null ? ThemeBase.values[themeBaseValue] : null;
  }

  Future<void> setThemeBase(ThemeBase themeBase) async =>
      (await _sharedPreferences).setInt(_themeBaseKey, themeBase.index);

  Future<Color?> get themeColor async {
    final int? colorValue = (await _sharedPreferences).getInt(_themeColorKey);
    return colorValue != null ? Color(colorValue) : null;
  }

  Future<void> setThemeColor(Color color) async =>
      (await _sharedPreferences).setInt(_themeColorKey, color.value);

  Future<bool> get loggedIn async => await username != null;

  Future<String?> get username async => _secureStorage.read(key: _usernameKey);

  Future<String?> get password async => _secureStorage.read(key: _passwordKey);

  Future<void> setAuth(
      {required String username, required String password}) async {
    await _secureStorage.write(key: _usernameKey, value: username);
    await _secureStorage.write(key: _passwordKey, value: password);
  }

  Future<void> removeAuth() async {
    await _secureStorage.delete(key: _usernameKey);
    await _secureStorage.delete(key: _passwordKey);
  }

  Future<Iterable<int>> get favoriteIds async =>
      (await _sharedPreferences).getStringList(_favoritedKey)?.map(int.parse) ??
      <int>[];

  Future<bool> favorited({required int id}) async =>
      (await _sharedPreferences).containsElement(_favoritedKey, id.toString());

  Future<void> setFavorited({required int id, required bool favorite}) async {
    final SharedPreferences sharedPreferences = await _sharedPreferences;

    if (favorite) {
      await sharedPreferences.addElement(_favoritedKey, id.toString());
    } else {
      await sharedPreferences.removeElement(_favoritedKey, id.toString());
    }
  }

  Future<void> setFavoriteds(
      {required Iterable<int> ids, required bool favorite}) async {
    final SharedPreferences sharedPreferences = await _sharedPreferences;

    if (favorite) {
      await sharedPreferences.addElements(
          _favoritedKey, ids.map((int id) => id.toString()));
    } else {
      await sharedPreferences.removeElements(
          _favoritedKey, ids.map((int id) => id.toString()));
    }
  }

  Future<bool> clearFavorited() async =>
      (await _sharedPreferences).remove(_favoritedKey);

  Future<bool> upvoted({required int id}) async =>
      (await _sharedPreferences).containsElement(_upvotedKey, id.toString());

  Future<void> setUpvoted({required int id, required bool up}) async {
    final SharedPreferences sharedPreferences = await _sharedPreferences;

    if (up) {
      await sharedPreferences.addElement(_upvotedKey, id.toString());
    } else {
      await sharedPreferences.removeElement(_upvotedKey, id.toString());
    }
  }

  Future<void> setUpvoteds(
      {required Iterable<int> ids, required bool up}) async {
    final SharedPreferences sharedPreferences = await _sharedPreferences;

    if (up) {
      await sharedPreferences.addElements(
          _upvotedKey, ids.map((int id) => id.toString()));
    } else {
      await sharedPreferences.removeElements(
          _upvotedKey, ids.map((int id) => id.toString()));
    }
  }

  Future<bool> clearUpvoted() async =>
      (await _sharedPreferences).remove(_upvotedKey);

  Future<bool> visited({required int id}) async =>
      (await _sharedPreferences).containsElement(_visitedKey, id.toString());

  Future<void> setVisited({required int id}) async =>
      (await _sharedPreferences).addElement(_visitedKey, id.toString());
}
