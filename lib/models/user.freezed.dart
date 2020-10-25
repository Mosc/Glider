// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
class _$UserTearOff {
  const _$UserTearOff();

// ignore: unused_element
  _User call(
      {String id,
      int delay,
      int created,
      int karma,
      String about,
      Iterable<int> submitted}) {
    return _User(
      id: id,
      delay: delay,
      created: created,
      karma: karma,
      about: about,
      submitted: submitted,
    );
  }

// ignore: unused_element
  User fromJson(Map<String, Object> json) {
    return User.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $User = _$UserTearOff();

/// @nodoc
mixin _$User {
  String get id;
  int get delay;
  int get created;
  int get karma;
  String get about;
  Iterable<int> get submitted;

  Map<String, dynamic> toJson();
  $UserCopyWith<User> get copyWith;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res>;
  $Res call(
      {String id,
      int delay,
      int created,
      int karma,
      String about,
      Iterable<int> submitted});
}

/// @nodoc
class _$UserCopyWithImpl<$Res> implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  final User _value;
  // ignore: unused_field
  final $Res Function(User) _then;

  @override
  $Res call({
    Object id = freezed,
    Object delay = freezed,
    Object created = freezed,
    Object karma = freezed,
    Object about = freezed,
    Object submitted = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed ? _value.id : id as String,
      delay: delay == freezed ? _value.delay : delay as int,
      created: created == freezed ? _value.created : created as int,
      karma: karma == freezed ? _value.karma : karma as int,
      about: about == freezed ? _value.about : about as String,
      submitted:
          submitted == freezed ? _value.submitted : submitted as Iterable<int>,
    ));
  }
}

/// @nodoc
abstract class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) then) =
      __$UserCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      int delay,
      int created,
      int karma,
      String about,
      Iterable<int> submitted});
}

/// @nodoc
class __$UserCopyWithImpl<$Res> extends _$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(_User _value, $Res Function(_User) _then)
      : super(_value, (v) => _then(v as _User));

  @override
  _User get _value => super._value as _User;

  @override
  $Res call({
    Object id = freezed,
    Object delay = freezed,
    Object created = freezed,
    Object karma = freezed,
    Object about = freezed,
    Object submitted = freezed,
  }) {
    return _then(_User(
      id: id == freezed ? _value.id : id as String,
      delay: delay == freezed ? _value.delay : delay as int,
      created: created == freezed ? _value.created : created as int,
      karma: karma == freezed ? _value.karma : karma as int,
      about: about == freezed ? _value.about : about as String,
      submitted:
          submitted == freezed ? _value.submitted : submitted as Iterable<int>,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_User with DiagnosticableTreeMixin implements _User {
  _$_User(
      {this.id,
      this.delay,
      this.created,
      this.karma,
      this.about,
      this.submitted});

  factory _$_User.fromJson(Map<String, dynamic> json) =>
      _$_$_UserFromJson(json);

  @override
  final String id;
  @override
  final int delay;
  @override
  final int created;
  @override
  final int karma;
  @override
  final String about;
  @override
  final Iterable<int> submitted;

  bool _didcreatedDate = false;
  String _createdDate;

  @override
  String get createdDate {
    if (_didcreatedDate == false) {
      _didcreatedDate = true;
      _createdDate = DateFormat.yMMMMd()
          .format(DateTime.fromMillisecondsSinceEpoch(created * 1000));
    }
    return _createdDate;
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'User(id: $id, delay: $delay, created: $created, karma: $karma, about: $about, submitted: $submitted, createdDate: $createdDate)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'User'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('delay', delay))
      ..add(DiagnosticsProperty('created', created))
      ..add(DiagnosticsProperty('karma', karma))
      ..add(DiagnosticsProperty('about', about))
      ..add(DiagnosticsProperty('submitted', submitted))
      ..add(DiagnosticsProperty('createdDate', createdDate));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _User &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.delay, delay) ||
                const DeepCollectionEquality().equals(other.delay, delay)) &&
            (identical(other.created, created) ||
                const DeepCollectionEquality()
                    .equals(other.created, created)) &&
            (identical(other.karma, karma) ||
                const DeepCollectionEquality().equals(other.karma, karma)) &&
            (identical(other.about, about) ||
                const DeepCollectionEquality().equals(other.about, about)) &&
            (identical(other.submitted, submitted) ||
                const DeepCollectionEquality()
                    .equals(other.submitted, submitted)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(delay) ^
      const DeepCollectionEquality().hash(created) ^
      const DeepCollectionEquality().hash(karma) ^
      const DeepCollectionEquality().hash(about) ^
      const DeepCollectionEquality().hash(submitted);

  @override
  _$UserCopyWith<_User> get copyWith =>
      __$UserCopyWithImpl<_User>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_UserToJson(this);
  }
}

abstract class _User implements User {
  factory _User(
      {String id,
      int delay,
      int created,
      int karma,
      String about,
      Iterable<int> submitted}) = _$_User;

  factory _User.fromJson(Map<String, dynamic> json) = _$_User.fromJson;

  @override
  String get id;
  @override
  int get delay;
  @override
  int get created;
  @override
  int get karma;
  @override
  String get about;
  @override
  Iterable<int> get submitted;
  @override
  _$UserCopyWith<_User> get copyWith;
}
