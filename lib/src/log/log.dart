import 'dart:developer' as developer;
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:googleapis_auth/auth_io.dart';

import 'error_logging_provider.dart';
import 'error_logging_provider_factory.dart';

///
/// Live Templates
/// For Android Studio you can add live templates to speedup your coding
///
/// Setup:
/// Step 1: Download live templates configuration settings.zip file
/// Step 2: Choose File | Manage IDE Settings | Import Settings from the menu
/// Step 3: Specify the path to the settings archive
/// Step 4: In the Import Settings dialog, select the Live templates checkbox
///         and click OK
/// Step 5: Restart the IDE
///
/// For more info visit https://www.jetbrains.com/help/idea/sharing-live-templates.html#example
///
class Log {
  static Log? _instance;
  final bool _logInDebugMode;
  final bool _logInProfileMode;
  final bool _logInReleaseMode;
  final ErrorLoggingProvider _errorLoggingProvider;

  Log._internal(
    this._logInDebugMode,
    this._logInProfileMode,
    this._logInReleaseMode,
    this._errorLoggingProvider,
  ) {
    _instance = this;
  }

  /// Sets up global error handlers to catch and report errors using Firebase Crashlytics.
  ///
  /// This method configures three types of error handlers:
  /// 1. `FlutterError.onError`: Catches errors that occur within the Flutter framework.
  /// 2. `PlatformDispatcher.instance.onError`: Catches errors that occur outside of the Flutter framework in the main isolate.
  /// 3. `Isolate.current.addErrorListener`: Catches errors from other isolates.
  static void setup() {
    FlutterError.onError = (errorDetails) {
      // In debug mode, Flutter itself prints errors to the console.
      // In release mode, we rely on Crashlytics.
      if (kDebugMode) {
        FlutterError.dumpErrorToConsole(errorDetails);
      }
      _instance?._errorLoggingProvider.recordError(
        errorDetails.exception,
        errorDetails.stack,
        fatal: true,
      );
    };

    // Catch errors that occur outside of the Flutter framework in the Isolate that the Flutter app runs on.
    // This is crucial for catching errors like those from platform channels or other asynchronous code.
    PlatformDispatcher.instance.onError = (error, stack) {
      _instance?._errorLoggingProvider.recordError(error, stack, fatal: true);
      return true; // Return true to indicate that the error has been handled.
    };

    // Listen for errors from other isolates that might be spawned by the app.
    // This ensures that errors from background tasks are also captured.
    Isolate.current.addErrorListener(
      RawReceivePort((pair) async {
        final List<dynamic> errorAndStacktrace = pair;
        await _instance?._errorLoggingProvider.recordError(
          errorAndStacktrace.first,
          errorAndStacktrace.last,
          fatal: true,
        );
      }).sendPort,
    );
  }

  /// Initialize [Log] instance
  ///
  /// [logInDebugMode] Enable logging in debug mode ([kDebugMode]).\nDefault value is true.
  /// [logInReleaseMode] Enable logging in release mode ([kReleaseMode]).\nDefault value is false.
  /// [enableFirebaseCrashlyticsInDebug] Enable Firebase Crashlytics logging in debug mode ([kDebugMode]).\nDefault value is false.
  /// [enableFirebaseCrashlyticsInRelease] Enable Firebase Crashlytics logging in release mode ([kReleaseMode]).\nDefault value is false.
  /// [googleCloudProjectId] The project id of the google cloud project. This is required for web apps.
  /// [googleAuthClient] The google auth client. This is required for web apps.
  static Future<void> init({
    bool logInDebugMode = true,
    bool logInProfileMode = true,
    bool logInReleaseMode = false,
    bool enableFirebaseCrashlyticsInDebug = false,
    bool enableFirebaseCrashlyticsInRelease = false,
    String? googleCloudProjectId,
    Future<AutoRefreshingAuthClient>? googleAuthClient,
  }) async {
    _instance = _instance ??
        Log._internal(
          logInDebugMode,
          logInProfileMode,
          logInReleaseMode,
          await getErrorLoggingProvider(
            isWebApp: kIsWeb,
            googleCloudProjectId: googleCloudProjectId ?? '',
            enableFirebaseCrashlyticsInDebug: enableFirebaseCrashlyticsInDebug,
            enableFirebaseCrashlyticsInRelease:
                enableFirebaseCrashlyticsInRelease,
            googleAuthClient: googleAuthClient,
          ),
        );
  }

  static void _checkInstance() {
    assert(
      _instance != null,
      '\nEnsure to initialize Log before accessing it.'
      '\nPlease execute the init method : Log.init()',
    );
  }

  /// Logging information
  ///
  /// [tag] page name or class name of the event origins
  /// [msg] log message
  /// [references] more event references such as\n method name or function name for further identification
  static void i(String tag, String msg, {List<String>? references}) {
    final ref = references != null && references.isNotEmpty
        ? ' : ${references.join(' => ')}'
        : '';
    final name = '$tag$ref';
    _log(name, msg, severity: 'INFO');
  }

  /// Logging debug
  ///
  /// [tag] page name or class name of the event origins
  /// [msg] log message
  /// [references] more event references such as\n method name or function name for further identification
  static void d(String tag, String msg, {List<String>? references}) async {
    final ref = references != null && references.isNotEmpty
        ? ' : ${references.join(' => ')}'
        : '';
    final name = '$tag$ref';
    _log(name, msg, severity: 'DEBUG');
  }

  /// Logging warning
  ///
  /// [tag] page name or class name of the event origins
  /// [msg] log message
  /// [references] more event references such as\n method name or function name for further identification
  /// [exception] an exception detail
  /// [stackTrace] if available pass.\nThis is important when you using firebase crashlytics trace back the error
  static void w(String tag, String msg,
      {List<String>? references, exception, StackTrace? stackTrace}) async {
    final ref = references != null && references.isNotEmpty
        ? ' : ${references.join(' => ')}'
        : '';
    final name = '$tag$ref';
    _log(name, msg, exception: exception, stackTrace: stackTrace, severity: 'WARNING');
  }

  /// Logging an error
  ///
  /// [tag] page name or class name of the event origins
  /// [msg] log message
  /// [references] more event references such as\n method name or function name for further identification
  /// [exception] an exception detail
  /// [stackTrace] if available pass.\nThis is important when you using firebase crashlytics trace back the error
  static void e(String tag, String msg,
      {List<String>? references, exception, StackTrace? stackTrace}) async {
    final ref = references != null && references.isNotEmpty
        ? ' : ${references.join(' => ')}'
        : '';
    final name = '$tag$ref';
    _log(name, msg, exception: exception, stackTrace: stackTrace, severity: 'ERROR');
  }

  static Future<void> setUserIdentifier(String identifier) {
    _checkInstance();
    return _instance!._errorLoggingProvider.setUserIdentifier(identifier);
  }

  static Future<void> setCustomKey(String key, Object value) {
    _checkInstance();
    return _instance!._errorLoggingProvider.setCustomKey(key, value);
  }

  static void _log(String name, String msg,
      {exception, StackTrace? stackTrace, String? severity}) async {
    _checkInstance();

    if ((_instance!._logInDebugMode && kDebugMode) ||
        (_instance!._logInProfileMode && kProfileMode) ||
        (_instance!._logInReleaseMode && kReleaseMode)) {
      developer.log(msg, name: name, error: exception, stackTrace: stackTrace);
    }

    await _instance!._errorLoggingProvider.log('$name => $msg', severity: severity);

    if (exception != null || stackTrace != null) {
      await _instance!._errorLoggingProvider.recordError(exception, stackTrace, severity: severity);
    }
  }
}
