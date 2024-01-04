import 'package:equatable/equatable.dart';
import 'package:glider_data/glider_data.dart';
import 'package:glider_domain/src/extensions/string_extension.dart';

class User with EquatableMixin {
  const User({
    required this.username,
    required this.createdDateTime,
    required this.karma,
    this.about,
    this.submittedIds,
  });

  factory User.fromDto(UserDto dto) => User(
        username: dto.id,
        createdDateTime:
            DateTime.fromMillisecondsSinceEpoch(dto.created * 1000),
        karma: dto.karma,
        about: dto.about?.convertHtmlToHackerNews(),
        submittedIds: dto.submitted ?? const [],
      );

  factory User.fromMap(Map<String, dynamic> json) => User(
        username: json['username'] as String,
        createdDateTime:
            DateTime.fromMillisecondsSinceEpoch(json['createdDateTime'] as int),
        karma: json['karma'] as int,
        about: json['about'] as String?,
        submittedIds: (json['submittedIds'] as List<dynamic>?)
            ?.map((e) => e as int)
            .toList(growable: false),
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'username': username,
        'createdDateTime': createdDateTime.millisecondsSinceEpoch,
        'karma': karma,
        'about': about,
        'submittedIds': submittedIds,
      };

  final String username;
  final DateTime createdDateTime;
  final int karma;
  final String? about;
  final List<int>? submittedIds;

  @override
  List<Object?> get props => [
        username,
        createdDateTime,
        karma,
        about,
        submittedIds,
      ];
}
