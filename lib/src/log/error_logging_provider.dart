import 'package:logger/logger.dart';

abstract class ErrorLoggingProvider {
  Future<void> log(String message, {Level level = Level.info});

  Future<void> recordError(dynamic exception, StackTrace? stack,
      {bool fatal = false, Level level = Level.error});

  Future<void> setUserIdentifier(String identifier);

  Future<void> setCustomKey(String key, Object value);
}
