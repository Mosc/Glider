import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:glider/repositories/website_repository.dart';

class AuthRepository {
  const AuthRepository(this._secureStorage, this._websiteRepository);

  final FlutterSecureStorage _secureStorage;
  final WebsiteRepository _websiteRepository;

  static const String _usernameKey = 'username';
  static const String _passwordKey = 'password';

  Future<bool> get loggedIn async => await username != null;

  Future<String> get username async => _secureStorage.read(key: _usernameKey);

  Future<String> get password async => _secureStorage.read(key: _passwordKey);

  Future<bool> register(
      {@required String username, @required String password}) async {
    final bool success = await _websiteRepository.register(
      username: username,
      password: password,
    );

    if (success) {
      await _saveAuth(username: username, password: password);
    }

    return success;
  }

  Future<bool> login(
      {@required String username, @required String password}) async {
    final bool success = await _websiteRepository.login(
      username: username,
      password: password,
    );

    if (success) {
      await _saveAuth(username: username, password: password);
    }

    return success;
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: _usernameKey);
    await _secureStorage.delete(key: _passwordKey);
  }

  Future<bool> vote({@required int id, @required bool up}) async {
    if (await loggedIn) {
      return _websiteRepository.vote(
        username: await username,
        password: await password,
        id: id,
        up: up,
      );
    }

    return false;
  }

  Future<bool> reply({@required int parentId, @required String text}) async {
    if (await loggedIn) {
      return _websiteRepository.comment(
        username: await username,
        password: await password,
        parentId: parentId,
        text: text,
      );
    }

    return false;
  }

  Future<void> _saveAuth(
      {@required String username, @required String password}) async {
    await _secureStorage.write(key: _usernameKey, value: username);
    await _secureStorage.write(key: _passwordKey, value: password);
  }
}
