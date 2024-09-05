import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String format(String pattern, [String? locale]) =>
      DateFormat(pattern, locale).format(this);

  //region date
  //region date month year
  /// Default => 2022-05-24 => 24-5-2022
  String toDMY([String? separator1 = '-', String? separator2 = '-']) =>
      DateFormat('d${separator1}M${separator1}y').format(this);

  /// Default => 2022-05-24 => 24-05-22
  String toDdMmYy([String? separator1 = '-', String? separator2 = '-']) =>
      DateFormat('dd${separator1}MM${separator2}yy').format(this);

  /// Default => 2022-05-24 => 24-05-2022
  String toDdMmYyyy([String? separator1 = '-', String? separator2 = '-']) =>
      DateFormat('dd${separator1}MM${separator2}yyyy').format(this);

  /// Default => 2022-05-24 => 24-May-22
  String toDdMmmYy([String? separator1 = '-', String? separator2 = '-']) =>
      DateFormat('dd${separator1}MMM${separator2}yy').format(this);

  /// Default => 2022-05-24 => 24-May-2022
  String toDdMmmYyyy([String? separator1 = '-', String? separator2 = '-']) =>
      DateFormat('dd${separator1}MMM${separator2}yyyy').format(this);

  //endregion

  //region month date year
  /// Default => 2022-05-24 => 5-24-2022
  String toMDY([String? separator1 = '-', String? separator2 = '-']) =>
      DateFormat('M${separator1}d${separator2}y').format(this);

  /// Default => 2022-05-24 => 05-24-22
  String toMmDdYy([String? separator1 = '-', String? separator2 = '-']) =>
      DateFormat('MM${separator1}dd${separator2}yy').format(this);

  /// Default => 2022-05-24 => May-24-2022
  String toMmDdYyyy([String? separator1 = '-', String? separator2 = '-']) =>
      DateFormat('MM${separator1}dd${separator2}yyyy').format(this);

  /// Default => 2022-05-24 => May-24-22
  String toMmmDdYy([String? separator1 = '-', String? separator2 = '-']) =>
      DateFormat('MMM${separator1}dd${separator2}yy').format(this);

  /// Default => 2022-05-24 => May-05-2022
  String toMmmDdYyyy([String? separator1 = '-', String? separator2 = '-']) =>
      DateFormat('MMM${separator1}dd${separator2}yyyy').format(this);

  //endregion

  //region year month date
  /// Default => 2022-05-24 => 2022-5-24
  String toYMD([String? separator1 = '-', String? separator2 = '-']) =>
      DateFormat('y${separator1}M${separator2}d').format(this);

  /// Default => 2022-05-24 => 22-05-24
  String toYyMmDd([String? separator1 = '-', String? separator2 = '-']) =>
      DateFormat('yy${separator1}MM${separator2}dd').format(this);

  /// Default => 2022-05-24 => 2022-05-24
  String toYyyyMmDd([String? separator1 = '-', String? separator2 = '-']) =>
      DateFormat('yyyy${separator1}MM${separator2}dd').format(this);

  /// Default => 2022-05-24 => 22-May-24
  String toYyMmmDd([String? separator1 = '-', String? separator2 = '-']) =>
      DateFormat('yy${separator1}MMM${separator2}dd').format(this);

  /// Default => 2022-05-24 => 2022-May-24
  String toYyyyMmmDd([String? separator1 = '-', String? separator2 = '-']) =>
      DateFormat('yyyy${separator1}MMM${separator2}dd').format(this);

//endregion
//endregion

//region time
  /// Result => 7:05 AM
  String tohmma() => DateFormat('h:mm a').format(this);

  /// Result => 7:05:12 AM
  String tohmmssa() => DateFormat('h:mm:ss a').format(this);

  /// Result => 07:05 AM
  String tohhmma() => DateFormat('hh:mm a').format(this);

  /// Result => 07:05:12 AM
  String tohhmmssa() => DateFormat('hh:mm:ss a').format(this);

  /// Result => 19:05
  String toHmm() => DateFormat('H:mm').format(this);

  /// Result => 19:05
  String toHHmm() => DateFormat('HH:mm').format(this);

  /// Result => 19:05:12
  String toHHmmss() => DateFormat('HH:mm').format(this);
//endregion time
}
