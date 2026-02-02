import 'package:ccl_core/ccl_core.dart';
import 'package:ccl_core/src/log/log.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_error_logging_provider.dart';

void main() {
  group('Log', () {
    late MockErrorLoggingProvider mockErrorLoggingProvider;

    setUp(() async {
      mockErrorLoggingProvider = MockErrorLoggingProvider();
      await Log.init(
        errorLoggingProvider: mockErrorLoggingProvider,
      );
    });

    tearDown(() {
      Log.reset();
    });

    test('init should initialize the logger', () async {
      // We can't directly test the static instance, but we can test
      // that calling a method after init doesn't throw the assertion error.
      // A simple way is to call a log method.
      Log.i('Test', 'Log has been initialized.');
    });

    test('calling log method before init should throw AssertionError', () {
      Log.reset();
      expect(() => Log.i('Test', 'Should fail'), throwsAssertionError);
    });

    test('i should call log on the error logging provider', () {
      Log.i('Test', 'Info message');
      expect(mockErrorLoggingProvider.logCalledCount, 1);
    });

    test('d should call log on the error logging provider', () {
      Log.d('Test', 'Debug message');
      expect(mockErrorLoggingProvider.logCalledCount, 1);
    });

    test('w should call log on the error logging provider', () {
      Log.w('Test', 'Warning message');
      expect(mockErrorLoggingProvider.logCalledCount, 1);
    });

    // test('e should call recordError on the error logging provider', () {
    //   Log.e('Test', 'Error message');
    //   expect(mockErrorLoggingProvider.recordErrorCalledCount, 1);
    // });

    test('setup should configure error handlers', () {
      Log.setup();
      // We can't directly test the error handlers, but we can check that
      // the method doesn't throw any exceptions.
    });
  });
}
