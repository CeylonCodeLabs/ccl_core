import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:googleapis_auth/auth_io.dart';

import 'error_logging_provider.dart';
import 'firebase_error_logging_provider.dart';
import 'google_cloud_error_logging_provider.dart';
import 'unsupported_error_logging_provider.dart';

// TODO: The user will need to provide the necessary credentials to use this provider.
//       This implementation assumes that the user has set up a service
//       account with the "Logs Writer" role and has provided the
//       service account key in a secure way.
//
//       For example, the user could provide the credentials as a JSON string
//       in an environment variable, and then use `ServiceAccountCredentials.fromJson`
//       to create the credentials object.
Future<ErrorLoggingProvider> getErrorLoggingProvider({
  required bool isWebApp,
  required String googleCloudProjectId,
  required bool enableFirebaseCrashlyticsInDebug,
  required bool enableFirebaseCrashlyticsInRelease,
  Future<AutoRefreshingAuthClient>? googleAuthClient,
}) async {
  if (isWebApp) {
    if (googleAuthClient == null) {
      return UnsupportedErrorLoggingProvider();
    }
    final client = await googleAuthClient;
    return GoogleCloudErrorLoggingProvider(googleCloudProjectId, client);
  } else {
    try {
      return FirebaseErrorLoggingProvider(
        FirebaseCrashlytics.instance,
        enableFirebaseCrashlyticsInDebug,
        enableFirebaseCrashlyticsInRelease,
      );
    } catch (e) {
      // This will happen if the Firebase app is not initialized
      return UnsupportedErrorLoggingProvider();
    }
  }
}
