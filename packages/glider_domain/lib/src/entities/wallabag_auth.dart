import 'package:equatable/equatable.dart';

class WallabagAuthData with EquatableMixin {
  WallabagAuthData({
    required this.endpoint,
    required this.user,
    required this.password,
    required this.identifier,
    required this.secret,
  });

  factory WallabagAuthData.fromMap(Map<String, dynamic> json) {
    return WallabagAuthData(
      endpoint: Uri.parse(json['endpoint'] as String),
      user: json['user'] as String,
      password: json['password'] as String,
      identifier: json['identifier'] as String,
      secret: json['secret'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'endpoint': endpoint.toString(),
      'user': user,
      'password': password,
      'identifier': identifier,
      'secret': secret,
    };
  }

  final Uri endpoint;

  final String user;
  final String password;

  final String identifier;
  final String secret;

  @override
  List<Object?> get props => [
        endpoint,
        identifier,
        password,
        secret,
        user,
      ];
}
