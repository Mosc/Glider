// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
Item _$ItemFromJson(Map<String, dynamic> json) {
  return _Item.fromJson(json);
}

class _$ItemTearOff {
  const _$ItemTearOff();

// ignore: unused_element
  _Item call(
      {int id,
      bool deleted,
      ItemType type,
      String by,
      int time,
      String text,
      bool dead,
      int parent,
      int poll,
      Iterable<int> kids,
      String url,
      int score,
      String title,
      Iterable<int> parts,
      int descendants,
      Iterable<int> ancestors}) {
    return _Item(
      id: id,
      deleted: deleted,
      type: type,
      by: by,
      time: time,
      text: text,
      dead: dead,
      parent: parent,
      poll: poll,
      kids: kids,
      url: url,
      score: score,
      title: title,
      parts: parts,
      descendants: descendants,
      ancestors: ancestors,
    );
  }
}

// ignore: unused_element
const $Item = _$ItemTearOff();

mixin _$Item {
  int get id;
  bool get deleted;
  ItemType get type;
  String get by;
  int get time;
  String get text;
  bool get dead;
  int get parent;
  int get poll;
  Iterable<int> get kids;
  String get url;
  int get score;
  String get title;
  Iterable<int> get parts;
  int get descendants;
  Iterable<int> get ancestors;

  Map<String, dynamic> toJson();
  $ItemCopyWith<Item> get copyWith;
}

abstract class $ItemCopyWith<$Res> {
  factory $ItemCopyWith(Item value, $Res Function(Item) then) =
      _$ItemCopyWithImpl<$Res>;
  $Res call(
      {int id,
      bool deleted,
      ItemType type,
      String by,
      int time,
      String text,
      bool dead,
      int parent,
      int poll,
      Iterable<int> kids,
      String url,
      int score,
      String title,
      Iterable<int> parts,
      int descendants,
      Iterable<int> ancestors});
}

class _$ItemCopyWithImpl<$Res> implements $ItemCopyWith<$Res> {
  _$ItemCopyWithImpl(this._value, this._then);

  final Item _value;
  // ignore: unused_field
  final $Res Function(Item) _then;

  @override
  $Res call({
    Object id = freezed,
    Object deleted = freezed,
    Object type = freezed,
    Object by = freezed,
    Object time = freezed,
    Object text = freezed,
    Object dead = freezed,
    Object parent = freezed,
    Object poll = freezed,
    Object kids = freezed,
    Object url = freezed,
    Object score = freezed,
    Object title = freezed,
    Object parts = freezed,
    Object descendants = freezed,
    Object ancestors = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed ? _value.id : id as int,
      deleted: deleted == freezed ? _value.deleted : deleted as bool,
      type: type == freezed ? _value.type : type as ItemType,
      by: by == freezed ? _value.by : by as String,
      time: time == freezed ? _value.time : time as int,
      text: text == freezed ? _value.text : text as String,
      dead: dead == freezed ? _value.dead : dead as bool,
      parent: parent == freezed ? _value.parent : parent as int,
      poll: poll == freezed ? _value.poll : poll as int,
      kids: kids == freezed ? _value.kids : kids as Iterable<int>,
      url: url == freezed ? _value.url : url as String,
      score: score == freezed ? _value.score : score as int,
      title: title == freezed ? _value.title : title as String,
      parts: parts == freezed ? _value.parts : parts as Iterable<int>,
      descendants:
          descendants == freezed ? _value.descendants : descendants as int,
      ancestors:
          ancestors == freezed ? _value.ancestors : ancestors as Iterable<int>,
    ));
  }
}

abstract class _$ItemCopyWith<$Res> implements $ItemCopyWith<$Res> {
  factory _$ItemCopyWith(_Item value, $Res Function(_Item) then) =
      __$ItemCopyWithImpl<$Res>;
  @override
  $Res call(
      {int id,
      bool deleted,
      ItemType type,
      String by,
      int time,
      String text,
      bool dead,
      int parent,
      int poll,
      Iterable<int> kids,
      String url,
      int score,
      String title,
      Iterable<int> parts,
      int descendants,
      Iterable<int> ancestors});
}

