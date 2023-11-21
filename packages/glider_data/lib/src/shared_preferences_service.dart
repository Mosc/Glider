import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  const SharedPreferencesService(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  static const String _themeModeKey = 'theme_mode';
  static const String _useDynamicThemeKey = 'use_dynamic_theme';
  static const String _themeColorKey = 'theme_color';
  static const String _themeVariantKey = 'theme_variant';
  static const String _usePureBackgroundKey = 'use_pure_background';
  static const String _fontKey = 'font';
  static const String _useLargeStoryStyleKey = 'use_large_story_style';
  static const String _showFaviconsKey = 'show_favicons';
  static const String _showStoryMetadataKey = 'show_story_metadata';
  static const String _showUserAvatars = 'show_user_avatars';
  static const String _useActionButtonsKey = 'use_action_buttons';
  static const String _showJobsKey = 'show_jobs';
  static const String _useThreadNavigationKey = 'use_thread_navigation';
  static const String _enableDownvotingKey = 'enable_downvoting';
  static const String _lastVersionKey = 'last_version';
  static const String _visitedKey = 'visited';
  static const String _upvotedKey = 'upvoted';
  static const String _downvotedKey = 'downvoted';
  static const String _favoritedKey = 'favorited';
  static const String _flaggedKey = 'flagged';
  static const String _blockedKey = 'blocked';

  Future<String?> getThemeMode() async =>
      _sharedPreferences.getString(_themeModeKey);

  Future<bool> setThemeMode({required String value}) async =>
      _sharedPreferences.setString(_themeModeKey, value);

  Future<bool?> getUseDynamicTheme() async =>
      _sharedPreferences.getBool(_useDynamicThemeKey);

  Future<bool> setUseDynamicTheme({required bool value}) async =>
      _sharedPreferences.setBool(_useDynamicThemeKey, value);

  Future<int?> getThemeColor() async =>
      _sharedPreferences.getInt(_themeColorKey);

  Future<bool> setThemeColor({required int value}) async =>
      _sharedPreferences.setInt(_themeColorKey, value);

  Future<String?> getThemeVariant() async =>
      _sharedPreferences.getString(_themeVariantKey);

  Future<bool> setThemeVariant({required String value}) async =>
      _sharedPreferences.setString(_themeVariantKey, value);

  Future<bool?> getUsePureBackground() async =>
      _sharedPreferences.getBool(_usePureBackgroundKey);

  Future<bool> setUsePureBackground({required bool value}) async =>
      _sharedPreferences.setBool(_usePureBackgroundKey, value);

  Future<String?> getFont() async => _sharedPreferences.getString(_fontKey);

  Future<bool> setFont({required String value}) async =>
      _sharedPreferences.setString(_fontKey, value);

  Future<bool?> getUseLargeStoryStyle() async =>
      _sharedPreferences.getBool(_useLargeStoryStyleKey);

  Future<bool> setUseLargeStoryStyle({required bool value}) async =>
      _sharedPreferences.setBool(_useLargeStoryStyleKey, value);

  Future<bool?> getShowFavicons() async =>
      _sharedPreferences.getBool(_showFaviconsKey);

  Future<bool> setShowFavicons({required bool value}) async =>
      _sharedPreferences.setBool(_showFaviconsKey, value);

  Future<bool?> getShowStoryMetadata() async =>
      _sharedPreferences.getBool(_showStoryMetadataKey);

  Future<bool> setShowStoryMetadata({required bool value}) async =>
      _sharedPreferences.setBool(_showStoryMetadataKey, value);

  Future<bool?> getShowUserAvatars() async =>
      _sharedPreferences.getBool(_showUserAvatars);

  Future<bool> setShowUserAvatars({required bool value}) async =>
      _sharedPreferences.setBool(_showUserAvatars, value);

  Future<bool?> getUseActionButtons() async =>
      _sharedPreferences.getBool(_useActionButtonsKey);

  Future<bool> setUseActionButtons({required bool value}) async =>
      _sharedPreferences.setBool(_useActionButtonsKey, value);

  Future<bool?> getShowJobs() async => _sharedPreferences.getBool(_showJobsKey);

  Future<bool> setShowJobs({required bool value}) async =>
      _sharedPreferences.setBool(_showJobsKey, value);

  Future<bool?> getUseThreadNavigation() async =>
      _sharedPreferences.getBool(_useThreadNavigationKey);

  Future<bool> setUseThreadNavigation({required bool value}) async =>
      _sharedPreferences.setBool(_useThreadNavigationKey, value);

  Future<bool?> getEnableDownvoting() async =>
      _sharedPreferences.getBool(_enableDownvotingKey);

  Future<bool> setEnableDownvoting({required bool value}) async =>
      _sharedPreferences.setBool(_enableDownvotingKey, value);

  Future<String?> getLastVersion() async =>
      _sharedPreferences.getString(_lastVersionKey);

  Future<bool> setLastVersion({required String value}) async =>
      _sharedPreferences.setString(_lastVersionKey, value);

  Future<bool> getVisited({required int id}) async =>
      _sharedPreferences.containsElement(_visitedKey, id.toString());

  Future<bool> setVisited({required int id, required bool visit}) async {
    if (visit) {
      return _sharedPreferences.addElement(_visitedKey, id.toString());
    } else {
      return _sharedPreferences.removeElement(_visitedKey, id.toString());
    }
  }

  Future<List<int>> getVisitedIds() async =>
      [...?_sharedPreferences.getStringList(_visitedKey)?.map(int.parse)];

  Future<bool> setVisitedIds({required Iterable<int> ids}) async {
    return _sharedPreferences
        .setStringList(_visitedKey, [...ids.map((id) => id.toString())]);
  }

  Future<bool> getUpvoted({required int id}) async =>
      _sharedPreferences.containsElement(_upvotedKey, id.toString());

  Future<bool> setUpvoted({required int id, required bool upvote}) async {
    if (upvote) {
      return _sharedPreferences.addElement(_upvotedKey, id.toString());
    } else {
      return _sharedPreferences.removeElement(_upvotedKey, id.toString());
    }
  }

  Future<List<int>> getUpvotedIds() async =>
      [...?_sharedPreferences.getStringList(_upvotedKey)?.map(int.parse)];

  Future<bool> setUpvotedIds({required Iterable<int> ids}) async {
    return _sharedPreferences
        .setStringList(_upvotedKey, [...ids.map((id) => id.toString())]);
  }

  Future<bool> getDownvoted({required int id}) async =>
      _sharedPreferences.containsElement(_downvotedKey, id.toString());

  Future<bool> setDownvoted({required int id, required bool downvote}) async {
    if (downvote) {
      return _sharedPreferences.addElement(_downvotedKey, id.toString());
    } else {
      return _sharedPreferences.removeElement(_downvotedKey, id.toString());
    }
  }

  Future<List<int>> getDownvotedIds() async =>
      [...?_sharedPreferences.getStringList(_downvotedKey)?.map(int.parse)];

  Future<bool> setDownvotedIds({required Iterable<int> ids}) async {
    return _sharedPreferences
        .setStringList(_downvotedKey, [...ids.map((id) => id.toString())]);
  }

  Future<bool> getFavorited({required int id}) async =>
      _sharedPreferences.containsElement(_favoritedKey, id.toString());

  Future<bool> setFavorited({required int id, required bool favorite}) async {
    if (favorite) {
      return _sharedPreferences.addElement(_favoritedKey, id.toString());
    } else {
      return _sharedPreferences.removeElement(_favoritedKey, id.toString());
    }
  }

  Future<List<int>> getFavoritedIds() async =>
      [...?_sharedPreferences.getStringList(_favoritedKey)?.map(int.parse)];

  Future<bool> setFavoritedIds({required Iterable<int> ids}) async {
    return _sharedPreferences
        .setStringList(_favoritedKey, [...ids.map((id) => id.toString())]);
  }

  Future<bool> getFlagged({required int id}) async =>
      _sharedPreferences.containsElement(_flaggedKey, id.toString());

  Future<bool> setFlagged({required int id, required bool flagged}) async {
    if (flagged) {
      return _sharedPreferences.addElement(_flaggedKey, id.toString());
    } else {
      return _sharedPreferences.removeElement(_flaggedKey, id.toString());
    }
  }

  Future<List<int>> getFlaggedIds() async =>
      [...?_sharedPreferences.getStringList(_flaggedKey)?.map(int.parse)];

  Future<bool> setFlaggedIds({required Iterable<int> ids}) async {
    return _sharedPreferences
        .setStringList(_flaggedKey, [...ids.map((id) => id.toString())]);
  }

  Future<List<String>> getBlockedUsernames() async =>
      [...?_sharedPreferences.getStringList(_blockedKey)];

  Future<bool> getBlocked({required String username}) async =>
      _sharedPreferences.containsElement(_blockedKey, username);

  Future<bool> setBlocked({
    required String username,
    required bool block,
  }) async {
    if (block) {
      return _sharedPreferences.addElement(_blockedKey, username);
    } else {
      return _sharedPreferences.removeElement(_blockedKey, username);
    }
  }
}

extension on SharedPreferences {
  bool containsElement(String key, String element) =>
      getStringList(key)?.contains(element) ?? false;

  Future<bool> addElement(String key, String element) => setStringList(
        key,
        [element, ..._getDistinctElements(key)],
      );

  Future<bool> removeElement(String key, String element) => setStringList(
        key,
        [..._getDistinctElements(key).where((e) => e != element)],
      );

  Set<String> _getDistinctElements(String key) => {...?getStringList(key)};
}
