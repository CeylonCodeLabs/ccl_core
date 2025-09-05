import 'dart:developer' as developer;
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:googleapis/logging/v2.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'error_logging_provider.dart';
import 'error_logging_provider_factory.dart';

// The comment block about Live Templates is not a standard library doc comment.
// It's more of a developer note. If it's intended for users of this library,
// it might be better placed in a README or a separate documentation file.
// For now, I'll leave it as is but convert it to standard comments.

//
// Live Templates
// For Android Studio you can add live templates to speedup your coding
//
// Setup:
// Step 1: Download live templates configuration settings.zip file
// Step 2: Choose File | Manage IDE Settings | Import Settings from the menu
// Step 3: Specify the path to the settings archive
// Step 4: In the Import Settings dialog, select the Live templates checkbox
//         and click OK
// Step 5: Restart the IDE
//
// For more info visit https://www.jetbrains.com/help/idea/sharing-live-templates.html#example
//

/// A utility class for unified logging across different build modes and platforms.
///
/// Provides static methods for logging informational messages, debug messages,
/// warnings, and errors. It integrates with an [ErrorLoggingProvider]
/// (e.g., Firebase Crashlytics, Google Cloud Logging) to report errors and logs
/// to remote services.
///
/// Before using any logging methods, the [Log] class must be initialized
/// by calling the [init] method. It also provides a [setup] method to
/// configure global error handlers for catching uncaught Flutter and Dart errors.
///
/// {@category Logging}
class Log {
  static Log? _instance;
  final bool _logInDebugMode;
  final bool _logInProfileMode;
  final bool _logInReleaseMode;
  final ErrorLoggingProvider _errorLoggingProvider;
  static late final Talker _talker;

  /// Private constructor for internal instantiation.
  ///
  /// Initializes the logging preferences and the error logging provider.
  Log._internal(
    this._logInDebugMode,
    this._logInProfileMode,
    this._logInReleaseMode,
    this._errorLoggingProvider,
  ) {
    _instance = this;
  }

  /// Sets up global error handlers to catch and report errors.
  ///
  /// This method configures three types of error handlers to ensure comprehensive
  /// error coverage:
  /// 1. `FlutterError.onError`: Catches errors that occur within the Flutter framework
  ///    (e.g., build errors, layout errors).
  /// 2. `PlatformDispatcher.instance.onError`: Catches errors that occur outside
  ///    of the Flutter framework in the main isolate (e.g., errors from platform
  ///    channels, asynchronous Dart code not caught by Flutter).
  /// 3. `Isolate.current.addErrorListener`: Catches errors from other isolates
  ///    that might be spawned by the application (e.g., background tasks).
  ///
  /// All caught errors are reported as fatal errors via the configured
  /// [ErrorLoggingProvider]. In debug mode, Flutter errors are also dumped
  /// to the console.
  static void setup() {
    FlutterError.onError = (errorDetails) {
      _talker.handle(
        errorDetails.exception,
        errorDetails.stack,
        'FlutterError',
      );
    };

    // Catch errors that occur outside of the Flutter framework in the Isolate
    // that the Flutter app runs on. This is crucial for catching errors like
    // those from platform channels or other asynchronous code.
    PlatformDispatcher.instance.onError = (error, stack) {
      _talker.handle(error, stack, 'PlatformDispatcher');
      return true;
    };

    // Listen for errors from other isolates that might be spawned by the app.
    // This ensures that errors from background tasks or separate compute isolates
    // are also captured.
    Isolate.current.addErrorListener(
      RawReceivePort((pair) async {
        final List<dynamic> errorAndStacktrace = pair;
        _talker.handle(
          errorAndStacktrace.first,
          errorAndStacktrace.last,
          'Isolate',
        );
      }).sendPort,
    );
  }