class __$ItemCopyWithImpl<$Res> extends _$ItemCopyWithImpl<$Res>
    implements _$ItemCopyWith<$Res> {
  __$ItemCopyWithImpl(_Item _value, $Res Function(_Item) _then)
      : super(_value, (v) => _then(v as _Item));

  @override
  _Item get _value => super._value as _Item;

  @override
  $Res call({
    Object id = freezed,
    Object deleted = freezed,
    Object type = freezed,
    Object by = freezed,
    Object time = freezed,
    Object text = freezed,
    Object dead = freezed,
    Object parent = freezed,
    Object poll = freezed,
    Object kids = freezed,
    Object url = freezed,
    Object score = freezed,
    Object title = freezed,
    Object parts = freezed,
    Object descendants = freezed,
    Object ancestors = freezed,
  }) {
    return _then(_Item(
      id: id == freezed ? _value.id : id as int,
      deleted: deleted == freezed ? _value.deleted : deleted as bool,
      type: type == freezed ? _value.type : type as ItemType,
      by: by == freezed ? _value.by : by as String,
      time: time == freezed ? _value.time : time as int,
      text: text == freezed ? _value.text : text as String,
      dead: dead == freezed ? _value.dead : dead as bool,
      parent: parent == freezed ? _value.parent : parent as int,
      poll: poll == freezed ? _value.poll : poll as int,
      kids: kids == freezed ? _value.kids : kids as Iterable<int>,
      url: url == freezed ? _value.url : url as String,
      score: score == freezed ? _value.score : score as int,
      title: title == freezed ? _value.title : title as String,
      parts: parts == freezed ? _value.parts : parts as Iterable<int>,
      descendants:
          descendants == freezed ? _value.descendants : descendants as int,
      ancestors:
          ancestors == freezed ? _value.ancestors : ancestors as Iterable<int>,
    ));
  }
}

@JsonSerializable()
class _$_Item with DiagnosticableTreeMixin implements _Item {
  _$_Item(
      {this.id,
      this.deleted,
      this.type,
      this.by,
      this.time,
      this.text,
      this.dead,
      this.parent,
      this.poll,
      this.kids,
      this.url,
      this.score,
      this.title,
      this.parts,
      this.descendants,
      this.ancestors});

  factory _$_Item.fromJson(Map<String, dynamic> json) =>
      _$_$_ItemFromJson(json);

  @override
  final int id;
  @override
  final bool deleted;
  @override
  final ItemType type;
  @override
  final String by;
  @override
  final int time;
  @override
  final String text;
  @override
  final bool dead;
  @override
  final int parent;
  @override
  final int poll;
  @override
  final Iterable<int> kids;
  @override
  final String url;
  @override
  final int score;
  @override
  final String title;
  @override
  final Iterable<int> parts;
  @override
  final int descendants;
  @override
  final Iterable<int> ancestors;

  bool _didurlHost = false;
  String _urlHost;

  @override
  String get urlHost {
    if (_didurlHost == false) {
      _didurlHost = true;
      _urlHost = Uri.parse(url)?.host;
    }
    return _urlHost;
  }

  bool _didtimeAgo = false;
  String _timeAgo;

  @override
  String get timeAgo {
    if (_didtimeAgo == false) {
      _didtimeAgo = true;
      _timeAgo =
          timeago.format(DateTime.fromMillisecondsSinceEpoch(time * 1000));
    }
    return _timeAgo;
  }

  bool _didthumbnailUrl = false;
  String _thumbnailUrl;

