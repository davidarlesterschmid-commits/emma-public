// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_mode.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileMode {

 UserMode get currentMode; bool get isEmployerModeAvailable;
/// Create a copy of ProfileMode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileModeCopyWith<ProfileMode> get copyWith => _$ProfileModeCopyWithImpl<ProfileMode>(this as ProfileMode, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileMode&&(identical(other.currentMode, currentMode) || other.currentMode == currentMode)&&(identical(other.isEmployerModeAvailable, isEmployerModeAvailable) || other.isEmployerModeAvailable == isEmployerModeAvailable));
}


@override
int get hashCode => Object.hash(runtimeType,currentMode,isEmployerModeAvailable);

@override
String toString() {
  return 'ProfileMode(currentMode: $currentMode, isEmployerModeAvailable: $isEmployerModeAvailable)';
}


}

/// @nodoc
abstract mixin class $ProfileModeCopyWith<$Res>  {
  factory $ProfileModeCopyWith(ProfileMode value, $Res Function(ProfileMode) _then) = _$ProfileModeCopyWithImpl;
@useResult
$Res call({
 UserMode currentMode, bool isEmployerModeAvailable
});




}
/// @nodoc
class _$ProfileModeCopyWithImpl<$Res>
    implements $ProfileModeCopyWith<$Res> {
  _$ProfileModeCopyWithImpl(this._self, this._then);

  final ProfileMode _self;
  final $Res Function(ProfileMode) _then;

/// Create a copy of ProfileMode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentMode = null,Object? isEmployerModeAvailable = null,}) {
  return _then(_self.copyWith(
currentMode: null == currentMode ? _self.currentMode : currentMode // ignore: cast_nullable_to_non_nullable
as UserMode,isEmployerModeAvailable: null == isEmployerModeAvailable ? _self.isEmployerModeAvailable : isEmployerModeAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileMode].
extension ProfileModePatterns on ProfileMode {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileMode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileMode() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileMode value)  $default,){
final _that = this;
switch (_that) {
case _ProfileMode():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileMode value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileMode() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UserMode currentMode,  bool isEmployerModeAvailable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileMode() when $default != null:
return $default(_that.currentMode,_that.isEmployerModeAvailable);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UserMode currentMode,  bool isEmployerModeAvailable)  $default,) {final _that = this;
switch (_that) {
case _ProfileMode():
return $default(_that.currentMode,_that.isEmployerModeAvailable);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UserMode currentMode,  bool isEmployerModeAvailable)?  $default,) {final _that = this;
switch (_that) {
case _ProfileMode() when $default != null:
return $default(_that.currentMode,_that.isEmployerModeAvailable);case _:
  return null;

}
}

}

/// @nodoc


class _ProfileMode implements ProfileMode {
  const _ProfileMode({required this.currentMode, required this.isEmployerModeAvailable});
  

@override final  UserMode currentMode;
@override final  bool isEmployerModeAvailable;

/// Create a copy of ProfileMode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileModeCopyWith<_ProfileMode> get copyWith => __$ProfileModeCopyWithImpl<_ProfileMode>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileMode&&(identical(other.currentMode, currentMode) || other.currentMode == currentMode)&&(identical(other.isEmployerModeAvailable, isEmployerModeAvailable) || other.isEmployerModeAvailable == isEmployerModeAvailable));
}


@override
int get hashCode => Object.hash(runtimeType,currentMode,isEmployerModeAvailable);

@override
String toString() {
  return 'ProfileMode(currentMode: $currentMode, isEmployerModeAvailable: $isEmployerModeAvailable)';
}


}

/// @nodoc
abstract mixin class _$ProfileModeCopyWith<$Res> implements $ProfileModeCopyWith<$Res> {
  factory _$ProfileModeCopyWith(_ProfileMode value, $Res Function(_ProfileMode) _then) = __$ProfileModeCopyWithImpl;
@override @useResult
$Res call({
 UserMode currentMode, bool isEmployerModeAvailable
});




}
/// @nodoc
class __$ProfileModeCopyWithImpl<$Res>
    implements _$ProfileModeCopyWith<$Res> {
  __$ProfileModeCopyWithImpl(this._self, this._then);

  final _ProfileMode _self;
  final $Res Function(_ProfileMode) _then;

/// Create a copy of ProfileMode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentMode = null,Object? isEmployerModeAvailable = null,}) {
  return _then(_ProfileMode(
currentMode: null == currentMode ? _self.currentMode : currentMode // ignore: cast_nullable_to_non_nullable
as UserMode,isEmployerModeAvailable: null == isEmployerModeAvailable ? _self.isEmployerModeAvailable : isEmployerModeAvailable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
