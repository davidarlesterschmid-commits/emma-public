// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mobility_budget.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MobilityBudget {

 double get totalBudget; double get usedAmount; double get remainingAmount; DateTime get billingPeriodStart; DateTime get billingPeriodEnd; String get currency;
/// Create a copy of MobilityBudget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MobilityBudgetCopyWith<MobilityBudget> get copyWith => _$MobilityBudgetCopyWithImpl<MobilityBudget>(this as MobilityBudget, _$identity);

  /// Serializes this MobilityBudget to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MobilityBudget&&(identical(other.totalBudget, totalBudget) || other.totalBudget == totalBudget)&&(identical(other.usedAmount, usedAmount) || other.usedAmount == usedAmount)&&(identical(other.remainingAmount, remainingAmount) || other.remainingAmount == remainingAmount)&&(identical(other.billingPeriodStart, billingPeriodStart) || other.billingPeriodStart == billingPeriodStart)&&(identical(other.billingPeriodEnd, billingPeriodEnd) || other.billingPeriodEnd == billingPeriodEnd)&&(identical(other.currency, currency) || other.currency == currency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalBudget,usedAmount,remainingAmount,billingPeriodStart,billingPeriodEnd,currency);

@override
String toString() {
  return 'MobilityBudget(totalBudget: $totalBudget, usedAmount: $usedAmount, remainingAmount: $remainingAmount, billingPeriodStart: $billingPeriodStart, billingPeriodEnd: $billingPeriodEnd, currency: $currency)';
}


}

