// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_orchestration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TripOrchestration {

 String get id; String get type;// 'mediated', 'purchased', 'selfProvided'
 List<String> get providers; double get cost;
/// Create a copy of TripOrchestration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TripOrchestrationCopyWith<TripOrchestration> get copyWith => _$TripOrchestrationCopyWithImpl<TripOrchestration>(this as TripOrchestration, _$identity);

  /// Serializes this TripOrchestration to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TripOrchestration&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.providers, providers)&&(identical(other.cost, cost) || other.cost == cost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,const DeepCollectionEquality().hash(providers),cost);

@override
String toString() {
  return 'TripOrchestration(id: $id, type: $type, providers: $providers, cost: $cost)';
}


}

/// @nodoc
abstract mixin class $TripOrchestrationCopyWith<$Res>  {
  factory $TripOrchestrationCopyWith(TripOrchestration value, $Res Function(TripOrchestration) _then) = _$TripOrchestrationCopyWithImpl;
@useResult
$Res call({
 String id, String type, List<String> providers, double cost
});




}
/// @nodoc
class _$TripOrchestrationCopyWithImpl<$Res>
    implements $TripOrchestrationCopyWith<$Res> {
  _$TripOrchestrationCopyWithImpl(this._self, this._then);

  final TripOrchestration _self;
  final $Res Function(TripOrchestration) _then;

/// Create a copy of TripOrchestration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? providers = null,Object? cost = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,providers: null == providers ? _self.providers : providers // ignore: cast_nullable_to_non_nullable
as List<String>,cost: null == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [TripOrchestration].
extension TripOrchestrationPatterns on TripOrchestration {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TripOrchestration value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TripOrchestration() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TripOrchestration value)  $default,){
final _that = this;
switch (_that) {
case _TripOrchestration():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TripOrchestration value)?  $default,){
final _that = this;
switch (_that) {
case _TripOrchestration() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String type,  List<String> providers,  double cost)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TripOrchestration() when $default != null:
return $default(_that.id,_that.type,_that.providers,_that.cost);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String type,  List<String> providers,  double cost)  $default,) {final _that = this;
switch (_that) {
case _TripOrchestration():
return $default(_that.id,_that.type,_that.providers,_that.cost);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String type,  List<String> providers,  double cost)?  $default,) {final _that = this;
switch (_that) {
case _TripOrchestration() when $default != null:
return $default(_that.id,_that.type,_that.providers,_that.cost);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TripOrchestration implements TripOrchestration {
  const _TripOrchestration({required this.id, required this.type, required final  List<String> providers, required this.cost}): _providers = providers;
  factory _TripOrchestration.fromJson(Map<String, dynamic> json) => _$TripOrchestrationFromJson(json);

@override final  String id;
@override final  String type;
// 'mediated', 'purchased', 'selfProvided'
 final  List<String> _providers;
// 'mediated', 'purchased', 'selfProvided'
@override List<String> get providers {
  if (_providers is EqualUnmodifiableListView) return _providers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_providers);
}

@override final  double cost;

/// Create a copy of TripOrchestration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TripOrchestrationCopyWith<_TripOrchestration> get copyWith => __$TripOrchestrationCopyWithImpl<_TripOrchestration>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TripOrchestrationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TripOrchestration&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._providers, _providers)&&(identical(other.cost, cost) || other.cost == cost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,const DeepCollectionEquality().hash(_providers),cost);

@override
String toString() {
  return 'TripOrchestration(id: $id, type: $type, providers: $providers, cost: $cost)';
}


}

/// @nodoc
abstract mixin class _$TripOrchestrationCopyWith<$Res> implements $TripOrchestrationCopyWith<$Res> {
  factory _$TripOrchestrationCopyWith(_TripOrchestration value, $Res Function(_TripOrchestration) _then) = __$TripOrchestrationCopyWithImpl;
@override @useResult
$Res call({
 String id, String type, List<String> providers, double cost
});




}
/// @nodoc
class __$TripOrchestrationCopyWithImpl<$Res>
    implements _$TripOrchestrationCopyWith<$Res> {
  __$TripOrchestrationCopyWithImpl(this._self, this._then);

  final _TripOrchestration _self;
  final $Res Function(_TripOrchestration) _then;

/// Create a copy of TripOrchestration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? providers = null,Object? cost = null,}) {
  return _then(_TripOrchestration(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,providers: null == providers ? _self._providers : providers // ignore: cast_nullable_to_non_nullable
as List<String>,cost: null == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