  /// Initializes the [Log] instance with specified configurations.
  ///
  /// This method must be called once, typically at application startup, before any
  /// logging methods ([i], [d], [w], [e]) or error reporting setup ([setup]) are used.
  /// It configures which build modes will have active logging to the console
  /// (via `developer.log`) and sets up the [ErrorLoggingProvider] for remote
  /// error and log reporting (e.g., Firebase Crashlytics, Google Cloud Logging).
  ///
  /// Attempting to call `init` multiple times will result in a warning log and
  /// the existing instance will be retained.
  ///
  /// Parameters:
  /// - [logInDebugMode]: Enables logging via `developer.log` in debug mode (`kDebugMode`).
  ///   Defaults to `true`.
  /// - [logInProfileMode]: Enables logging via `developer.log` in profile mode (`kProfileMode`).
  ///   Defaults to `true`.
  /// - [logInReleaseMode]: Enables logging via `developer.log` in release mode (`kReleaseMode`).
  ///   Defaults to `false`.
  /// - [enableFirebaseCrashlyticsInDebug]: Enables Firebase Crashlytics as the
  ///   error logging provider in debug mode. Defaults to `false`.
  /// - [enableFirebaseCrashlyticsInRelease]: Enables Firebase Crashlytics as the
  ///   error logging provider in release mode. Defaults to `false`.
  /// - [googleCloudProjectId]: The project ID for Google Cloud Logging.
  ///   This is typically required if [GcpErrorLoggingProvider] (or a similar
  ///   provider for Google Cloud) is used, especially for web applications.
  /// - [googleServiceJson]: A `Map<String, dynamic>` representing the JSON content of a
  ///   Google Service Account key file. This is used to create an authenticated
  ///   Google Cloud client via [_getGoogleAuthClient] if Google Cloud Logging
  ///   is the chosen provider.
  ///
  /// Throws:
  ///  - May throw exceptions during the instantiation of the [ErrorLoggingProvider]
  ///    if underlying services (like Firebase) fail to initialize.
  ///
  /// Example:
  ///
  /// Future<void> main() async {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///   // If using Flutter
  ///   // Example: Load service account JSON from assets (ensure it's in pubspec.yaml)
  ///   String serviceAccountJsonString = await rootBundle.loadString('assets/google-service-account.json');
  ///   // Map<String, dynamic>? serviceAccountCredentials = jsonDecode(serviceAccountJsonString) as Map<String, dynamic>?;
  ///   await Log.init(
  ///     logInDebugMode: true,
  ///     logInProfileMode: kProfileMode, // Only log in profile if in profile mode
  ///     logInReleaseMode: false,
  ///     enableFirebaseCrashlyticsInRelease: true, // Enable Crashlytics for release
  ///     // googleCloudProjectId: 'your-gcp-project-id', // If using GCP Logging
  ///     // googleServiceJson: serviceAccountCredentials, // Pass credentials if needed for GCP
  ///   );
  ///   Log.setup(); // Setup global error handlers after initialization
  ///   runApp(MyApp());
  /// }
  static Future<void> init({
    bool logInDebugMode = true,
    bool logInProfileMode = true,
    bool logInReleaseMode = false,
    bool enableFirebaseCrashlyticsInDebug = false,
    bool enableFirebaseCrashlyticsInRelease = false,
    String? googleCloudProjectId,
    Map<String, dynamic>? googleServiceJson,
    ErrorLoggingProvider? errorLoggingProvider,
  }) async {
    // Ensure this is only initialized once.
    if (_instance != null) {
      developer.log(
        'Log.init() called multiple times. The logger is already initialized.',
        name: 'Log.init',
        level: 900, // Warning level
      );
      return;
    }

    final provider = errorLoggingProvider ??
        await getErrorLoggingProvider(
          isWebApp: kIsWeb,
          googleCloudProjectId: googleCloudProjectId ?? '',
          enableFirebaseCrashlyticsInDebug: enableFirebaseCrashlyticsInDebug,
          enableFirebaseCrashlyticsInRelease: enableFirebaseCrashlyticsInRelease,
          googleAuthClient: await _getGoogleAuthClient(googleServiceJson),
        );

    _instance = Log._internal(
      logInDebugMode,
      logInProfileMode,
      logInReleaseMode,
      provider,
    );

    _talker = TalkerFlutter.init(
      observer: _ErrorLoggingObserver(provider),
    );
  }

  /// Creates an [AutoRefreshingAuthClient] from Google Service Account credentials.
  ///
  /// This private helper method is used to obtain an authenticated client for
  /// interacting with Google Cloud services, specifically for sending logs to
  /// Google Cloud Logging if it's the configured [ErrorLoggingProvider].
  /// The client uses service account credentials and automatically handles token refreshment.
  ///
  /// Parameters:
  /// - [googleServiceJson]: A `Map<String, dynamic>` containing the parsed JSON
  ///   credentials from a Google Service Account key file. If `null`, this method
  ///   will return `null`.
  ///
  /// Returns:
  ///  A `Future` that completes with an [AutoRefreshingAuthClient] instance
  ///  if [googleServiceJson] is provided and valid, allowing authenticated API calls
  ///  to Google Cloud services with the `logging.write` scope.
  ///  Returns `null` if [googleServiceJson] is `null` or if an error occurs
  ///  during client creation (e.g., invalid JSON format, network issues).
  ///  Errors during client creation are logged to `developer.log` but do not
  ///  throw, allowing the application to proceed, potentially without
  ///  Google Cloud logging capabilities.
  ///
  /// See also:
  ///  - [ServiceAccountCredentials.fromJson], for creating credentials from JSON.
  ///  - [clientViaServiceAccount], for obtaining an authenticated client.
  ///  - [LoggingApi.loggingWriteScope], the OAuth2 scope required to write logs.
  static Future<AutoRefreshingAuthClient?> _getGoogleAuthClient(
      Map<String, dynamic>? googleServiceJson) async {
    if (googleServiceJson == null) {
      return null;
    }

    try {
      // Create credentials using ServiceAccountCredentials from the provided JSON map.
      final credentials = ServiceAccountCredentials.fromJson(
        googleServiceJson,
      );

      // Authenticate using ServiceAccountCredentials and obtain an
      // AutoRefreshingAuthClient. This client will automatically refresh
      // access tokens as needed. The [LoggingApi.loggingWriteScope]
      // grants the necessary permission to write logs to Google Cloud Logging.
      return await clientViaServiceAccount(
        credentials,
        [LoggingApi.loggingWriteScope], // Scope for writing logs
      );
    } catch (e, s) {
      // Log an error if client creation fails, but don't let it crash the app.
      // This allows the app to continue, potentially without Google Cloud logging
      // if this was the intended provider.
      developer.log(
        'Failed to create Google Auth Client from service account JSON. '
        'Google Cloud Logging might not be available.',
        name: 'Log._getGoogleAuthClient',
        error: e,
        stackTrace: s,
        level: 1000,
      );
      return null; // Return null to indicate failure in client creation.
    }
  }

