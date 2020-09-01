// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'item_family.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

class _$ItemFamilyTearOff {
  const _$ItemFamilyTearOff();

// ignore: unused_element
  _ItemFamily call({List<Item> items, bool hasMore}) {
    return _ItemFamily(
      items: items,
      hasMore: hasMore,
    );
  }
}

// ignore: unused_element
const $ItemFamily = _$ItemFamilyTearOff();

mixin _$ItemFamily {
  List<Item> get items;
  bool get hasMore;

  $ItemFamilyCopyWith<ItemFamily> get copyWith;
}

abstract class $ItemFamilyCopyWith<$Res> {
  factory $ItemFamilyCopyWith(
          ItemFamily value, $Res Function(ItemFamily) then) =
      _$ItemFamilyCopyWithImpl<$Res>;
  $Res call({List<Item> items, bool hasMore});
}

class _$ItemFamilyCopyWithImpl<$Res> implements $ItemFamilyCopyWith<$Res> {
  _$ItemFamilyCopyWithImpl(this._value, this._then);

  final ItemFamily _value;
  // ignore: unused_field
  final $Res Function(ItemFamily) _then;

  @override
  $Res call({
    Object items = freezed,
    Object hasMore = freezed,
  }) {
    return _then(_value.copyWith(
      items: items == freezed ? _value.items : items as List<Item>,
      hasMore: hasMore == freezed ? _value.hasMore : hasMore as bool,
    ));
  }
}

abstract class _$ItemFamilyCopyWith<$Res> implements $ItemFamilyCopyWith<$Res> {
  factory _$ItemFamilyCopyWith(
          _ItemFamily value, $Res Function(_ItemFamily) then) =
      __$ItemFamilyCopyWithImpl<$Res>;
  @override
  $Res call({List<Item> items, bool hasMore});
}

class __$ItemFamilyCopyWithImpl<$Res> extends _$ItemFamilyCopyWithImpl<$Res>
    implements _$ItemFamilyCopyWith<$Res> {
  __$ItemFamilyCopyWithImpl(
      _ItemFamily _value, $Res Function(_ItemFamily) _then)
      : super(_value, (v) => _then(v as _ItemFamily));

  @override
  _ItemFamily get _value => super._value as _ItemFamily;

  @override
  $Res call({
    Object items = freezed,
    Object hasMore = freezed,
  }) {
    return _then(_ItemFamily(
      items: items == freezed ? _value.items : items as List<Item>,
      hasMore: hasMore == freezed ? _value.hasMore : hasMore as bool,
    ));
  }
}

class _$_ItemFamily with DiagnosticableTreeMixin implements _ItemFamily {
  _$_ItemFamily({this.items, this.hasMore});

  @override
  final List<Item> items;
  @override
  final bool hasMore;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ItemFamily(items: $items, hasMore: $hasMore)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ItemFamily'))
      ..add(DiagnosticsProperty('items', items))
      ..add(DiagnosticsProperty('hasMore', hasMore));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ItemFamily &&
            (identical(other.items, items) ||
                const DeepCollectionEquality().equals(other.items, items)) &&
            (identical(other.hasMore, hasMore) ||
                const DeepCollectionEquality().equals(other.hasMore, hasMore)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(items) ^
      const DeepCollectionEquality().hash(hasMore);

  @override
  _$ItemFamilyCopyWith<_ItemFamily> get copyWith =>
      __$ItemFamilyCopyWithImpl<_ItemFamily>(this, _$identity);
}

abstract class _ItemFamily implements ItemFamily {
  factory _ItemFamily({List<Item> items, bool hasMore}) = _$_ItemFamily;

  @override
  List<Item> get items;
  @override
  bool get hasMore;
  @override
  _$ItemFamilyCopyWith<_ItemFamily> get copyWith;
}
