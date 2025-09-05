import 'dart:developer' as developer;

import 'package:talker/talker.dart';

import 'error_logging_provider.dart';

class UnsupportedErrorLoggingProvider implements ErrorLoggingProvider {
  @override
  Future<void> log(String message, {LogLevel level = LogLevel.info}) {
    developer.log(
      "Unsupported platform: $message",
      level: 1000,
    );
    return Future.value();
  }

  @override
  Future<void> recordError(dynamic exception, StackTrace? stack,
      {bool fatal = false, LogLevel level = LogLevel.error}) {
    developer.log(
      "Unsupported platform: $exception",
      level: 1000,
    );
    return Future.value();
  }

  @override
  Future<void> setUserIdentifier(String identifier) {
    developer.log(
      "Unsupported platform: User identifier set to $identifier",
      level: 1000,
    );
    return Future.value();
  }

  @override
  Future<void> setCustomKey(String key, Object value) {
    developer.log(
      "Unsupported platform: Custom key '$key' set to '$value'",
      level: 1000,
    );
    return Future.value();
  }
}