  @override
  String get thumbnailUrl {
    if (_didthumbnailUrl == false) {
      _didthumbnailUrl = true;
      _thumbnailUrl = 'https://drcs9k8uelb9s.cloudfront.net/$id.png';
    }
    return _thumbnailUrl;
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Item(id: $id, deleted: $deleted, type: $type, by: $by, time: $time, text: $text, dead: $dead, parent: $parent, poll: $poll, kids: $kids, url: $url, score: $score, title: $title, parts: $parts, descendants: $descendants, ancestors: $ancestors, urlHost: $urlHost, timeAgo: $timeAgo, thumbnailUrl: $thumbnailUrl)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Item'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('deleted', deleted))
      ..add(DiagnosticsProperty('type', type))
      ..add(DiagnosticsProperty('by', by))
      ..add(DiagnosticsProperty('time', time))
      ..add(DiagnosticsProperty('text', text))
      ..add(DiagnosticsProperty('dead', dead))
      ..add(DiagnosticsProperty('parent', parent))
      ..add(DiagnosticsProperty('poll', poll))
      ..add(DiagnosticsProperty('kids', kids))
      ..add(DiagnosticsProperty('url', url))
      ..add(DiagnosticsProperty('score', score))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('parts', parts))
      ..add(DiagnosticsProperty('descendants', descendants))
      ..add(DiagnosticsProperty('ancestors', ancestors))
      ..add(DiagnosticsProperty('urlHost', urlHost))
      ..add(DiagnosticsProperty('timeAgo', timeAgo))
      ..add(DiagnosticsProperty('thumbnailUrl', thumbnailUrl));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Item &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.deleted, deleted) ||
                const DeepCollectionEquality()
                    .equals(other.deleted, deleted)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.by, by) ||
                const DeepCollectionEquality().equals(other.by, by)) &&
            (identical(other.time, time) ||
                const DeepCollectionEquality().equals(other.time, time)) &&
            (identical(other.text, text) ||
                const DeepCollectionEquality().equals(other.text, text)) &&
            (identical(other.dead, dead) ||
                const DeepCollectionEquality().equals(other.dead, dead)) &&
            (identical(other.parent, parent) ||
                const DeepCollectionEquality().equals(other.parent, parent)) &&
            (identical(other.poll, poll) ||
                const DeepCollectionEquality().equals(other.poll, poll)) &&
            (identical(other.kids, kids) ||
                const DeepCollectionEquality().equals(other.kids, kids)) &&
            (identical(other.url, url) ||
                const DeepCollectionEquality().equals(other.url, url)) &&
            (identical(other.score, score) ||
                const DeepCollectionEquality().equals(other.score, score)) &&
            (identical(other.title, title) ||
                const DeepCollectionEquality().equals(other.title, title)) &&
            (identical(other.parts, parts) ||
                const DeepCollectionEquality().equals(other.parts, parts)) &&
            (identical(other.descendants, descendants) ||
                const DeepCollectionEquality()
                    .equals(other.descendants, descendants)) &&
            (identical(other.ancestors, ancestors) ||
                const DeepCollectionEquality()
                    .equals(other.ancestors, ancestors)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(deleted) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(by) ^
      const DeepCollectionEquality().hash(time) ^
      const DeepCollectionEquality().hash(text) ^
      const DeepCollectionEquality().hash(dead) ^
      const DeepCollectionEquality().hash(parent) ^
      const DeepCollectionEquality().hash(poll) ^
      const DeepCollectionEquality().hash(kids) ^
      const DeepCollectionEquality().hash(url) ^
      const DeepCollectionEquality().hash(score) ^
      const DeepCollectionEquality().hash(title) ^
      const DeepCollectionEquality().hash(parts) ^
      const DeepCollectionEquality().hash(descendants) ^
      const DeepCollectionEquality().hash(ancestors);

  @override
  _$ItemCopyWith<_Item> get copyWith =>
      __$ItemCopyWithImpl<_Item>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ItemToJson(this);
  }
}

abstract class _Item implements Item {
  factory _Item(
      {int id,
      bool deleted,
      ItemType type,
      String by,
      int time,
      String text,
      bool dead,
      int parent,
      int poll,
      Iterable<int> kids,
      String url,
      int score,
      String title,
      Iterable<int> parts,
      int descendants,
      Iterable<int> ancestors}) = _$_Item;

  factory _Item.fromJson(Map<String, dynamic> json) = _$_Item.fromJson;

  @override
  int get id;
  @override
  bool get deleted;
  @override
  ItemType get type;
  @override
  String get by;
  @override
  int get time;
  @override
  String get text;
  @override
  bool get dead;
  @override
  int get parent;
  @override
  int get poll;
  @override
  Iterable<int> get kids;
  @override
  String get url;
  @override
  int get score;
  @override
  String get title;
  @override
  Iterable<int> get parts;
  @override
  int get descendants;
  @override
  Iterable<int> get ancestors;
  @override
  _$ItemCopyWith<_Item> get copyWith;
}
