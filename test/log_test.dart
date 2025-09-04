import 'package:ccl_core/ccl_core.dart';
import 'package:ccl_core/src/log/error_logging_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talker_flutter/talker_flutter.dart';

class MockErrorLoggingProvider implements ErrorLoggingProvider {
  String? lastMessage;
  LogLevel? lastLevel;
  dynamic lastException;
  StackTrace? lastStackTrace;

  @override
  Future<void> log(String message, {LogLevel level = LogLevel.info}) async {
    lastMessage = message;
    lastLevel = level;
  }

  @override
  Future<void> recordError(exception, StackTrace? stack,
      {reason, bool fatal = false, LogLevel level = LogLevel.info}) async {
    lastException = exception;
    lastStackTrace = stack;
    lastLevel = level;
  }

  @override
  Future<void> setCustomKey(String key, Object value) async {}

  @override
  Future<void> setUserIdentifier(String identifier) async {}
}

void main() {
  group('Log', () {
    late MockErrorLoggingProvider mockErrorLoggingProvider;

    setUp(() async {
      mockErrorLoggingProvider = MockErrorLoggingProvider();
      await Log.init(
        logInDebugMode: true,
        logInProfileMode: true,
        logInReleaseMode: false,
        errorLoggingProvider: mockErrorLoggingProvider,
      );
    });

    test('Log.i should call log with correct parameters', () {
      Log.i('TestTag', 'Test message');
      expect(mockErrorLoggingProvider.lastMessage, contains('TestTag: Test message'));
    });

    test('Log.d should call log with correct parameters', () {
      Log.d('TestTag', 'Test message');
      expect(mockErrorLoggingProvider.lastMessage, contains('TestTag: Test message'));
    });

    test('Log.w should call log and recordError with correct parameters', () {
      final exception = Exception('Test exception');
      final stackTrace = StackTrace.current;
      Log.w('TestTag', 'Test message',
          exception: exception, stackTrace: stackTrace);
      expect(mockErrorLoggingProvider.lastMessage, contains('TestTag: Test message'));
      expect(mockErrorLoggingProvider.lastException, exception);
      expect(mockErrorLoggingProvider.lastStackTrace, stackTrace);
    });

    test('Log.e should call log and recordError with correct parameters', () {
      final exception = Exception('Test exception');
      final stackTrace = StackTrace.current;
      Log.e('TestTag', 'Test message',
          exception: exception, stackTrace: stackTrace);
      expect(mockErrorLoggingProvider.lastMessage, contains('TestTag: Test message'));
      expect(mockErrorLoggingProvider.lastException, exception);
      expect(mockErrorLoggingProvider.lastStackTrace, stackTrace);
    });
  });
}
