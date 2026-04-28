// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_ticket.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JobTicket {

 String get id; TicketType get type; String get name; double get totalPrice; double get employeeShare; double get employerSubsidy; DateTime get validFrom; DateTime get validTo; bool get isActive;
/// Create a copy of JobTicket
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobTicketCopyWith<JobTicket> get copyWith => _$JobTicketCopyWithImpl<JobTicket>(this as JobTicket, _$identity);

  /// Serializes this JobTicket to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobTicket&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.totalPrice, totalPrice) || other.totalPrice == totalPrice)&&(identical(other.employeeShare, employeeShare) || other.employeeShare == employeeShare)&&(identical(other.employerSubsidy, employerSubsidy) || other.employerSubsidy == employerSubsidy)&&(identical(other.validFrom, validFrom) || other.validFrom == validFrom)&&(identical(other.validTo, validTo) || other.validTo == validTo)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,name,totalPrice,employeeShare,employerSubsidy,validFrom,validTo,isActive);

@override
String toString() {
  return 'JobTicket(id: $id, type: $type, name: $name, totalPrice: $totalPrice, employeeShare: $employeeShare, employerSubsidy: $employerSubsidy, validFrom: $validFrom, validTo: $validTo, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $JobTicketCopyWith<$Res>  {
  factory $JobTicketCopyWith(JobTicket value, $Res Function(JobTicket) _then) = _$JobTicketCopyWithImpl;
@useResult
$Res call({
 String id, TicketType type, String name, double totalPrice, double employeeShare, double employerSubsidy, DateTime validFrom, DateTime validTo, bool isActive
});




}
/// @nodoc
class _$JobTicketCopyWithImpl<$Res>
    implements $JobTicketCopyWith<$Res> {
  _$JobTicketCopyWithImpl(this._self, this._then);

  final JobTicket _self;
  final $Res Function(JobTicket) _then;

/// Create a copy of JobTicket
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? name = null,Object? totalPrice = null,Object? employeeShare = null,Object? employerSubsidy = null,Object? validFrom = null,Object? validTo = null,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TicketType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,totalPrice: null == totalPrice ? _self.totalPrice : totalPrice // ignore: cast_nullable_to_non_nullable
as double,employeeShare: null == employeeShare ? _self.employeeShare : employeeShare // ignore: cast_nullable_to_non_nullable
as double,employerSubsidy: null == employerSubsidy ? _self.employerSubsidy : employerSubsidy // ignore: cast_nullable_to_non_nullable
as double,validFrom: null == validFrom ? _self.validFrom : validFrom // ignore: cast_nullable_to_non_nullable
as DateTime,validTo: null == validTo ? _self.validTo : validTo // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [JobTicket].
extension JobTicketPatterns on JobTicket {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobTicket value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobTicket() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobTicket value)  $default,){
final _that = this;
switch (_that) {
case _JobTicket():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobTicket value)?  $default,){
final _that = this;
switch (_that) {
case _JobTicket() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  TicketType type,  String name,  double totalPrice,  double employeeShare,  double employerSubsidy,  DateTime validFrom,  DateTime validTo,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobTicket() when $default != null:
return $default(_that.id,_that.type,_that.name,_that.totalPrice,_that.employeeShare,_that.employerSubsidy,_that.validFrom,_that.validTo,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  TicketType type,  String name,  double totalPrice,  double employeeShare,  double employerSubsidy,  DateTime validFrom,  DateTime validTo,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _JobTicket():
return $default(_that.id,_that.type,_that.name,_that.totalPrice,_that.employeeShare,_that.employerSubsidy,_that.validFrom,_that.validTo,_that.isActive);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  TicketType type,  String name,  double totalPrice,  double employeeShare,  double employerSubsidy,  DateTime validFrom,  DateTime validTo,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _JobTicket() when $default != null:
return $default(_that.id,_that.type,_that.name,_that.totalPrice,_that.employeeShare,_that.employerSubsidy,_that.validFrom,_that.validTo,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobTicket implements JobTicket {
  const _JobTicket({required this.id, required this.type, required this.name, required this.totalPrice, required this.employeeShare, required this.employerSubsidy, required this.validFrom, required this.validTo, required this.isActive});
  factory _JobTicket.fromJson(Map<String, dynamic> json) => _$JobTicketFromJson(json);

@override final  String id;
@override final  TicketType type;
@override final  String name;
@override final  double totalPrice;
@override final  double employeeShare;
@override final  double employerSubsidy;
@override final  DateTime validFrom;
@override final  DateTime validTo;
@override final  bool isActive;

/// Create a copy of JobTicket
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobTicketCopyWith<_JobTicket> get copyWith => __$JobTicketCopyWithImpl<_JobTicket>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobTicketToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobTicket&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.totalPrice, totalPrice) || other.totalPrice == totalPrice)&&(identical(other.employeeShare, employeeShare) || other.employeeShare == employeeShare)&&(identical(other.employerSubsidy, employerSubsidy) || other.employerSubsidy == employerSubsidy)&&(identical(other.validFrom, validFrom) || other.validFrom == validFrom)&&(identical(other.validTo, validTo) || other.validTo == validTo)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,name,totalPrice,employeeShare,employerSubsidy,validFrom,validTo,isActive);

@override
String toString() {
  return 'JobTicket(id: $id, type: $type, name: $name, totalPrice: $totalPrice, employeeShare: $employeeShare, employerSubsidy: $employerSubsidy, validFrom: $validFrom, validTo: $validTo, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$JobTicketCopyWith<$Res> implements $JobTicketCopyWith<$Res> {
  factory _$JobTicketCopyWith(_JobTicket value, $Res Function(_JobTicket) _then) = __$JobTicketCopyWithImpl;
@override @useResult
$Res call({
 String id, TicketType type, String name, double totalPrice, double employeeShare, double employerSubsidy, DateTime validFrom, DateTime validTo, bool isActive
});




}
/// @nodoc
class __$JobTicketCopyWithImpl<$Res>
    implements _$JobTicketCopyWith<$Res> {
  __$JobTicketCopyWithImpl(this._self, this._then);

  final _JobTicket _self;
  final $Res Function(_JobTicket) _then;

/// Create a copy of JobTicket
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? name = null,Object? totalPrice = null,Object? employeeShare = null,Object? employerSubsidy = null,Object? validFrom = null,Object? validTo = null,Object? isActive = null,}) {
  return _then(_JobTicket(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TicketType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,totalPrice: null == totalPrice ? _self.totalPrice : totalPrice // ignore: cast_nullable_to_non_nullable
as double,employeeShare: null == employeeShare ? _self.employeeShare : employeeShare // ignore: cast_nullable_to_non_nullable
as double,employerSubsidy: null == employerSubsidy ? _self.employerSubsidy : employerSubsidy // ignore: cast_nullable_to_non_nullable
as double,validFrom: null == validFrom ? _self.validFrom : validFrom // ignore: cast_nullable_to_non_nullable
as DateTime,validTo: null == validTo ? _self.validTo : validTo // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
