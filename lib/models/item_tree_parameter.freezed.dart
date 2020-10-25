// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'item_tree_parameter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$ItemTreeParameterTearOff {
  const _$ItemTreeParameterTearOff();

// ignore: unused_element
  _ItemTreeParameter call({int id, Iterable<int> ancestors}) {
    return _ItemTreeParameter(
      id: id,
      ancestors: ancestors,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $ItemTreeParameter = _$ItemTreeParameterTearOff();

/// @nodoc
mixin _$ItemTreeParameter {
  int get id;
  Iterable<int> get ancestors;

  $ItemTreeParameterCopyWith<ItemTreeParameter> get copyWith;
}

/// @nodoc
abstract class $ItemTreeParameterCopyWith<$Res> {
  factory $ItemTreeParameterCopyWith(
          ItemTreeParameter value, $Res Function(ItemTreeParameter) then) =
      _$ItemTreeParameterCopyWithImpl<$Res>;
  $Res call({int id, Iterable<int> ancestors});
}

/// @nodoc
class _$ItemTreeParameterCopyWithImpl<$Res>
    implements $ItemTreeParameterCopyWith<$Res> {
  _$ItemTreeParameterCopyWithImpl(this._value, this._then);

  final ItemTreeParameter _value;
  // ignore: unused_field
  final $Res Function(ItemTreeParameter) _then;

  @override
  $Res call({
    Object id = freezed,
    Object ancestors = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed ? _value.id : id as int,
      ancestors:
          ancestors == freezed ? _value.ancestors : ancestors as Iterable<int>,
    ));
  }
}

/// @nodoc
abstract class _$ItemTreeParameterCopyWith<$Res>
    implements $ItemTreeParameterCopyWith<$Res> {
  factory _$ItemTreeParameterCopyWith(
          _ItemTreeParameter value, $Res Function(_ItemTreeParameter) then) =
      __$ItemTreeParameterCopyWithImpl<$Res>;
  @override
  $Res call({int id, Iterable<int> ancestors});
}

/// @nodoc
class __$ItemTreeParameterCopyWithImpl<$Res>
    extends _$ItemTreeParameterCopyWithImpl<$Res>
    implements _$ItemTreeParameterCopyWith<$Res> {
  __$ItemTreeParameterCopyWithImpl(
      _ItemTreeParameter _value, $Res Function(_ItemTreeParameter) _then)
      : super(_value, (v) => _then(v as _ItemTreeParameter));

  @override
  _ItemTreeParameter get _value => super._value as _ItemTreeParameter;

  @override
  $Res call({
    Object id = freezed,
    Object ancestors = freezed,
  }) {
    return _then(_ItemTreeParameter(
      id: id == freezed ? _value.id : id as int,
      ancestors:
          ancestors == freezed ? _value.ancestors : ancestors as Iterable<int>,
    ));
  }
}

/// @nodoc
class _$_ItemTreeParameter
    with DiagnosticableTreeMixin
    implements _ItemTreeParameter {
  _$_ItemTreeParameter({this.id, this.ancestors});

  @override
  final int id;
  @override
  final Iterable<int> ancestors;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ItemTreeParameter(id: $id, ancestors: $ancestors)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ItemTreeParameter'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('ancestors', ancestors));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ItemTreeParameter &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.ancestors, ancestors) ||
                const DeepCollectionEquality()
                    .equals(other.ancestors, ancestors)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(ancestors);

  @override
  _$ItemTreeParameterCopyWith<_ItemTreeParameter> get copyWith =>
      __$ItemTreeParameterCopyWithImpl<_ItemTreeParameter>(this, _$identity);
}

abstract class _ItemTreeParameter implements ItemTreeParameter {
  factory _ItemTreeParameter({int id, Iterable<int> ancestors}) =
      _$_ItemTreeParameter;

  @override
  int get id;
  @override
  Iterable<int> get ancestors;
  @override
  _$ItemTreeParameterCopyWith<_ItemTreeParameter> get copyWith;
}
