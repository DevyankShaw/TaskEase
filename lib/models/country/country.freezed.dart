// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'country.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Country {
  String get name => throw _privateConstructorUsedError;
  String get isoCode => throw _privateConstructorUsedError;
  String get iso3Code => throw _privateConstructorUsedError;
  String get phoneCode => throw _privateConstructorUsedError;
}

/// @nodoc

class _$_Country with DiagnosticableTreeMixin implements _Country {
  _$_Country(
      {required this.name,
      required this.isoCode,
      required this.iso3Code,
      required this.phoneCode});

  @override
  final String name;
  @override
  final String isoCode;
  @override
  final String iso3Code;
  @override
  final String phoneCode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Country(name: $name, isoCode: $isoCode, iso3Code: $iso3Code, phoneCode: $phoneCode)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Country'))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('isoCode', isoCode))
      ..add(DiagnosticsProperty('iso3Code', iso3Code))
      ..add(DiagnosticsProperty('phoneCode', phoneCode));
  }
}

abstract class _Country implements Country {
  factory _Country(
      {required final String name,
      required final String isoCode,
      required final String iso3Code,
      required final String phoneCode}) = _$_Country;

  @override
  String get name;
  @override
  String get isoCode;
  @override
  String get iso3Code;
  @override
  String get phoneCode;
}
