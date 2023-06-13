import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'country.freezed.dart';

@Freezed(
  copyWith: false,
  equal: false,
  fromJson: false,
  toJson: false,
)
class Country with _$Country {
  factory Country({
    required String name,
    required String isoCode,
    required String iso3Code,
    required String phoneCode,
  }) = _Country;
}