import 'package:intl/intl.dart';

/// A utility class for formatting and parsing currency values.
class Currency {
  static late Currency? _instance;
  final NumberFormat _currency;
  final NumberFormat _currencyCompact;
  final NumberFormat _currencySimple;
  final NumberFormat _currencyCompactSimple;

  Currency._internal(this._currency, this._currencyCompact,
      this._currencySimple, this._currencyCompactSimple) {
    _instance = this;
  }

  /// Initialize [Currency] instance
  ///
  /// * [locale] : If not specified, it will use the current default locale.
  /// * [name] : If specified, the currency with that ISO 4217 name will be used.
  /// * [symbol] : If [symbol] provided, then [name] will be ignored.
  /// * [decimalDigits] : Sets number of decimal places. Default value is 2.
  static void init({
    String? locale,
    String? name,
    String? symbol,
    int decimalDigits = 2,
  }) {
    locale ??= Intl.defaultLocale;

    final currency = NumberFormat.currency(
      locale: locale,
      name: name,
      symbol: symbol,
      decimalDigits: decimalDigits,
    );

    final currencyCompact = NumberFormat.compactCurrency(
      locale: locale,
      name: name,
      symbol: symbol,
      decimalDigits: decimalDigits,
    );
    final currencySimple = NumberFormat.simpleCurrency(
      locale: locale,
      name: name,
      decimalDigits: decimalDigits,
    );
    final currencyCompactSimple = NumberFormat.compactSimpleCurrency(
      locale: locale,
      name: name,
      decimalDigits: decimalDigits,
    );

    _instance = Currency._internal(
        currency, currencyCompact, currencySimple, currencyCompactSimple);
  }

  static Currency _getInstance() {
    assert(
    _instance != null,
    '\nEnsure to initialize Currency before accessing it.'
        '\nPlease execute the init method : Currency.init()',
    );

    return _instance!;
  }

  /// Formats a number as a currency string.
  static String format(num number) {
    return _getInstance()._currency.format(number);
  }

  /// Formats a number as a compact currency string.
  static String formatCompact(num number) {
    return _getInstance()._currencyCompact.format(number);
  }

  /// Formats a number as a simple currency string (without currency symbol).
  static String formatSimple(num number) {
    return _getInstance()._currencySimple.format(number);
  }

  /// Formats a number as a compact and simple currency string.
  static String formatCompactSimple(num number) {
    return _getInstance()._currencyCompactSimple.format(number);
  }

  /// Parses a currency string and returns a number.
  static num parse(String value) {
    return _getInstance()._currency.parse(value);
  }

  /// Parses a compact currency string and returns a number.
  static num parseCompact(String value) {
    return _getInstance()._currencyCompact.parse(value);
  }

  /// Parses a simple currency string (without currency symbol) and returns a number.
  static num parseSimple(String value) {
    return _getInstance()._currencySimple.parse(value);
  }

  /// Parses a compact and simple currency string and returns a number.
  static num parseCompactSimple(String value) {
    return _getInstance()._currencyCompactSimple.parse(value);
  }
}