import 'package:shared_preferences/shared_preferences.dart';

extension SharedPreferencesExtension on SharedPreferences {
  bool containsElement(String key, String element) =>
      getStringList(key)?.contains(element) ?? false;

  Future<bool> addElement(String key, String element) =>
      setStringList(key, _getDistinctElements(key)..add(element));

  Future<bool> addElements(String key, Iterable<String> elements) =>
      setStringList(key, _getDistinctElements(key)..addAll(elements));

  Future<bool> removeElement(String key, String element) =>
      setStringList(key, _getDistinctElements(key)..remove(element));

  Future<bool> removeElements(String key, Iterable<String> elements) =>
      setStringList(
        key,
        _getDistinctElements(key)
          ..removeWhere((String element) => elements.contains(element)),
      );

  List<String> _getDistinctElements(String key) =>
      getStringList(key)?.toSet().toList() ?? <String>[];
}
