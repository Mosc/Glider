// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'item_tree.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

class _$ItemTreeTearOff {
  const _$ItemTreeTearOff();

// ignore: unused_element
  _ItemTree call({Iterable<Item> items, bool hasMore}) {
    return _ItemTree(
      items: items,
      hasMore: hasMore,
    );
  }
}

// ignore: unused_element
const $ItemTree = _$ItemTreeTearOff();

mixin _$ItemTree {
  Iterable<Item> get items;
  bool get hasMore;

  $ItemTreeCopyWith<ItemTree> get copyWith;
}

abstract class $ItemTreeCopyWith<$Res> {
  factory $ItemTreeCopyWith(ItemTree value, $Res Function(ItemTree) then) =
      _$ItemTreeCopyWithImpl<$Res>;
  $Res call({Iterable<Item> items, bool hasMore});
}

class _$ItemTreeCopyWithImpl<$Res> implements $ItemTreeCopyWith<$Res> {
  _$ItemTreeCopyWithImpl(this._value, this._then);

  final ItemTree _value;
  // ignore: unused_field
  final $Res Function(ItemTree) _then;

  @override
  $Res call({
    Object items = freezed,
    Object hasMore = freezed,
  }) {
    return _then(_value.copyWith(
      items: items == freezed ? _value.items : items as Iterable<Item>,
      hasMore: hasMore == freezed ? _value.hasMore : hasMore as bool,
    ));
  }
}

abstract class _$ItemTreeCopyWith<$Res> implements $ItemTreeCopyWith<$Res> {
  factory _$ItemTreeCopyWith(_ItemTree value, $Res Function(_ItemTree) then) =
      __$ItemTreeCopyWithImpl<$Res>;
  @override
  $Res call({Iterable<Item> items, bool hasMore});
}

class __$ItemTreeCopyWithImpl<$Res> extends _$ItemTreeCopyWithImpl<$Res>
    implements _$ItemTreeCopyWith<$Res> {
  __$ItemTreeCopyWithImpl(_ItemTree _value, $Res Function(_ItemTree) _then)
      : super(_value, (v) => _then(v as _ItemTree));

  @override
  _ItemTree get _value => super._value as _ItemTree;

  @override
  $Res call({
    Object items = freezed,
    Object hasMore = freezed,
  }) {
    return _then(_ItemTree(
      items: items == freezed ? _value.items : items as Iterable<Item>,
      hasMore: hasMore == freezed ? _value.hasMore : hasMore as bool,
    ));
  }
}

class _$_ItemTree with DiagnosticableTreeMixin implements _ItemTree {
  _$_ItemTree({this.items, this.hasMore});

  @override
  final Iterable<Item> items;
  @override
  final bool hasMore;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ItemTree(items: $items, hasMore: $hasMore)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ItemTree'))
      ..add(DiagnosticsProperty('items', items))
      ..add(DiagnosticsProperty('hasMore', hasMore));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ItemTree &&
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
  _$ItemTreeCopyWith<_ItemTree> get copyWith =>
      __$ItemTreeCopyWithImpl<_ItemTree>(this, _$identity);
}

abstract class _ItemTree implements ItemTree {
  factory _ItemTree({Iterable<Item> items, bool hasMore}) = _$_ItemTree;

  @override
  Iterable<Item> get items;
  @override
  bool get hasMore;
  @override
  _$ItemTreeCopyWith<_ItemTree> get copyWith;
}
