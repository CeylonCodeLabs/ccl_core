import 'package:talker_flutter/talker_flutter.dart';

abstract class ErrorLoggingProvider {
  Future<void> log(String message, {LogLevel level = LogLevel.info});

  Future<void> recordError(dynamic exception, StackTrace? stack,
      {bool fatal = false, LogLevel level = LogLevel.error});

  Future<void> setUserIdentifier(String identifier);

  Future<void> setCustomKey(String key, Object value);
}
