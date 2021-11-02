import 'dart:async';

import 'package:glider/repositories/storage_repository.dart';
import 'package:glider/repositories/website_repository.dart';
import 'package:glider/utils/service_exception.dart';

class AuthRepository {
  const AuthRepository(this._websiteRepository, this._storageRepository);

  final WebsiteRepository _websiteRepository;
  final StorageRepository _storageRepository;

  Future<bool> get loggedIn async => _storageRepository.loggedIn;

  Future<String?> get username async => _storageRepository.username;

  Future<String?> get password async => _storageRepository.password;

  Future<bool> register(
      {required String username, required String password}) async {
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
      {required String username, required String password}) async {
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

  Future<bool> fetchFavorited({void Function(int)? onUpdate}) async {
    final String? username = await _storageRepository.username;

    if (username != null) {
      try {
        final Iterable<int> ids = await _websiteRepository.getFavorited(
          username: username,
        );
        await _storageRepository.clearFavorited();
        await _storageRepository.setFavoriteds(ids: ids, favorite: true);

        if (onUpdate != null) {
          ids.forEach(onUpdate.call);
        }

        return true;
      } on ServiceException {
        return false;
      }
    }

    return false;
  }

  Future<bool> fetchUpvoted({void Function(int)? onUpdate}) async {
    final String? username = await _storageRepository.username;
    final String? password = await _storageRepository.password;

    if (username != null && password != null) {
      try {
        final Iterable<int> ids = await _websiteRepository.getUpvoted(
          username: username,
          password: password,
        );
        await _storageRepository.clearUpvoted();
        await _storageRepository.setUpvoteds(ids: ids, upvote: true);

        if (onUpdate != null) {
          ids.forEach(onUpdate.call);
        }

        return true;
      } on ServiceException {
        return false;
      }
    }

    return false;
  }

  Future<bool> favorite({
    required int id,
    required bool favorite,
    void Function()? onUpdate,
  }) async {
    await _storageRepository.setFavorited(id: id, favorite: favorite);
    onUpdate?.call();

    final String? username = await _storageRepository.username;
    final String? password = await _storageRepository.password;

    if (username != null && password != null) {
      return _websiteRepository.favorite(
        username: username,
        password: password,
        id: id,
        favorite: favorite,
      );
    }

    return false;
  }

  Future<bool> vote({
    required int id,
    required bool upvote,
    void Function()? onUpdate,
  }) async {
    final bool oldUpvoted = await _storageRepository.upvoted(id: id);
    await _storageRepository.setUpvoted(id: id, upvote: upvote);
    onUpdate?.call();

    final String? username = await _storageRepository.username;
    final String? password = await _storageRepository.password;

    if (username != null && password != null) {
      final bool success = await _websiteRepository.vote(
        username: username,
        password: password,
        id: id,
        upvote: upvote,
      );

      if (!success) {
        await _storageRepository.setUpvoted(id: id, upvote: oldUpvoted);
        onUpdate?.call();
      }

      return success;
    }

    return false;
  }

  Future<bool> flag({
    required int id,
    required bool flag,
  }) async {
    final String? username = await _storageRepository.username;
    final String? password = await _storageRepository.password;

    if (username != null && password != null) {
      return _websiteRepository.flag(
        username: username,
        password: password,
        id: id,
        flag: flag,
      );
    }

    return false;
  }

  Future<bool> reply({required int parentId, required String text}) async {
    final String? username = await _storageRepository.username;
    final String? password = await _storageRepository.password;

    if (username != null && password != null) {
      return _websiteRepository.comment(
        username: username,
        password: password,
        parentId: parentId,
        text: text,
      );
    }

    return false;
  }

  Future<bool> edit({required int id, String? title, String? text}) async {
    final String? username = await _storageRepository.username;
    final String? password = await _storageRepository.password;

    if (username != null && password != null) {
      return _websiteRepository.edit(
        username: username,
        password: password,
        id: id,
        title: title,
        text: text,
      );
    }

    return false;
  }

  Future<bool> delete({required int id}) async {
    final String? username = await _storageRepository.username;
    final String? password = await _storageRepository.password;

    if (username != null && password != null) {
      return _websiteRepository.delete(
        username: username,
        password: password,
        id: id,
      );
    }

    return false;
  }

  Future<bool> submit(
      {required String title, String? url, String? text}) async {
    final String? username = await _storageRepository.username;
    final String? password = await _storageRepository.password;

    if (username != null && password != null) {
      return _websiteRepository.submit(
        username: username,
        password: password,
        title: title,
        url: url,
        text: text,
      );
    }

    return false;
  }
}
