import 'package:intl/intl.dart';

/// A utility class for formatting and parsing numbers.
class NumberFormatter {
  static late NumberFormatter? _instance;
  final NumberFormat _formatter;

  NumberFormatter._internal(this._formatter) {
    _instance = this;
  }

  /// Initialize [NumberFormatter] instance.
  ///
  /// [formatter] - Optional. If not provided, a default [NumberFormat] instance will be used.
  static void init({NumberFormat? formatter}) {
    _instance = NumberFormatter._internal(formatter ?? NumberFormat());
  }

  static NumberFormatter _getInstance() {
    assert(
    _instance != null,
    '\nEnsure to initialize NumberFormatter before accessing it.'
        '\nPlease execute the init method : NumberFormatter.init()',
    );

    return _instance!;
  }

  /// The underlying [NumberFormat] instance used for formatting and parsing.
  NumberFormat get formatter => _formatter;

  /// Formats a number into a string representation.
  static String format(num value) => _getInstance()._formatter.format(value);

  /// Parses a string representation of a number and returns a numerical value.
  static num parse(String value) => _getInstance()._formatter.parse(value);
}