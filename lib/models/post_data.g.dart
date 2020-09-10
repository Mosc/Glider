// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PostData _$_$_PostDataFromJson(Map<String, dynamic> json) {
  return _$_PostData(
    acct: json['acct'] as String,
    pw: json['pw'] as String,
    id: json['id'] as int,
    how: json['how'] as String,
    creating: json['creating'] as String,
    goto: json['goto'] as String,
  );
}

Map<String, dynamic> _$_$_PostDataToJson(_$_PostData instance) {
  final val = <String, dynamic>{
    'acct': instance.acct,
    'pw': instance.pw,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('how', instance.how);
  writeNotNull('creating', instance.creating);
  writeNotNull('goto', instance.goto);
  return val;
}
