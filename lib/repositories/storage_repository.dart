import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:glider/models/dark_theme.dart';
import 'package:glider/utils/shared_preferences_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageRepository {
  const StorageRepository(this._secureStorage, this._sharedPreferences);

  static const String _themeModeKey = 'theme_mode';
  static const String _darkThemeKey = 'dark_theme';
  static const String _themeColorKey = 'theme_color';
  static const String _showUrlKey = 'show_url';
  static const String _showFaviconKey = 'show_favicon';
  static const String _showMetadataKey = 'show_metadata';
  static const String _showAvatarKey = 'show_avatar';
  static const String _textScaleFactorKey = 'text_scale_factor';
  static const String _useCustomTabsKey = 'use_custom_tabs';
  static const String _useGesturesKey = 'use_gestures';
  static const String _useInfiniteScroll = 'use_infinite_scroll';
  static const String _showJobs = 'show_jobs';
  static const String _completedWalkthroughKey = 'completed_walkthrough';
  static const String _usernameKey = 'username';
  static const String _passwordKey = 'password';
  static const String _favoritedKey = 'favorited';
  static const String _upvotedKey = 'upvoted';
  static const String _visitedKey = 'visited';
  static const String _collapsedKey = 'collapsed';
  static const String _blockedKey = 'blocked';

  final FlutterSecureStorage _secureStorage;
  final Future<SharedPreferences> _sharedPreferences;

  Future<ThemeMode?> get themeMode async {
    final int? themeModeValue =
        (await _sharedPreferences).getInt(_themeModeKey);
    return themeModeValue != null ? ThemeMode.values[themeModeValue] : null;
  }

  Future<void> setThemeMode(ThemeMode value) async =>
      (await _sharedPreferences).setInt(_themeModeKey, value.index);

  Future<DarkTheme?> get darkTheme async {
    final int? darkThemeValue =
        (await _sharedPreferences).getInt(_darkThemeKey);
    return darkThemeValue != null ? DarkTheme.values[darkThemeValue] : null;
  }

  Future<void> setDarkTheme(DarkTheme value) async =>
      (await _sharedPreferences).setInt(_darkThemeKey, value.index);

  Future<Color?> get themeColor async {
    final int? colorValue = (await _sharedPreferences).getInt(_themeColorKey);
    return colorValue != null ? Color(colorValue) : null;
  }

  Future<void> setThemeColor(Color value) async =>
      (await _sharedPreferences).setInt(_themeColorKey, value.value);

  Future<bool> get showUrl async =>
      (await _sharedPreferences).getBool(_showUrlKey) ?? true;

  Future<void> setShowUrl({required bool value}) async =>
      (await _sharedPreferences).setBool(_showUrlKey, value);

  Future<bool> get showFavicon async =>
      (await _sharedPreferences).getBool(_showFaviconKey) ?? true;

  Future<void> setShowFavicon({required bool value}) async =>
      (await _sharedPreferences).setBool(_showFaviconKey, value);

  Future<bool> get showMetadata async =>
      (await _sharedPreferences).getBool(_showMetadataKey) ?? true;

  Future<void> setShowMetadata({required bool value}) async =>
      (await _sharedPreferences).setBool(_showMetadataKey, value);

  Future<bool> get showAvatar async =>
      (await _sharedPreferences).getBool(_showAvatarKey) ?? true;

  Future<void> setShowAvatar({required bool value}) async =>
      (await _sharedPreferences).setBool(_showAvatarKey, value);

  Future<double?> get textScaleFactor async =>
      (await _sharedPreferences).getDouble(_textScaleFactorKey);

  Future<void> setTextScaleFactor({required double value}) async =>
      (await _sharedPreferences).setDouble(_textScaleFactorKey, value);

  Future<bool> get useCustomTabs async =>
      (await _sharedPreferences).getBool(_useCustomTabsKey) ?? true;

  Future<void> setUseCustomTabs({required bool value}) async =>
      (await _sharedPreferences).setBool(_useCustomTabsKey, value);

  Future<bool> get useGestures async =>
      (await _sharedPreferences).getBool(_useGesturesKey) ?? true;

  Future<void> setUseGestures({required bool value}) async =>
      (await _sharedPreferences).setBool(_useGesturesKey, value);

  Future<bool> get useInfiniteScroll async =>
      (await _sharedPreferences).getBool(_useInfiniteScroll) ?? true;

  Future<void> setUseInfiniteScroll({required bool value}) async =>
      (await _sharedPreferences).setBool(_useInfiniteScroll, value);

  Future<bool> get showJobs async =>
      (await _sharedPreferences).getBool(_showJobs) ?? true;

  Future<void> setShowJobs({required bool value}) async =>
      (await _sharedPreferences).setBool(_showJobs, value);

  Future<bool> get completedWalkthrough async =>
      (await _sharedPreferences).getBool(_completedWalkthroughKey) ?? false;

  Future<void> setCompletedWalkthrough({required bool value}) async =>
      (await _sharedPreferences).setBool(_completedWalkthroughKey, value);

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

  Future<Iterable<int>> get favoriteIds async => ((await _sharedPreferences)
          .getStringList(_favoritedKey)
          ?.map(int.parse)
          .toList() ??
      <int>[])
    ..sort((int a, int b) => b.compareTo(a));

  Future<bool> favorited({required int id}) async =>
      (await _sharedPreferences).containsElement(_favoritedKey, id.toString());

  Future<void> setFavorited({required int id, required bool value}) async {
    final SharedPreferences sharedPreferences = await _sharedPreferences;

    if (value) {
      await sharedPreferences.addElement(_favoritedKey, id.toString());
    } else {
      await sharedPreferences.removeElement(_favoritedKey, id.toString());
    }
  }

  Future<void> setFavoriteds(
      {required Iterable<int> ids, required bool value}) async {
    final SharedPreferences sharedPreferences = await _sharedPreferences;

    if (value) {
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

  Future<void> setUpvoted({required int id, required bool value}) async {
    final SharedPreferences sharedPreferences = await _sharedPreferences;

    if (value) {
      await sharedPreferences.addElement(_upvotedKey, id.toString());
    } else {
      await sharedPreferences.removeElement(_upvotedKey, id.toString());
    }
  }

  Future<void> setUpvoteds(
      {required Iterable<int> ids, required bool value}) async {
    final SharedPreferences sharedPreferences = await _sharedPreferences;

    if (value) {
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

  Future<void> setVisited({required int id, required bool value}) async {
    final SharedPreferences sharedPreferences = await _sharedPreferences;

    if (value) {
      await sharedPreferences.addElement(_visitedKey, id.toString());
    } else {
      await sharedPreferences.removeElement(_visitedKey, id.toString());
    }
  }

  Future<bool> collapsed({required int id}) async =>
      (await _sharedPreferences).containsElement(_collapsedKey, id.toString());

  Future<void> setCollapsed({required int id, required bool value}) async {
    final SharedPreferences sharedPreferences = await _sharedPreferences;

    if (value) {
      await sharedPreferences.addElement(_collapsedKey, id.toString());
    } else {
      await sharedPreferences.removeElement(_collapsedKey, id.toString());
    }
  }

  Future<bool> blocked({required String id}) async =>
      (await _sharedPreferences).containsElement(_blockedKey, id);

  Future<void> setBlocked({required String id, required bool value}) async {
    final SharedPreferences sharedPreferences = await _sharedPreferences;

    if (value) {
      await sharedPreferences.addElement(_blockedKey, id);
    } else {
      await sharedPreferences.removeElement(_blockedKey, id);
    }
  }
}
