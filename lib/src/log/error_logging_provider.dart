abstract class ErrorLoggingProvider {
  Future<void> log(String message, {String? severity});

  Future<void> recordError(dynamic exception, StackTrace? stack, {bool fatal = false, String? severity});

  Future<void> setUserIdentifier(String identifier);

  Future<void> setCustomKey(String key, Object value);
}
