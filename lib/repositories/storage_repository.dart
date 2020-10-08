import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageRepository {
  const StorageRepository(this._secureStorage, this._sharedPreferences);

  static const String _usernameKey = 'username';
  static const String _passwordKey = 'password';
  static const String _upvotedKey = 'upvoted';

  final FlutterSecureStorage _secureStorage;
  final Future<SharedPreferences> _sharedPreferences;

  Future<bool> get loggedIn async => await username != null;

  Future<String> get username async => _secureStorage.read(key: _usernameKey);

  Future<String> get password async => _secureStorage.read(key: _passwordKey);

  Future<void> setAuth(
      {@required String username, @required String password}) async {
    await _secureStorage.write(key: _usernameKey, value: username);
    await _secureStorage.write(key: _passwordKey, value: password);
  }

  Future<void> removeAuth() async {
    await _secureStorage.delete(key: _usernameKey);
    await _secureStorage.delete(key: _passwordKey);
  }

  Future<bool> upvoted({@required int id}) async =>
      (await _sharedPreferences)
          .getStringList(_upvotedKey)
          ?.contains(id.toString()) ??
      false;

  Future<void> setUpvoted({@required int id, @required bool up}) async {
    final SharedPreferences sharedPreferences = await _sharedPreferences;
    final List<String> upvoted =
        sharedPreferences.getStringList(_upvotedKey) ?? <String>[];

    if (up) {
      upvoted.add(id.toString());
    } else {
      upvoted.remove(id.toString());
    }

    await sharedPreferences.setStringList(_upvotedKey, upvoted);
  }
}
