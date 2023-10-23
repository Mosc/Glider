import 'package:glider_data/glider_data.dart';

class AuthRepository {
  const AuthRepository(
    this._secureStorageService,
    this._sharedPreferencesService,
  );

  final SecureStorageService _secureStorageService;
  final SharedPreferencesService _sharedPreferencesService;

  Future<(String? username, String? userCookie)> getUserAuth() async {
    final userCookie = await _secureStorageService.getUserCookie();
    final username = userCookie?.split('&').first;
    return (username, userCookie);
  }

  Future<void> login(String value) async =>
      _secureStorageService.setUserCookie(value);

  Future<void> logout() async {
    await _secureStorageService.clearUserCookie();
    await _sharedPreferencesService.setUpvotedIds(ids: []);
    await _sharedPreferencesService.setFavoritedIds(ids: []);
    await _sharedPreferencesService.setFlaggedIds(ids: []);
  }
}
