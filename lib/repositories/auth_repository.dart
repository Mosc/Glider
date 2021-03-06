import 'package:flutter/foundation.dart';
import 'package:glider/repositories/storage_repository.dart';
import 'package:glider/repositories/website_repository.dart';
import 'package:glider/utils/service_exception.dart';

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

  Future<void> logout() async {
    await _storageRepository.clearUpvoted();
    await _storageRepository.removeAuth();
  }

  Future<bool> fetchFavorited({Function(int) onUpdate}) async {
    if (await _storageRepository.loggedIn) {
      try {
        final List<int> ids = <int>[
          ...await _websiteRepository.getFavorited(
            username: await _storageRepository.username,
          ),
          ...await _websiteRepository.getFavorited(
            username: await _storageRepository.username,
            comments: true,
          ),
        ];
        await _storageRepository.clearFavorited();
        await _storageRepository.setFavoriteds(ids: ids, favorite: true);
        ids.forEach(onUpdate?.call);
        return true;
      } on ServiceException {
        return false;
      }
    }

    return false;
  }

  Future<bool> fetchUpvoted({Function(int) onUpdate}) async {
    if (await _storageRepository.loggedIn) {
      try {
        final List<int> ids = <int>[
          ...await _websiteRepository.getUpvoted(
            username: await _storageRepository.username,
            password: await _storageRepository.password,
          ),
          ...await _websiteRepository.getUpvoted(
            username: await _storageRepository.username,
            password: await _storageRepository.password,
            comments: true,
          ),
        ];
        await _storageRepository.clearUpvoted();
        await _storageRepository.setUpvoteds(ids: ids, up: true);
        ids.forEach(onUpdate?.call);
        return true;
      } on ServiceException {
        return false;
      }
    }

    return false;
  }

  Future<bool> favorite(
      {@required int id, @required bool favorite, Function() onUpdate}) async {
    await _storageRepository.setFavorited(id: id, favorite: favorite);
    onUpdate?.call();

    if (await _storageRepository.loggedIn) {
      return _websiteRepository.favorite(
        username: await _storageRepository.username,
        password: await _storageRepository.password,
        id: id,
        favorite: favorite,
      );
    }

    return false;
  }

  Future<bool> vote(
      {@required int id, @required bool up, Function() onUpdate}) async {
    final bool oldUp = await _storageRepository.upvoted(id: id);
    await _storageRepository.setUpvoted(id: id, up: up);
    onUpdate?.call();

    if (await _storageRepository.loggedIn) {
      final bool success = await _websiteRepository.vote(
        username: await _storageRepository.username,
        password: await _storageRepository.password,
        id: id,
        up: up,
      );

      if (!success) {
        await _storageRepository.setUpvoted(id: id, up: oldUp);
        onUpdate?.call();
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

  Future<bool> submit({@required String title, String url, String text}) async {
    if (await _storageRepository.loggedIn) {
      return _websiteRepository.submit(
        username: await _storageRepository.username,
        password: await _storageRepository.password,
        title: title,
        url: url,
        text: text,
      );
    }

    return false;
  }
}
