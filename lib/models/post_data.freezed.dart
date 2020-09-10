// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'post_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
PostData _$PostDataFromJson(Map<String, dynamic> json) {
  return _PostData.fromJson(json);
}

class _$PostDataTearOff {
  const _$PostDataTearOff();

// ignore: unused_element
  _PostData call(
      {@required String acct,
      @required String pw,
      @JsonKey(includeIfNull: false) int id,
      @JsonKey(includeIfNull: false) String how,
      @JsonKey(includeIfNull: false) String creating,
      @JsonKey(includeIfNull: false) String goto}) {
    return _PostData(
      acct: acct,
      pw: pw,
      id: id,
      how: how,
      creating: creating,
      goto: goto,
    );
  }
}

// ignore: unused_element
const $PostData = _$PostDataTearOff();

mixin _$PostData {
  String get acct;
  String get pw;
  @JsonKey(includeIfNull: false)
  int get id;
  @JsonKey(includeIfNull: false)
  String get how;
  @JsonKey(includeIfNull: false)
  String get creating;
  @JsonKey(includeIfNull: false)
  String get goto;

  Map<String, dynamic> toJson();
  $PostDataCopyWith<PostData> get copyWith;
}

abstract class $PostDataCopyWith<$Res> {
  factory $PostDataCopyWith(PostData value, $Res Function(PostData) then) =
      _$PostDataCopyWithImpl<$Res>;
  $Res call(
      {String acct,
      String pw,
      @JsonKey(includeIfNull: false) int id,
      @JsonKey(includeIfNull: false) String how,
      @JsonKey(includeIfNull: false) String creating,
      @JsonKey(includeIfNull: false) String goto});
}

class _$PostDataCopyWithImpl<$Res> implements $PostDataCopyWith<$Res> {
  _$PostDataCopyWithImpl(this._value, this._then);

  final PostData _value;
  // ignore: unused_field
  final $Res Function(PostData) _then;

  @override
  $Res call({
    Object acct = freezed,
    Object pw = freezed,
    Object id = freezed,
    Object how = freezed,
    Object creating = freezed,
    Object goto = freezed,
  }) {
    return _then(_value.copyWith(
      acct: acct == freezed ? _value.acct : acct as String,
      pw: pw == freezed ? _value.pw : pw as String,
      id: id == freezed ? _value.id : id as int,
      how: how == freezed ? _value.how : how as String,
      creating: creating == freezed ? _value.creating : creating as String,
      goto: goto == freezed ? _value.goto : goto as String,
    ));
  }
}

abstract class _$PostDataCopyWith<$Res> implements $PostDataCopyWith<$Res> {
  factory _$PostDataCopyWith(_PostData value, $Res Function(_PostData) then) =
      __$PostDataCopyWithImpl<$Res>;
  @override
  $Res call(
      {String acct,
      String pw,
      @JsonKey(includeIfNull: false) int id,
      @JsonKey(includeIfNull: false) String how,
      @JsonKey(includeIfNull: false) String creating,
      @JsonKey(includeIfNull: false) String goto});
}

class __$PostDataCopyWithImpl<$Res> extends _$PostDataCopyWithImpl<$Res>
    implements _$PostDataCopyWith<$Res> {
  __$PostDataCopyWithImpl(_PostData _value, $Res Function(_PostData) _then)
      : super(_value, (v) => _then(v as _PostData));

  @override
  _PostData get _value => super._value as _PostData;

  @override
  $Res call({
    Object acct = freezed,
    Object pw = freezed,
    Object id = freezed,
    Object how = freezed,
    Object creating = freezed,
    Object goto = freezed,
  }) {
    return _then(_PostData(
      acct: acct == freezed ? _value.acct : acct as String,
      pw: pw == freezed ? _value.pw : pw as String,
      id: id == freezed ? _value.id : id as int,
      how: how == freezed ? _value.how : how as String,
      creating: creating == freezed ? _value.creating : creating as String,
      goto: goto == freezed ? _value.goto : goto as String,
    ));
  }
}

@JsonSerializable()
class _$_PostData with DiagnosticableTreeMixin implements _PostData {
  _$_PostData(
      {@required this.acct,
      @required this.pw,
      @JsonKey(includeIfNull: false) this.id,
      @JsonKey(includeIfNull: false) this.how,
      @JsonKey(includeIfNull: false) this.creating,
      @JsonKey(includeIfNull: false) this.goto})
      : assert(acct != null),
        assert(pw != null);

  factory _$_PostData.fromJson(Map<String, dynamic> json) =>
      _$_$_PostDataFromJson(json);

  @override
  final String acct;
  @override
  final String pw;
  @override
  @JsonKey(includeIfNull: false)
  final int id;
  @override
  @JsonKey(includeIfNull: false)
  final String how;
  @override
  @JsonKey(includeIfNull: false)
  final String creating;
  @override
  @JsonKey(includeIfNull: false)
  final String goto;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PostData(acct: $acct, pw: $pw, id: $id, how: $how, creating: $creating, goto: $goto)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PostData'))
      ..add(DiagnosticsProperty('acct', acct))
      ..add(DiagnosticsProperty('pw', pw))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('how', how))
      ..add(DiagnosticsProperty('creating', creating))
      ..add(DiagnosticsProperty('goto', goto));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _PostData &&
            (identical(other.acct, acct) ||
                const DeepCollectionEquality().equals(other.acct, acct)) &&
            (identical(other.pw, pw) ||
                const DeepCollectionEquality().equals(other.pw, pw)) &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.how, how) ||
                const DeepCollectionEquality().equals(other.how, how)) &&
            (identical(other.creating, creating) ||
                const DeepCollectionEquality()
                    .equals(other.creating, creating)) &&
            (identical(other.goto, goto) ||
                const DeepCollectionEquality().equals(other.goto, goto)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(acct) ^
      const DeepCollectionEquality().hash(pw) ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(how) ^
      const DeepCollectionEquality().hash(creating) ^
      const DeepCollectionEquality().hash(goto);

  @override
  _$PostDataCopyWith<_PostData> get copyWith =>
      __$PostDataCopyWithImpl<_PostData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_PostDataToJson(this);
  }
}

abstract class _PostData implements PostData {
  factory _PostData(
      {@required String acct,
      @required String pw,
      @JsonKey(includeIfNull: false) int id,
      @JsonKey(includeIfNull: false) String how,
      @JsonKey(includeIfNull: false) String creating,
      @JsonKey(includeIfNull: false) String goto}) = _$_PostData;

  factory _PostData.fromJson(Map<String, dynamic> json) = _$_PostData.fromJson;

  @override
  String get acct;
  @override
  String get pw;
  @override
  @JsonKey(includeIfNull: false)
  int get id;
  @override
  @JsonKey(includeIfNull: false)
  String get how;
  @override
  @JsonKey(includeIfNull: false)
  String get creating;
  @override
  @JsonKey(includeIfNull: false)
  String get goto;
  @override
  _$PostDataCopyWith<_PostData> get copyWith;
}
