// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'benefit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Benefit {

 String get id; String get name; String get description; String get partnerName; bool get isInBudget; String? get deepLink; String? get voucherCode; String? get logoUrl;
/// Create a copy of Benefit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BenefitCopyWith<Benefit> get copyWith => _$BenefitCopyWithImpl<Benefit>(this as Benefit, _$identity);

  /// Serializes this Benefit to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Benefit&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.partnerName, partnerName) || other.partnerName == partnerName)&&(identical(other.isInBudget, isInBudget) || other.isInBudget == isInBudget)&&(identical(other.deepLink, deepLink) || other.deepLink == deepLink)&&(identical(other.voucherCode, voucherCode) || other.voucherCode == voucherCode)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,partnerName,isInBudget,deepLink,voucherCode,logoUrl);

@override
String toString() {
  return 'Benefit(id: $id, name: $name, description: $description, partnerName: $partnerName, isInBudget: $isInBudget, deepLink: $deepLink, voucherCode: $voucherCode, logoUrl: $logoUrl)';
}


}

/// @nodoc
abstract mixin class $BenefitCopyWith<$Res>  {
  factory $BenefitCopyWith(Benefit value, $Res Function(Benefit) _then) = _$BenefitCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, String partnerName, bool isInBudget, String? deepLink, String? voucherCode, String? logoUrl
});




}
/// @nodoc
class _$BenefitCopyWithImpl<$Res>
    implements $BenefitCopyWith<$Res> {
  _$BenefitCopyWithImpl(this._self, this._then);

  final Benefit _self;
  final $Res Function(Benefit) _then;

/// Create a copy of Benefit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? partnerName = null,Object? isInBudget = null,Object? deepLink = freezed,Object? voucherCode = freezed,Object? logoUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,partnerName: null == partnerName ? _self.partnerName : partnerName // ignore: cast_nullable_to_non_nullable
as String,isInBudget: null == isInBudget ? _self.isInBudget : isInBudget // ignore: cast_nullable_to_non_nullable
as bool,deepLink: freezed == deepLink ? _self.deepLink : deepLink // ignore: cast_nullable_to_non_nullable
as String?,voucherCode: freezed == voucherCode ? _self.voucherCode : voucherCode // ignore: cast_nullable_to_non_nullable
as String?,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Benefit].
extension BenefitPatterns on Benefit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Benefit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Benefit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Benefit value)  $default,){
final _that = this;
switch (_that) {
case _Benefit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Benefit value)?  $default,){
final _that = this;
switch (_that) {
case _Benefit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  String partnerName,  bool isInBudget,  String? deepLink,  String? voucherCode,  String? logoUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Benefit() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.partnerName,_that.isInBudget,_that.deepLink,_that.voucherCode,_that.logoUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  String partnerName,  bool isInBudget,  String? deepLink,  String? voucherCode,  String? logoUrl)  $default,) {final _that = this;
switch (_that) {
case _Benefit():
return $default(_that.id,_that.name,_that.description,_that.partnerName,_that.isInBudget,_that.deepLink,_that.voucherCode,_that.logoUrl);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  String partnerName,  bool isInBudget,  String? deepLink,  String? voucherCode,  String? logoUrl)?  $default,) {final _that = this;
switch (_that) {
case _Benefit() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.partnerName,_that.isInBudget,_that.deepLink,_that.voucherCode,_that.logoUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Benefit implements Benefit {
  const _Benefit({required this.id, required this.name, required this.description, required this.partnerName, required this.isInBudget, required this.deepLink, required this.voucherCode, required this.logoUrl});
  factory _Benefit.fromJson(Map<String, dynamic> json) => _$BenefitFromJson(json);

@override final  String id;
@override final  String name;
@override final  String description;
@override final  String partnerName;
@override final  bool isInBudget;
@override final  String? deepLink;
@override final  String? voucherCode;
@override final  String? logoUrl;

/// Create a copy of Benefit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BenefitCopyWith<_Benefit> get copyWith => __$BenefitCopyWithImpl<_Benefit>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BenefitToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Benefit&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.partnerName, partnerName) || other.partnerName == partnerName)&&(identical(other.isInBudget, isInBudget) || other.isInBudget == isInBudget)&&(identical(other.deepLink, deepLink) || other.deepLink == deepLink)&&(identical(other.voucherCode, voucherCode) || other.voucherCode == voucherCode)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,partnerName,isInBudget,deepLink,voucherCode,logoUrl);

@override
String toString() {
  return 'Benefit(id: $id, name: $name, description: $description, partnerName: $partnerName, isInBudget: $isInBudget, deepLink: $deepLink, voucherCode: $voucherCode, logoUrl: $logoUrl)';
}


}

/// @nodoc
abstract mixin class _$BenefitCopyWith<$Res> implements $BenefitCopyWith<$Res> {
  factory _$BenefitCopyWith(_Benefit value, $Res Function(_Benefit) _then) = __$BenefitCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, String partnerName, bool isInBudget, String? deepLink, String? voucherCode, String? logoUrl
});




}
/// @nodoc
class __$BenefitCopyWithImpl<$Res>
    implements _$BenefitCopyWith<$Res> {
  __$BenefitCopyWithImpl(this._self, this._then);

  final _Benefit _self;
  final $Res Function(_Benefit) _then;

/// Create a copy of Benefit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? partnerName = null,Object? isInBudget = null,Object? deepLink = freezed,Object? voucherCode = freezed,Object? logoUrl = freezed,}) {
  return _then(_Benefit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,partnerName: null == partnerName ? _self.partnerName : partnerName // ignore: cast_nullable_to_non_nullable
as String,isInBudget: null == isInBudget ? _self.isInBudget : isInBudget // ignore: cast_nullable_to_non_nullable
as bool,deepLink: freezed == deepLink ? _self.deepLink : deepLink // ignore: cast_nullable_to_non_nullable
as String?,voucherCode: freezed == voucherCode ? _self.voucherCode : voucherCode // ignore: cast_nullable_to_non_nullable
as String?,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
