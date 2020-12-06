import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:glider/utils/shared_preferences_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageRepository {
  const StorageRepository(this._secureStorage, this._sharedPreferences);

  static const String _usernameKey = 'username';
  static const String _passwordKey = 'password';
  static const String _favoritedKey = 'favorited';
  static const String _upvotedKey = 'upvoted';
  static const String _visitedKey = 'visited';

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

  Future<Iterable<int>> favorites() async =>
      (await _sharedPreferences).getStringList(_favoritedKey).map(int.parse);

  Future<bool> favorited({@required int id}) async =>
      (await _sharedPreferences).containsElement(_favoritedKey, id.toString());

  Future<void> setFavorited({@required int id, @required bool favorite}) async {
    final SharedPreferences sharedPreferences = await _sharedPreferences;

    if (favorite) {
      await sharedPreferences.addElement(_favoritedKey, id.toString());
    } else {
      await sharedPreferences.removeElement(_favoritedKey, id.toString());
    }
  }

  Future<bool> upvoted({@required int id}) async =>
      (await _sharedPreferences).containsElement(_upvotedKey, id.toString());

  Future<void> setUpvoted({@required int id, @required bool up}) async {
    final SharedPreferences sharedPreferences = await _sharedPreferences;

    if (up) {
      await sharedPreferences.addElement(_upvotedKey, id.toString());
    } else {
      await sharedPreferences.removeElement(_upvotedKey, id.toString());
    }
  }

  Future<bool> visited({@required int id}) async =>
      (await _sharedPreferences).containsElement(_visitedKey, id.toString());

  Future<void> setVisited({@required int id}) async =>
      (await _sharedPreferences).addElement(_visitedKey, id.toString());
}
