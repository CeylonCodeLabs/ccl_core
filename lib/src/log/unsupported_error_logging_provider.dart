import 'error_logging_provider.dart';

class UnsupportedErrorLoggingProvider implements ErrorLoggingProvider {
  @override
  Future<void> log(String message, {String? severity}) {
    print("Unsupported platform: $message");
    return Future.value();
  }

  @override
  Future<void> recordError(dynamic exception, StackTrace? stack, {bool fatal = false, String? severity}) {
    print("Unsupported platform: $exception");
    return Future.value();
  }

  @override
  Future<void> setUserIdentifier(String identifier) {
    print("Unsupported platform: User identifier set to $identifier");
    return Future.value();
  }

  @override
  Future<void> setCustomKey(String key, Object value) {
    print("Unsupported platform: Custom key '$key' set to '$value'");
    return Future.value();
  }
}
