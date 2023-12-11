import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:glider/common/constants/app_uris.dart';
import 'package:glider/common/extensions/bloc_base_extension.dart';
import 'package:glider_domain/glider_domain.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
    this._authRepository,
    this._itemInteractionRepository,
    this._cookieManager,
  ) : super(const AuthState());

  final AuthRepository _authRepository;
  final ItemInteractionRepository _itemInteractionRepository;
  final CookieManager _cookieManager;

  Future<void> init() async {
    await _updateLoggedIn();
  }

  Future<void> login() async {
    final userCookieUrl = WebUri.uri(AppUris.hackerNewsUri);
    const userCookieName = 'user';
    final userCookie = await _cookieManager.getCookie(
      url: userCookieUrl,
      name: userCookieName,
    );

    if (userCookie case Cookie(:final String value)) {
      await _authRepository.login(value);
      await _cookieManager.deleteAllCookies();
      await _updateLoggedIn();
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    await _itemInteractionRepository.getUpvotedIds();
    await _itemInteractionRepository.getFavoritedIds();
    await _itemInteractionRepository.getFlaggedIds();
    await _updateLoggedIn();
  }

  Future<void> _updateLoggedIn() async {
    final (username, userCookie) = await _authRepository.getUserAuth();
    safeEmit(
      state.copyWith(
        isLoggedIn: () => userCookie != null,
        username: () => username,
      ),
    );
  }
}
