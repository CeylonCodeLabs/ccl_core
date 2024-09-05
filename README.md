<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# ccl_services

A Flutter package to reduce boilerplate code in your daily development by providing streamlined
services for common tasks.

## Features

* **Secure Storage:** Easily store and retrieve data securely using the `SecureStorageService`.
* **Locale Management:**  Streamline locale handling and updates with the `LocalizationService`.
* **Reduced Boilerplate:**  Eliminate repetitive code and focus on building your app's core
  functionality.
* **Integration with Stacked:**  Seamlessly integrates with the Stacked architecture for dependency
  injection and state management.

## Getting started

Add `ccl_services` to your `pubspec.yaml` file:
yaml dependencies: ccl_services: ^latest_version

Then, run `flutter pub get` to install the package.

## Usage

**1. Register Services with Stacked:**

```dart
void main() {
  setupLocator();
  runApp(MyApp());
}

void setupLocator() {
  StackedLocator.instance..registerLazySingleton(() =>
      SecureStorageService())..registerLazySingleton(() => LocalizationService());
}
```

**2. Access Services:**

```dart
class MyViewModel extends BaseViewModel {
  final _secureStorageService = StackedLocator.instance.get<SecureStorageService>();
  final _localizationService = StackedLocator.instance.get<LocalizationService>();
// ... use the services in your view model ... }
```

**Example: Storing and Retrieving User Preferences**

```dart 
// Store a user preference 
await _secureStorageService.setString('theme', 'dark');
// Retrieve a user preference 
final theme = await _secureStorageService.getString('theme') ;
```

**Example: Changing and Observing Locale**

```dart
// Change the locale 
final locale = Locale('es');
_localizationService.onLocaleChanged(locale);
// Observe locale changes 
_localizationService.localeController.listen((locale) {
// Update UI based on the new locale 
});
```

## Additional information

For more detailed examples and usage scenarios, please refer to the `/example` folder.

If you encounter any issues or have suggestions for improvement, please feel free to open an issue
on the GitHub repository.

Contributions are welcome!