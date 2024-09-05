import 'dart:developer' as developer;

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

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
  final bool _enableFirebaseCrashlyticsInDebug;
  final bool _enableFirebaseCrashlyticsInRelease;

  Log._internal(
      this._logInDebugMode,
      this._logInProfileMode,
      this._logInReleaseMode,
      this._enableFirebaseCrashlyticsInDebug,
      this._enableFirebaseCrashlyticsInRelease) {
    _instance = this;
  }

  /// Initialize [Log] instance
  ///
  /// [logInDebugMode] Enable logging in debug mode ([kDebugMode]).\nDefault value is true.
  /// [logInReleaseMode] Enable logging in release mode ([kReleaseMode]).\nDefault value is false.
  /// [enableFirebaseCrashlyticsInDebug] Enable Firebase Crashlytics logging in debug mode ([kDebugMode]).\nDefault value is false.
  /// [enableFirebaseCrashlyticsInRelease] Enable Firebase Crashlytics logging in release mode ([kReleaseMode]).\nDefault value is false.
  static void init({
    bool logInDebugMode = true,
    bool logInProfileMode = true,
    bool logInReleaseMode = false,
    bool enableFirebaseCrashlyticsInDebug = false,
    bool enableFirebaseCrashlyticsInRelease = false,
  }) {
    _instance = _instance ??
        Log._internal(
            logInDebugMode,
            logInProfileMode,
            logInReleaseMode,
            enableFirebaseCrashlyticsInDebug,
            enableFirebaseCrashlyticsInRelease);
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
    final name = 'INFO: $tag$ref';
    _log(name, msg);
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
    final name = 'DEBUG: $tag$ref';
    _log(name, msg);
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
    final name = 'WARN: $tag$ref';
    _log(name, msg, exception: exception, stackTrace: stackTrace);
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
    final name = 'ERROR: $tag$ref';
    _log(name, msg, exception: exception, stackTrace: stackTrace);
  }

  static Future<void> setFirebaseCustomKey(String key, Object value) =>
      FirebaseCrashlytics.instance.setCustomKey(key, value);

  static void _log(String name, String msg,
      {exception, StackTrace? stackTrace}) async {
    _checkInstance();

    if ((_instance!._logInDebugMode && kDebugMode) ||
        (_instance!._logInProfileMode && kProfileMode) ||
        (_instance!._logInReleaseMode && kReleaseMode)) {
      developer.log(msg, name: name, error: exception, stackTrace: stackTrace);
    }

    if ((_instance!._enableFirebaseCrashlyticsInDebug && kDebugMode) ||
        (_instance!._enableFirebaseCrashlyticsInRelease && kReleaseMode)) {
      await FirebaseCrashlytics.instance.log('$name => $msg');

      if (exception != null || stackTrace != null) {
        await FirebaseCrashlytics.instance.recordError(exception, stackTrace);
      }
    }
  }
}
