import 'package:ccl_core/ccl_core.dart';
import 'package:ccl_core/src/log/error_logging_provider.dart';
import 'package:talker/talker.dart';

class MockErrorLoggingProvider implements ErrorLoggingProvider {
  int logCalledCount = 0;
  int recordErrorCalledCount = 0;
  int setUserIdentifierCalledCount = 0;
  int setCustomKeyCalledCount = 0;

  @override
  Future<void> log(String message, {LogLevel level = LogLevel.info}) async {
    logCalledCount++;
  }

  @override
  Future<void> recordError(dynamic exception, StackTrace? stack,
      {bool fatal = false, LogLevel level = LogLevel.error}) async {
    recordErrorCalledCount++;
  }

  @override
  Future<void> setCustomKey(String key, Object value) async {
    setCustomKeyCalledCount++;
  }

  @override
  Future<void> setUserIdentifier(String identifier) async {
    setUserIdentifierCalledCount++;
  }
}
