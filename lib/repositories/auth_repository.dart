import 'package:flutter/foundation.dart';
import 'package:glider/repositories/storage_repository.dart';
import 'package:glider/repositories/website_repository.dart';

class AuthRepository {
  const AuthRepository(this._websiteRepository, this._storageRepository);

  final WebsiteRepository _websiteRepository;
  final StorageRepository _storageRepository;

  Future<bool> get loggedIn async => _storageRepository.loggedIn;

  Future<String> get username async => _storageRepository.username;

  Future<String> get password async => _storageRepository.password;

  Future<bool> register(
      {@required String username, @required String password}) async {
    final bool success = await _websiteRepository.register(
      username: username,
      password: password,
    );

    if (success) {
      await _storageRepository.setAuth(username: username, password: password);
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
      await _storageRepository.setAuth(username: username, password: password);
    }

    return success;
  }

  Future<void> logout() async => _storageRepository.removeAuth();

  Future<bool> vote({@required int id, @required bool up}) async {
    if (await _storageRepository.loggedIn) {
      final bool success = await _websiteRepository.vote(
        username: await _storageRepository.username,
        password: await _storageRepository.password,
        id: id,
        up: up,
      );

      if (success) {
        await _storageRepository.setUpvoted(id: id, up: up);
      }

      return success;
    }

    return false;
  }

  Future<bool> reply({@required int parentId, @required String text}) async {
    if (await _storageRepository.loggedIn) {
      return _websiteRepository.comment(
        username: await _storageRepository.username,
        password: await _storageRepository.password,
        parentId: parentId,
        text: text,
      );
    }

    return false;
  }
}
