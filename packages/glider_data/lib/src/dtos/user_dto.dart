class UserDto {
  const UserDto({
    required this.id,
    required this.created,
    required this.karma,
    this.about,
    this.submitted,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
        id: json['id'] as String,
        created: json['created'] as int,
        karma: json['karma'] as int,
        about: json['about'] as String?,
        submitted: (json['submitted'] as List<dynamic>?)
            ?.map((e) => e as int)
            .toList(growable: false),
      );

  final String id;
  final int created;
  final int karma;
  final String? about;
  final List<int>? submitted;
}