  /// Checks if the [Log] instance has been initialized via [Log.init].
  ///
  /// This private helper method is called at the beginning of public logging methods
  /// and setup methods to ensure that the logger has been properly configured
  /// before use.
  ///
  /// In debug mode (`kDebugMode` is true), if `_instance` is `null` (meaning [init]
  /// has not been called or completed successfully), this method will throw an
  /// [AssertionError] with a helpful message guiding the developer to call [Log.init].
  /// In profile and release modes, assertions are typically disabled, so this check
  /// will not have an effect, relying on null-aware operators or explicit null checks
  /// in the calling code if `_instance` could still be `null` (though `init` should
  /// prevent this if called correctly).
  ///
  /// This check helps catch common programming errors early during development.
  static void _checkInstance() {
    assert(
      _instance != null,
      '\n[Log] FATAL ERROR: Log instance is not initialized.'
      '\nEnsure `await Log.init()` is called and completes successfully at application startup '
      '\nbefore using any Log methods (e.g., Log.i(), Log.e(), Log.setup()).',
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
    _log(name, msg, level: LogLevel.info);
  }

  /// Logging debug
  ///
  /// [tag] page name or class name of the event origins
  /// [msg] log message
  /// [references] more event references such as\n method name or function name for further identification
  static void d(String tag, String msg, {List<String>? references}) {
    final ref = references != null && references.isNotEmpty
        ? ' : ${references.join(' => ')}'
        : '';
    final name = '$tag$ref';
    _log(name, msg, level: LogLevel.debug);
  }

  /// Logging warning
  ///
  /// [tag] page name or class name of the event origins
  /// [msg] log message
  /// [references] more event references such as\n method name or function name for further identification
  /// [exception] an exception detail
  /// [stackTrace] if available pass.\nThis is important when you using firebase crashlytics trace back the error
  static void w(String tag, String msg,
      {List<String>? references, exception, StackTrace? stackTrace}) {
    final ref = references != null && references.isNotEmpty
        ? ' : ${references.join(' => ')}'
        : '';
    final name = '$tag$ref';
    _log(name, msg,
        exception: exception, stackTrace: stackTrace, level: LogLevel.warning);
  }

  /// Logging an error
  ///
  /// [tag] page name or class name of the event origins
  /// [msg] log message
  /// [references] more event references such as\n method name or function name for further identification
  /// [exception] an exception detail
  /// [stackTrace] if available pass.\nThis is important when you using firebase crashlytics trace back the error
  static void e(String tag, String msg,
      {List<String>? references, exception, StackTrace? stackTrace}) {
    final ref = references != null && references.isNotEmpty
        ? ' : ${references.join(' => ')}'
        : '';
    final name = '$tag$ref';
    _log(name, msg,
        exception: exception, stackTrace: stackTrace, level: LogLevel.error);
  }

  static Future<void> setUserIdentifier(String identifier) {
    _checkInstance();
    return _instance!._errorLoggingProvider.setUserIdentifier(identifier);
  }

  static Future<void> setCustomKey(String key, Object value) {
    _checkInstance();
    return _instance!._errorLoggingProvider.setCustomKey(key, value);
  }

  static void _log(String name, String message,
      {exception, StackTrace? stackTrace, LogLevel level = LogLevel.info}) {
    _checkInstance();

    if ((_instance!._logInDebugMode && kDebugMode) ||
        (_instance!._logInProfileMode && kProfileMode) ||
        (_instance!._logInReleaseMode && kReleaseMode)) {
      _talker.log(
        '$name: $message',
        logLevel: level,
        exception: exception,
        stackTrace: stackTrace,
      );
    }
  }
}

class _ErrorLoggingObserver extends TalkerObserver {
  final ErrorLoggingProvider _errorLoggingProvider;

  _ErrorLoggingObserver(this._errorLoggingProvider);

  @override
  void onLog(TalkerData log) {
    _errorLoggingProvider.log(log.generateTextMessage());
  }

  @override
  void onError(TalkerError err) {
    _errorLoggingProvider.recordError(err.error, err.stackTrace);
  }

  @override
  void onException(TalkerException err) {
    _errorLoggingProvider.recordError(err.exception, err.stackTrace);
  }
}
