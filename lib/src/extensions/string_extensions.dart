import 'package:ccl_core/src/currency/currency.dart';
import 'package:ccl_core/src/number_formatter/number_formatter.dart';
import 'package:flutter/material.dart';

/// Extension methods for the `String` type.
extension StringExtension on String {
  /// Parses the string as a hexadecimal color value and returns a [Color] object.
  Color get color => Color(int.parse(replaceAll('#', '0xff')));

  /// Parses the string as a currency value and returns a [num].
  num get currency => Currency.parse(this);

  /// Parses the string as a compact currency value and returns a [num].
  num get currencyCompact => Currency.parseCompact(this);

  /// Parses the string as a simple currency value and returns a [num].
  num get currencySimple => Currency.parseSimple(this);

  /// Parses the string as a compact and simple currency value and returns a [num].
  num get currencyCompactSimple => Currency.parseCompactSimple(this);

  /// Parses the string using a [NumberFormatter] and returns a [num].
  num get numberFormatterParse => NumberFormatter.parse(this);

  /// Attempts to parse the string as a [DateTime] object.
  DateTime? get dateTime => DateTime.tryParse(this);
}

/// Extension methods for the `String?` (nullable String) type.
extension NullStringExtension on String? {
  /// Parses the string as a hexadecimal color value and returns a [Color] object, or `null` if the string is null or empty.
  Color? get color => isNotNullAndNotEmpty
      ? Color(int.parse(this!.replaceAll('#', '0xff')))
      : null;

  /// Parses the string as a currency value and returns a [num], or `null` if the string is null or empty.
  num? get currency => isNotNullAndNotEmpty ? Currency.parse(this!) : null;

  /// Parses the string as a compact currency value and returns a [num], or `null` if the string is null or empty.
  num? get currencyCompact =>
      isNotNullAndNotEmpty ? Currency.parseCompact(this!) : null;

  /// Parses the string as a simple currency value and returns a [num], or `null` if the string is null or empty.
  num? get currencySimple =>
      isNotNullAndNotEmpty ? Currency.parseSimple(this!) : null;

  /// Parses the string as a compact and simple currency value and returns a [num], or `null` if the string is null or empty.
  num? get currencyCompactSimple =>
      isNotNullAndNotEmpty ? Currency.parseCompactSimple(this!) : null;

  /// Attempts to parse the string as a [DateTime] object, or returns `null` if the string is null or empty.
  DateTime? get dateTime =>
      isNotNullAndNotEmpty ? DateTime.tryParse(this!) : null;

  /// **Deprecated:** Use [isNotNullAndNotEmpty] instead.
  ///
  /// Returns `true` if the string is not null and not empty.
  @Deprecated('In favor of isNotNullAndNotEmpty')
  bool get isNotNullOrEmpty => this != null && (this?.isNotEmpty ?? false);

  /// Returns `true` if the string is not null and not empty.
  bool get isNotNullAndNotEmpty => this != null && (this?.isNotEmpty ?? false);

  /// Returns `true` if the string is null or empty.
  bool get isNullOrEmpty => this == null || (this?.isEmpty ?? true);
}
