/// Extension methods for the `List?` type.
extension ListExtension on List? {
  /// **Deprecated:** Use [isNotNullAndNotEmpty] instead.
  ///
  /// Returns `true` if the list is not null and not empty.
  @Deprecated('In favor of isNotNullAndNotEmpty')
  bool get isListNotEmptyOrNull => this != null && (this?.isNotEmpty ?? false);

  /// Returns `true` if the list is not null and not empty.
  bool get isNotNullAndNotEmpty => this != null && (this?.isNotEmpty ?? false);

  /// Returns `true` if the list is null or empty.
  bool get isNullOrEmpty => this == null || (this?.isEmpty ?? true);
}