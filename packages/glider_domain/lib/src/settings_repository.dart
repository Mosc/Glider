import 'dart:ui';

import 'package:glider_data/glider_data.dart';
import 'package:glider_domain/src/entities/theme_mode.dart';
import 'package:material_color_utilities/scheme/variant.dart';

class SettingsRepository {
  const SettingsRepository(this._sharedPreferencesService);

  final SharedPreferencesService _sharedPreferencesService;

  Future<ThemeMode?> getThemeMode() async {
    final value = await _sharedPreferencesService.getThemeMode();
    return value != null ? ThemeMode.values.byName(value) : null;
  }

  Future<bool> setThemeMode({required ThemeMode value}) async =>
      _sharedPreferencesService.setThemeMode(value: value.name);

  Future<bool?> getUseDynamicTheme() async =>
      _sharedPreferencesService.getUseDynamicTheme();

  Future<bool> setUseDynamicTheme({required bool value}) async =>
      _sharedPreferencesService.setUseDynamicTheme(value: value);

  Future<Color?> getThemeColor() async {
    final value = await _sharedPreferencesService.getThemeColor();
    return value != null ? Color(value) : null;
  }

  Future<bool> setThemeColor({required Color value}) async =>
      _sharedPreferencesService.setThemeColor(value: value.value);

  Future<Variant?> getThemeVariant() async {
    final value = await _sharedPreferencesService.getThemeVariant();
    return value != null ? Variant.values.byName(value) : null;
  }

  Future<bool> setThemeVariant({required Variant value}) async =>
      _sharedPreferencesService.setThemeVariant(value: value.name);

  Future<bool?> getUsePureBackground() async =>
      _sharedPreferencesService.getUsePureBackground();

  Future<bool> setUsePureBackground({required bool value}) async =>
      _sharedPreferencesService.setUsePureBackground(value: value);

  Future<String?> getFont() async => _sharedPreferencesService.getFont();

  Future<bool> setFont({required String value}) async =>
      _sharedPreferencesService.setFont(value: value);

  Future<int?> getStoryLines() async =>
      _sharedPreferencesService.getStoryLines();

  Future<bool> setStoryLines({required int value}) async =>
      _sharedPreferencesService.setStoryLines(value: value);

  Future<bool?> getUseLargeStoryStyle() async =>
      _sharedPreferencesService.getUseLargeStoryStyle();

  Future<bool> setUseLargeStoryStyle({required bool value}) async =>
      _sharedPreferencesService.setUseLargeStoryStyle(value: value);

  Future<bool?> getShowFavicons() async =>
      _sharedPreferencesService.getShowFavicons();

  Future<bool> setShowFavicons({required bool value}) async =>
      _sharedPreferencesService.setShowFavicons(value: value);

  Future<bool?> getShowStoryMetadata() async =>
      _sharedPreferencesService.getShowStoryMetadata();

  Future<bool> setShowStoryMetadata({required bool value}) async =>
      _sharedPreferencesService.setShowStoryMetadata(value: value);

  Future<bool?> getShowUserAvatars() async =>
      _sharedPreferencesService.getShowUserAvatars();

  Future<bool> setShowUserAvatars({required bool value}) async =>
      _sharedPreferencesService.setShowUserAvatars(value: value);

  Future<bool?> getUseActionButtons() async =>
      _sharedPreferencesService.getUseActionButtons();

  Future<bool> setUseActionButtons({required bool value}) async =>
      _sharedPreferencesService.setUseActionButtons(value: value);

  Future<bool?> getShowJobs() async => _sharedPreferencesService.getShowJobs();

  Future<bool> setShowJobs({required bool value}) async =>
      _sharedPreferencesService.setShowJobs(value: value);

  Future<bool?> getUseThreadNavigation() async =>
      _sharedPreferencesService.getUseThreadNavigation();

  Future<bool> setUseThreadNavigation({required bool value}) async =>
      _sharedPreferencesService.setUseThreadNavigation(value: value);

  Future<bool?> getEnableDownvoting() async =>
      _sharedPreferencesService.getEnableDownvoting();

  Future<bool> setEnableDownvoting({required bool value}) async =>
      _sharedPreferencesService.setEnableDownvoting(value: value);

  Future<bool?> getUseInAppBrowser() async =>
      _sharedPreferencesService.getUseInAppBrowser();

  Future<bool> setUseInAppBrowser({required bool value}) async =>
      _sharedPreferencesService.setUseInAppBrowser(value: value);

  Future<bool?> getUseNavigationDrawer() async =>
      _sharedPreferencesService.getUseNavigationDrawer();

  Future<bool> setUseNavigationDrawer({required bool value}) async =>
      _sharedPreferencesService.setUseNavigationDrawer(value: value);

  Future<Set<String>?> getWordFilters() async =>
      (await _sharedPreferencesService.getWordFilters())?.toSet();

  Future<bool> setWordFilter({
    required String value,
    required bool filter,
  }) async =>
      _sharedPreferencesService.setWordFilter(value: value, filter: filter);

  Future<Set<String>?> getDomainFilters() async =>
      (await _sharedPreferencesService.getDomainFilters())?.toSet();

  Future<bool> setDomainFilter({
    required String value,
    required bool filter,
  }) async =>
      _sharedPreferencesService.setDomainFilter(value: value, filter: filter);
}
