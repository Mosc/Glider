import 'package:shared_preferences/shared_preferences.dart';

extension SharedPreferencesExtension on SharedPreferences {
  bool containsElement(String key, String element) =>
      getStringList(key)?.contains(element) ?? false;

  Future<bool> addElement(String key, String element) =>
      setStringList(key, _getDistinctElements(key)..add(element));

  Future<bool> removeElement(String key, String element) =>
      setStringList(key, _getDistinctElements(key)..remove(element));

  List<String> _getDistinctElements(String key) =>
      getStringList(key)?.toSet()?.toList() ?? <String>[];
}
