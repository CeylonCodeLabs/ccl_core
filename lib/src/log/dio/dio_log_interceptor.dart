import 'package:ccl_core/src/log/dio/dio_logger_settings.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

class DioLogInterceptor extends TalkerDioLogger {
  DioLogInterceptor({
    Talker? talker,
    DioLoggerSettings settings = const DioLoggerSettings(),
  }) : super(talker: talker, settings: settings);
}
