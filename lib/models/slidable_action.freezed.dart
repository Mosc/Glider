// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'slidable_action.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$SlidableActionTearOff {
  const _$SlidableActionTearOff();

// ignore: unused_element
  _SlidableAction call(
      {@required Function action,
      @required IconData icon,
      Color color,
      Color iconColor}) {
    return _SlidableAction(
      action: action,
      icon: icon,
      color: color,
      iconColor: iconColor,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $SlidableAction = _$SlidableActionTearOff();

/// @nodoc
mixin _$SlidableAction {
  Function get action;
  IconData get icon;
  Color get color;
  Color get iconColor;

  $SlidableActionCopyWith<SlidableAction> get copyWith;
}

/// @nodoc
abstract class $SlidableActionCopyWith<$Res> {
  factory $SlidableActionCopyWith(
          SlidableAction value, $Res Function(SlidableAction) then) =
      _$SlidableActionCopyWithImpl<$Res>;
  $Res call({Function action, IconData icon, Color color, Color iconColor});
}

/// @nodoc
class _$SlidableActionCopyWithImpl<$Res>
    implements $SlidableActionCopyWith<$Res> {
  _$SlidableActionCopyWithImpl(this._value, this._then);

  final SlidableAction _value;
  // ignore: unused_field
  final $Res Function(SlidableAction) _then;

  @override
  $Res call({
    Object action = freezed,
    Object icon = freezed,
    Object color = freezed,
    Object iconColor = freezed,
  }) {
    return _then(_value.copyWith(
      action: action == freezed ? _value.action : action as Function,
      icon: icon == freezed ? _value.icon : icon as IconData,
      color: color == freezed ? _value.color : color as Color,
      iconColor: iconColor == freezed ? _value.iconColor : iconColor as Color,
    ));
  }
}

/// @nodoc
abstract class _$SlidableActionCopyWith<$Res>
    implements $SlidableActionCopyWith<$Res> {
  factory _$SlidableActionCopyWith(
          _SlidableAction value, $Res Function(_SlidableAction) then) =
      __$SlidableActionCopyWithImpl<$Res>;
  @override
  $Res call({Function action, IconData icon, Color color, Color iconColor});
}

/// @nodoc
class __$SlidableActionCopyWithImpl<$Res>
    extends _$SlidableActionCopyWithImpl<$Res>
    implements _$SlidableActionCopyWith<$Res> {
  __$SlidableActionCopyWithImpl(
      _SlidableAction _value, $Res Function(_SlidableAction) _then)
      : super(_value, (v) => _then(v as _SlidableAction));

  @override
  _SlidableAction get _value => super._value as _SlidableAction;

  @override
  $Res call({
    Object action = freezed,
    Object icon = freezed,
    Object color = freezed,
    Object iconColor = freezed,
  }) {
    return _then(_SlidableAction(
      action: action == freezed ? _value.action : action as Function,
      icon: icon == freezed ? _value.icon : icon as IconData,
      color: color == freezed ? _value.color : color as Color,
      iconColor: iconColor == freezed ? _value.iconColor : iconColor as Color,
    ));
  }
}

/// @nodoc
class _$_SlidableAction
    with DiagnosticableTreeMixin
    implements _SlidableAction {
  _$_SlidableAction(
      {@required this.action, @required this.icon, this.color, this.iconColor})
      : assert(action != null),
        assert(icon != null);

  @override
  final Function action;
  @override
  final IconData icon;
  @override
  final Color color;
  @override
  final Color iconColor;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SlidableAction(action: $action, icon: $icon, color: $color, iconColor: $iconColor)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SlidableAction'))
      ..add(DiagnosticsProperty('action', action))
      ..add(DiagnosticsProperty('icon', icon))
      ..add(DiagnosticsProperty('color', color))
      ..add(DiagnosticsProperty('iconColor', iconColor));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _SlidableAction &&
            (identical(other.action, action) ||
                const DeepCollectionEquality().equals(other.action, action)) &&
            (identical(other.icon, icon) ||
                const DeepCollectionEquality().equals(other.icon, icon)) &&
            (identical(other.color, color) ||
                const DeepCollectionEquality().equals(other.color, color)) &&
            (identical(other.iconColor, iconColor) ||
                const DeepCollectionEquality()
                    .equals(other.iconColor, iconColor)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(action) ^
      const DeepCollectionEquality().hash(icon) ^
      const DeepCollectionEquality().hash(color) ^
      const DeepCollectionEquality().hash(iconColor);

  @override
  _$SlidableActionCopyWith<_SlidableAction> get copyWith =>
      __$SlidableActionCopyWithImpl<_SlidableAction>(this, _$identity);
}

abstract class _SlidableAction implements SlidableAction {
  factory _SlidableAction(
      {@required Function action,
      @required IconData icon,
      Color color,
      Color iconColor}) = _$_SlidableAction;

  @override
  Function get action;
  @override
  IconData get icon;
  @override
  Color get color;
  @override
  Color get iconColor;
  @override
  _$SlidableActionCopyWith<_SlidableAction> get copyWith;
}
