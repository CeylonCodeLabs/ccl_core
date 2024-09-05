/// Extension methods for the `double` type.
extension DoubleExtension on double {
  /// Converts the double to a string with two fixed decimal places.
  String get toStringTwoFixedDecimals => toStringAsFixed(2);

  /// Converts the double to a new double value with two fixed decimal places.
  double get toTwoFixedDecimals => double.parse(toStringTwoFixedDecimals);
}