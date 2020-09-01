// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Item _$_$_ItemFromJson(Map<String, dynamic> json) {
  return _$_Item(
    id: json['id'] as int,
    deleted: json['deleted'] as bool,
    type: _$enumDecodeNullable(_$ItemTypeEnumMap, json['type']),
    by: json['by'] as String,
    time: json['time'] as int,
    text: json['text'] as String,
    dead: json['dead'] as bool,
    parent: json['parent'] as int,
    poll: json['poll'] as int,
    kids: (json['kids'] as List)?.map((e) => e as int)?.toList(),
    url: json['url'] as String,
    score: json['score'] as int,
    title: json['title'] as String,
    parts: (json['parts'] as List)?.map((e) => e as int)?.toList(),
    descendants: json['descendants'] as int,
    ancestors: (json['ancestors'] as List)?.map((e) => e as int)?.toList(),
  );
}

Map<String, dynamic> _$_$_ItemToJson(_$_Item instance) => <String, dynamic>{
      'id': instance.id,
      'deleted': instance.deleted,
      'type': _$ItemTypeEnumMap[instance.type],
      'by': instance.by,
      'time': instance.time,
      'text': instance.text,
      'dead': instance.dead,
      'parent': instance.parent,
      'poll': instance.poll,
      'kids': instance.kids,
      'url': instance.url,
      'score': instance.score,
      'title': instance.title,
      'parts': instance.parts,
      'descendants': instance.descendants,
      'ancestors': instance.ancestors,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$ItemTypeEnumMap = {
  ItemType.job: 'job',
  ItemType.story: 'story',
  ItemType.comment: 'comment',
  ItemType.poll: 'poll',
  ItemType.pollopt: 'pollopt',
};
