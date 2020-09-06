// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$_$_UserFromJson(Map<String, dynamic> json) {
  return _$_User(
    id: json['id'] as String,
    delay: json['delay'] as int,
    created: json['created'] as int,
    karma: json['karma'] as int,
    about: json['about'] as String,
    submitted: (json['submitted'] as List)?.map((e) => e as int),
  );
}

Map<String, dynamic> _$_$_UserToJson(_$_User instance) => <String, dynamic>{
      'id': instance.id,
      'delay': instance.delay,
      'created': instance.created,
      'karma': instance.karma,
      'about': instance.about,
      'submitted': instance.submitted?.toList(),
    };
