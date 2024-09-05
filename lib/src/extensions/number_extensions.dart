import 'package:ccl_core/src/currency/currency.dart';
import 'package:ccl_core/src/number_formatter/number_formatter.dart';

/// Extension methods for the `num` type.
extension NumberExtension on num {
  /// Formats the number using a [NumberFormatter] and returns a [String].
  String get format => NumberFormatter.format(this);

  /// Formats the number as a currency value and returns a [String].
  String get currency => Currency.format(this);

  /// Formats the number as a compact currency value and returns a [String].
  String get currencyCompact => Currency.formatCompact(this);

  /// Formats the number as a simple currency value and returns a [String].
  String get currencySimple => Currency.formatSimple(this);

  /// Formats the number as a compact and simple currency value and returns a [String].
  String get currencyCompactSimple => Currency.formatCompactSimple(this);
}