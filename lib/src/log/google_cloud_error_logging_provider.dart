import 'package:googleapis/logging/v2.dart' as logging;
import 'package:googleapis_auth/auth_io.dart';

import 'error_logging_provider.dart';

// TODO: The user will need to configure their Google Cloud project and
//       provide the necessary credentials to use this provider.
//       This implementation assumes that the user has set up a service
//       account with the "Logs Writer" role and has provided the
//       service account key in a secure way.
class GoogleCloudErrorLoggingProvider implements ErrorLoggingProvider {
  final String projectId;
  final AutoRefreshingAuthClient client;
  late final logging.LoggingApi _loggingApi;

  GoogleCloudErrorLoggingProvider(this.projectId, this.client) {
    _loggingApi = logging.LoggingApi(client);
  }

  @override
  Future<void> log(String message, {String? severity}) async {
    await _writeLog(message, severity: severity ?? 'INFO');
  }

  @override
  Future<void> recordError(dynamic exception, StackTrace? stack, {bool fatal = false, String? severity}) async {
    await _writeLog(exception.toString(), severity: severity ?? 'ERROR');
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

  Future<void> _writeLog(String message, {String severity = 'INFO'}) async {
    final entry = logging.LogEntry()
      ..logName = 'projects/$projectId/logs/flutter_app'
      ..resource = (logging.MonitoredResource()..type = 'global')
      ..jsonPayload = {'message': message}
      ..severity = severity;

    final request = logging.WriteLogEntriesRequest()..entries = [entry];

    try {
      await _loggingApi.entries.write(request);
    } catch (e) {
      print('Failed to write log to Google Cloud Logging: $e');
    }
  }
}
