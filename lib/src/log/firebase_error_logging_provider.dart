import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import 'error_logging_provider.dart';

class FirebaseErrorLoggingProvider implements ErrorLoggingProvider {
  final FirebaseCrashlytics _crashlytics;
  final bool _enableFirebaseCrashlyticsInDebug;
  final bool _enableFirebaseCrashlyticsInRelease;

  FirebaseErrorLoggingProvider(this._crashlytics,
      this._enableFirebaseCrashlyticsInDebug,
      this._enableFirebaseCrashlyticsInRelease);

  @override
  Future<void> log(String message, {Level? level}) {
    if ((_enableFirebaseCrashlyticsInDebug && kDebugMode) ||
        (_enableFirebaseCrashlyticsInRelease && kReleaseMode)) {
      return _crashlytics.log('${level ?? 'INFO'}: $message');
    }
    return Future.value();
  }

  @override
  Future<void> recordError(dynamic exception, StackTrace? stack, {bool fatal = false, Level? level}) {
    if ((_enableFirebaseCrashlyticsInDebug && kDebugMode) ||
        (_enableFirebaseCrashlyticsInRelease && kReleaseMode)) {
      return _crashlytics.recordError(exception, stack, fatal: fatal);
    }
    return Future.value();
  }

  @override
  Future<void> setUserIdentifier(String identifier) {
    if ((_enableFirebaseCrashlyticsInDebug && kDebugMode) ||
        (_enableFirebaseCrashlyticsInRelease && kReleaseMode)) {
      return _crashlytics.setUserIdentifier(identifier);
    }
    return Future.value();
  }

  @override
  Future<void> setCustomKey(String key, Object value) {
    if ((_enableFirebaseCrashlyticsInDebug && kDebugMode) ||
        (_enableFirebaseCrashlyticsInRelease && kReleaseMode)) {
      return _crashlytics.setCustomKey(key, value);
    }
    return Future.value();
  }
}
