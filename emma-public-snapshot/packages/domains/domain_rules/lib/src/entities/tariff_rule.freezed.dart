// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tariff_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TariffRule {

 String get id; String get name; double get price; List<String> get entitlements; bool get isSubscription;
/// Create a copy of TariffRule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TariffRuleCopyWith<TariffRule> get copyWith => _$TariffRuleCopyWithImpl<TariffRule>(this as TariffRule, _$identity);

  /// Serializes this TariffRule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TariffRule&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&const DeepCollectionEquality().equals(other.entitlements, entitlements)&&(identical(other.isSubscription, isSubscription) || other.isSubscription == isSubscription));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,price,const DeepCollectionEquality().hash(entitlements),isSubscription);

@override
String toString() {
  return 'TariffRule(id: $id, name: $name, price: $price, entitlements: $entitlements, isSubscription: $isSubscription)';
}


}

/// @nodoc
abstract mixin class $TariffRuleCopyWith<$Res>  {
  factory $TariffRuleCopyWith(TariffRule value, $Res Function(TariffRule) _then) = _$TariffRuleCopyWithImpl;
@useResult
$Res call({
 String id, String name, double price, List<String> entitlements, bool isSubscription
});




}
/// @nodoc
class _$TariffRuleCopyWithImpl<$Res>
    implements $TariffRuleCopyWith<$Res> {
  _$TariffRuleCopyWithImpl(this._self, this._then);

  final TariffRule _self;
  final $Res Function(TariffRule) _then;

/// Create a copy of TariffRule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? price = null,Object? entitlements = null,Object? isSubscription = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,entitlements: null == entitlements ? _self.entitlements : entitlements // ignore: cast_nullable_to_non_nullable
as List<String>,isSubscription: null == isSubscription ? _self.isSubscription : isSubscription // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TariffRule].
extension TariffRulePatterns on TariffRule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TariffRule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TariffRule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TariffRule value)  $default,){
final _that = this;
switch (_that) {
case _TariffRule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TariffRule value)?  $default,){
final _that = this;
switch (_that) {
case _TariffRule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  double price,  List<String> entitlements,  bool isSubscription)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TariffRule() when $default != null:
return $default(_that.id,_that.name,_that.price,_that.entitlements,_that.isSubscription);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  double price,  List<String> entitlements,  bool isSubscription)  $default,) {final _that = this;
switch (_that) {
case _TariffRule():
return $default(_that.id,_that.name,_that.price,_that.entitlements,_that.isSubscription);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  double price,  List<String> entitlements,  bool isSubscription)?  $default,) {final _that = this;
switch (_that) {
case _TariffRule() when $default != null:
return $default(_that.id,_that.name,_that.price,_that.entitlements,_that.isSubscription);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TariffRule implements TariffRule {
  const _TariffRule({required this.id, required this.name, required this.price, required final  List<String> entitlements, required this.isSubscription}): _entitlements = entitlements;
  factory _TariffRule.fromJson(Map<String, dynamic> json) => _$TariffRuleFromJson(json);

@override final  String id;
@override final  String name;
@override final  double price;
 final  List<String> _entitlements;
@override List<String> get entitlements {
  if (_entitlements is EqualUnmodifiableListView) return _entitlements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entitlements);
}

@override final  bool isSubscription;

/// Create a copy of TariffRule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TariffRuleCopyWith<_TariffRule> get copyWith => __$TariffRuleCopyWithImpl<_TariffRule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TariffRuleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TariffRule&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&const DeepCollectionEquality().equals(other._entitlements, _entitlements)&&(identical(other.isSubscription, isSubscription) || other.isSubscription == isSubscription));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,price,const DeepCollectionEquality().hash(_entitlements),isSubscription);

@override
String toString() {
  return 'TariffRule(id: $id, name: $name, price: $price, entitlements: $entitlements, isSubscription: $isSubscription)';
}


}

/// @nodoc
abstract mixin class _$TariffRuleCopyWith<$Res> implements $TariffRuleCopyWith<$Res> {
  factory _$TariffRuleCopyWith(_TariffRule value, $Res Function(_TariffRule) _then) = __$TariffRuleCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, double price, List<String> entitlements, bool isSubscription
});




}
/// @nodoc
class __$TariffRuleCopyWithImpl<$Res>
    implements _$TariffRuleCopyWith<$Res> {
  __$TariffRuleCopyWithImpl(this._self, this._then);

  final _TariffRule _self;
  final $Res Function(_TariffRule) _then;

/// Create a copy of TariffRule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? price = null,Object? entitlements = null,Object? isSubscription = null,}) {
  return _then(_TariffRule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,entitlements: null == entitlements ? _self._entitlements : entitlements // ignore: cast_nullable_to_non_nullable
as List<String>,isSubscription: null == isSubscription ? _self.isSubscription : isSubscription // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