/// @nodoc
abstract mixin class $MobilityBudgetCopyWith<$Res>  {
  factory $MobilityBudgetCopyWith(MobilityBudget value, $Res Function(MobilityBudget) _then) = _$MobilityBudgetCopyWithImpl;
@useResult
$Res call({
 double totalBudget, double usedAmount, double remainingAmount, DateTime billingPeriodStart, DateTime billingPeriodEnd, String currency
});




}
/// @nodoc
class _$MobilityBudgetCopyWithImpl<$Res>
    implements $MobilityBudgetCopyWith<$Res> {
  _$MobilityBudgetCopyWithImpl(this._self, this._then);

  final MobilityBudget _self;
  final $Res Function(MobilityBudget) _then;

/// Create a copy of MobilityBudget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalBudget = null,Object? usedAmount = null,Object? remainingAmount = null,Object? billingPeriodStart = null,Object? billingPeriodEnd = null,Object? currency = null,}) {
  return _then(_self.copyWith(
totalBudget: null == totalBudget ? _self.totalBudget : totalBudget // ignore: cast_nullable_to_non_nullable
as double,usedAmount: null == usedAmount ? _self.usedAmount : usedAmount // ignore: cast_nullable_to_non_nullable
as double,remainingAmount: null == remainingAmount ? _self.remainingAmount : remainingAmount // ignore: cast_nullable_to_non_nullable
as double,billingPeriodStart: null == billingPeriodStart ? _self.billingPeriodStart : billingPeriodStart // ignore: cast_nullable_to_non_nullable
as DateTime,billingPeriodEnd: null == billingPeriodEnd ? _self.billingPeriodEnd : billingPeriodEnd // ignore: cast_nullable_to_non_nullable
as DateTime,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MobilityBudget].
extension MobilityBudgetPatterns on MobilityBudget {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MobilityBudget value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MobilityBudget() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MobilityBudget value)  $default,){
final _that = this;
switch (_that) {
case _MobilityBudget():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MobilityBudget value)?  $default,){
final _that = this;
switch (_that) {
case _MobilityBudget() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double totalBudget,  double usedAmount,  double remainingAmount,  DateTime billingPeriodStart,  DateTime billingPeriodEnd,  String currency)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MobilityBudget() when $default != null:
return $default(_that.totalBudget,_that.usedAmount,_that.remainingAmount,_that.billingPeriodStart,_that.billingPeriodEnd,_that.currency);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double totalBudget,  double usedAmount,  double remainingAmount,  DateTime billingPeriodStart,  DateTime billingPeriodEnd,  String currency)  $default,) {final _that = this;
switch (_that) {
case _MobilityBudget():
return $default(_that.totalBudget,_that.usedAmount,_that.remainingAmount,_that.billingPeriodStart,_that.billingPeriodEnd,_that.currency);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double totalBudget,  double usedAmount,  double remainingAmount,  DateTime billingPeriodStart,  DateTime billingPeriodEnd,  String currency)?  $default,) {final _that = this;
switch (_that) {
case _MobilityBudget() when $default != null:
return $default(_that.totalBudget,_that.usedAmount,_that.remainingAmount,_that.billingPeriodStart,_that.billingPeriodEnd,_that.currency);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MobilityBudget implements MobilityBudget {
  const _MobilityBudget({required this.totalBudget, required this.usedAmount, required this.remainingAmount, required this.billingPeriodStart, required this.billingPeriodEnd, required this.currency});
  factory _MobilityBudget.fromJson(Map<String, dynamic> json) => _$MobilityBudgetFromJson(json);

@override final  double totalBudget;
@override final  double usedAmount;
@override final  double remainingAmount;
@override final  DateTime billingPeriodStart;
@override final  DateTime billingPeriodEnd;
@override final  String currency;

/// Create a copy of MobilityBudget
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MobilityBudgetCopyWith<_MobilityBudget> get copyWith => __$MobilityBudgetCopyWithImpl<_MobilityBudget>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MobilityBudgetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MobilityBudget&&(identical(other.totalBudget, totalBudget) || other.totalBudget == totalBudget)&&(identical(other.usedAmount, usedAmount) || other.usedAmount == usedAmount)&&(identical(other.remainingAmount, remainingAmount) || other.remainingAmount == remainingAmount)&&(identical(other.billingPeriodStart, billingPeriodStart) || other.billingPeriodStart == billingPeriodStart)&&(identical(other.billingPeriodEnd, billingPeriodEnd) || other.billingPeriodEnd == billingPeriodEnd)&&(identical(other.currency, currency) || other.currency == currency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalBudget,usedAmount,remainingAmount,billingPeriodStart,billingPeriodEnd,currency);

@override
String toString() {
  return 'MobilityBudget(totalBudget: $totalBudget, usedAmount: $usedAmount, remainingAmount: $remainingAmount, billingPeriodStart: $billingPeriodStart, billingPeriodEnd: $billingPeriodEnd, currency: $currency)';
}


}

/// @nodoc
abstract mixin class _$MobilityBudgetCopyWith<$Res> implements $MobilityBudgetCopyWith<$Res> {
  factory _$MobilityBudgetCopyWith(_MobilityBudget value, $Res Function(_MobilityBudget) _then) = __$MobilityBudgetCopyWithImpl;
@override @useResult
$Res call({
 double totalBudget, double usedAmount, double remainingAmount, DateTime billingPeriodStart, DateTime billingPeriodEnd, String currency
});




}
/// @nodoc
class __$MobilityBudgetCopyWithImpl<$Res>
    implements _$MobilityBudgetCopyWith<$Res> {
  __$MobilityBudgetCopyWithImpl(this._self, this._then);

  final _MobilityBudget _self;
  final $Res Function(_MobilityBudget) _then;

/// Create a copy of MobilityBudget
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalBudget = null,Object? usedAmount = null,Object? remainingAmount = null,Object? billingPeriodStart = null,Object? billingPeriodEnd = null,Object? currency = null,}) {
  return _then(_MobilityBudget(
totalBudget: null == totalBudget ? _self.totalBudget : totalBudget // ignore: cast_nullable_to_non_nullable
as double,usedAmount: null == usedAmount ? _self.usedAmount : usedAmount // ignore: cast_nullable_to_non_nullable
as double,remainingAmount: null == remainingAmount ? _self.remainingAmount : remainingAmount // ignore: cast_nullable_to_non_nullable
as double,billingPeriodStart: null == billingPeriodStart ? _self.billingPeriodStart : billingPeriodStart // ignore: cast_nullable_to_non_nullable
as DateTime,billingPeriodEnd: null == billingPeriodEnd ? _self.billingPeriodEnd : billingPeriodEnd // ignore: cast_nullable_to_non_nullable
as DateTime,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
