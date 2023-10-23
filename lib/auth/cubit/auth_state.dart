part of 'auth_cubit.dart';

class AuthState with EquatableMixin {
  const AuthState({
    this.isLoggedIn = false,
    this.username,
  });

  final bool isLoggedIn;
  final String? username;

  AuthState copyWith({
    bool Function()? isLoggedIn,
    String? Function()? username,
  }) =>
      AuthState(
        isLoggedIn: isLoggedIn != null ? isLoggedIn() : this.isLoggedIn,
        username: username != null ? username() : this.username,
      );

  @override
  List<Object?> get props => [
        isLoggedIn,
        username,
      ];
}
