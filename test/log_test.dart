import 'package:ccl_core/ccl_core.dart';
import 'package:ccl_core/src/log/error_logging_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';

class MockErrorLoggingProvider implements ErrorLoggingProvider {
  String? lastMessage;
  Level? lastLevel;
  dynamic lastException;
  StackTrace? lastStackTrace;

  @override
  Future<void> log(String message, {Level level = Level.off}) async {
    lastMessage = message;
    lastLevel = level;
  }

  @override
  Future<void> recordError(exception, StackTrace? stack,
      {reason, bool fatal = false, Level level = Level.off}) async {
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
      );
      // Manually set the mock provider
      Log.instance = Log._internal(
        true,
        true,
        false,
        mockErrorLoggingProvider,
      );
    });

    test('should initialize correctly', () {
      expect(Log.instance, isNotNull);
    });

    test('Log.i should call log with correct parameters', () {
      Log.i('TestTag', 'Test message');
      expect(mockErrorLoggingProvider.lastMessage,
          contains('TestTag => Test message'));
      expect(mockErrorLoggingProvider.lastLevel, Level.info);
    });

    test('Log.d should call log with correct parameters', () {
      Log.d('TestTag', 'Test message');
      expect(mockErrorLoggingProvider.lastMessage,
          contains('TestTag => Test message'));
      expect(mockErrorLoggingProvider.lastLevel, Level.debug);
    });

    test('Log.w should call log and recordError with correct parameters', () {
      final exception = Exception('Test exception');
      final stackTrace = StackTrace.current;
      Log.w('TestTag', 'Test message',
          exception: exception, stackTrace: stackTrace);
      expect(mockErrorLoggingProvider.lastMessage,
          contains('TestTag => Test message'));
      expect(mockErrorLoggingProvider.lastLevel, Level.warning);
      expect(mockErrorLoggingProvider.lastException, exception);
      expect(mockErrorLoggingProvider.lastStackTrace, stackTrace);
    });

    test('Log.e should call log and recordError with correct parameters', () {
      final exception = Exception('Test exception');
      final stackTrace = StackTrace.current;
      Log.e('TestTag', 'Test message',
          exception: exception, stackTrace: stackTrace);
      expect(mockErrorLoggingProvider.lastMessage,
          contains('TestTag => Test message'));
      expect(mockErrorLoggingProvider.lastLevel, Level.error);
      expect(mockErrorLoggingProvider.lastException, exception);
      expect(mockErrorLoggingProvider.lastStackTrace, stackTrace);
    });
  });
}
