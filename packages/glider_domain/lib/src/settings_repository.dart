import 'dart:ui';

import 'package:glider_data/glider_data.dart';
import 'package:material_color_utilities/scheme/variant.dart';

class SettingsRepository {
  const SettingsRepository(this._sharedPreferencesService);

  final SharedPreferencesService _sharedPreferencesService;

  Future<bool?> getUseLargeStoryStyle() async =>
      _sharedPreferencesService.getUseLargeStoryStyle();

  Future<bool> setUseLargeStoryStyle({required bool value}) async =>
      _sharedPreferencesService.setUseLargeStoryStyle(value: value);

  Future<bool?> getShowStoryMetadata() async =>
      _sharedPreferencesService.getShowStoryMetadata();

  Future<bool> setShowStoryMetadata({required bool value}) async =>
      _sharedPreferencesService.setShowStoryMetadata(value: value);

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

  Future<bool?> getShowJobs() async => _sharedPreferencesService.getShowJobs();

  Future<bool> setShowJobs({required bool value}) async =>
      _sharedPreferencesService.setShowJobs(value: value);

  Future<bool?> getUseThreadNavigation() async =>
      _sharedPreferencesService.getUseThreadNavigation();

  Future<bool> setUseThreadNavigation({required bool value}) async =>
      _sharedPreferencesService.setUseThreadNavigation(value: value);
}
