import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  const SecureStorageService(this._flutterSecureStorage);

  final FlutterSecureStorage _flutterSecureStorage;

  static const String _userCookieKey = 'userCookie';
  static const String _wallabagAuthKey = 'wallabagAuth';

  Future<String?> getUserCookie() async =>
      _flutterSecureStorage.read(key: _userCookieKey);

  Future<void> setUserCookie(String value) async =>
      _flutterSecureStorage.write(key: _userCookieKey, value: value);

  Future<void> clearUserCookie() async =>
      _flutterSecureStorage.delete(key: _userCookieKey);

  Future<String?> getWallabagAuth() async =>
      _flutterSecureStorage.read(key: _wallabagAuthKey);

  Future<void> setWallabagAuth(String value) async =>
      _flutterSecureStorage.write(key: _wallabagAuthKey, value: value);

  Future<void> clearWallabagAuth() async =>
      _flutterSecureStorage.delete(key: _wallabagAuthKey);
}
