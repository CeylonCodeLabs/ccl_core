import 'dart:developer' as developer;

import 'package:googleapis/logging/v2.dart' as logging;
import 'package:googleapis_auth/auth_io.dart';
import 'package:logger/logger.dart';

import 'error_logging_provider.dart';

// provide the necessary credentials to use this provider.
// This implementation assumes that the user has set up a service
// account with the "Logs Writer" role and has provided the
// service account key in a secure way.
class GoogleCloudErrorLoggingProvider implements ErrorLoggingProvider {
  final String projectId;
  final AutoRefreshingAuthClient client;
  late final logging.LoggingApi _loggingApi;

  GoogleCloudErrorLoggingProvider(this.projectId, this.client) {
    _loggingApi = logging.LoggingApi(client);
  }

  @override
  Future<void> log(String message, {Level level = Level.info}) async {
    await _writeLog(message, level: level);
  }

  @override
  Future<void> recordError(dynamic exception, StackTrace? stack,
      {bool fatal = false, Level level = Level.error}) async {
    await _writeLog(exception.toString(), level: level);
  }

  @override
  Future<void> setUserIdentifier(String identifier) async {
    // Not directly supported by Google Cloud Logging in the same way as Crashlytics
    // You can add the user identifier as a label to the log entries.
  }

  @override
  Future<void> setCustomKey(String key, Object value) async {
    // Not directly supported by Google Cloud Logging in the same way as Crashlytics
    // You can add custom keys as labels to the log entries.
  }

  Future<void> _writeLog(String message, {Level level = Level.info}) async {
    final entry = logging.LogEntry()
      ..logName = 'projects/$projectId/logs/flutter_app'
      ..resource = (logging.MonitoredResource()..type = 'global')
      ..jsonPayload = {'message': message}
      ..severity = _getSeverity(level);

    final request = logging.WriteLogEntriesRequest()..entries = [entry];

    try {
      await _loggingApi.entries.write(request);
    } catch (e, st) {
      developer.log(
        'Failed to write log to Google Cloud Logging',
        error: e,
        stackTrace: st,
        level: 1000,
      );
    }
  }

  String _getSeverity(Level level) {
    switch (level) {
      case Level.debug:
        return 'DEBUG';
      case Level.info:
        return 'INFO';
      case Level.warning:
        return 'WARNING';
      case Level.error:
        return 'ERROR';
      case Level.fatal:
        return 'CRITICAL';
      default:
        return 'DEFAULT';
    }
  }
}
