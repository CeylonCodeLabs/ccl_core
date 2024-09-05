# flutter_support_pack

[![pub package](https://img.shields.io/pub/v/ccl_core.svg)](https://pub.dartlang.org/packages/ccl_core)

Commonly used features in on package to reduce number of imports and dependency issues

I have discontinued the flutter_support_pack in favor of this package.

## Usage

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  ...
  ccl_core: [USE LATEST VERSION]
```

In your library add the following import:

```dart
import 'package:ccl_core/ccl_core.dart';
```

## Packages (more to come)

## Validators

Validators api provide you to validate form fields as well as other text validations.

### validateRequired

Only you need to pass the value that needs be get validated.

### validateEmail

Here you can pass an string value which needs to be get validated as an email.

### validateMobileNumber

Pass a string value and other parameters as per requirement get validated.

#### Properties

| Property        | Type   | Default Value | Description                                                                                    |
|:----------------|:-------|:--------------|:-----------------------------------------------------------------------------------------------|
| value           | String | null          | The phone number. By default validate for SL phone numbers. Use pattern for any custom numbers |
| allowLandNumber | bool   | false         | Enable land number validation. Only avaiable for SL country format                             |
| optional        | bool   | false         | Sets the field as an optional                                                                  |
| pattern         | String | null          | Pass a custom pattern to validate                                                              |

### validateNIC

Pass a string value and this method only works for SL.

### validateConfirmPassword

Validates current field value against provided value.

#### Properties

| Property | Type   | Default Value | Description          |
|:---------|:-------|:--------------|:---------------------|
| value    | String | null          | Field password value |
| password | String | null          | Existing password    |

#### Example Useage

```
TextFormField(
  controller: newPasswordController,
  focusNode: focusNewPassword,
  keyboardType: TextInputType.visiblePassword,
  obscureText: true,
  maxLines: 1,
  textInputAction: TextInputAction.next,
  validator: (value) =>
      Validators.validateConfirmPassword(
    value,
    [currentPassword],
  ),
  decoration: InputDecoration(
    labelText: 'New Password',
  ),
),
```

### validatePinCode

Validates a pin code.

#### Properties

| Property | Type   | Default Value | Description                       |
|:---------|:-------|:--------------|:----------------------------------|
| value    | String | null          | Pin code value                    |
| length   | int    | 6             | Define the length of the pin code |

#### **SL means Sri Lanka**

## Log

Log api provide you the easy way to log your info, debug, warn and error logs. Also capable of log to flutter crashlytics.

### Properties

| Property                           | Type | Default Value | Description                                                                                                                  |
|:-----------------------------------|:-----|:--------------|:-----------------------------------------------------------------------------------------------------------------------------|
| logInDebugMode                     | bool | true          | Enable logging in debug mode (kDebugMode)                                                                                    |
| logInReleaseMode                   | bool | false         | Enable logging in release mode (kReleaseMode)                                                                                |
| enableFirebaseCrashlyticsInDebug   | bool | false         | Enable Firebase Crashlytics logging in debug mode (kDebugMode). If enabled you may initialize Firebase before Log.init()     |
| enableFirebaseCrashlyticsInRelease | bool | false         | Enable Firebase Crashlytics logging in release mode (kReleaseMode). If enabled you may initialize Firebase before Log.init() |

### Initialize
You may initialize in the main function

```

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase app if only using Firebase Crashlytics
  // await Firebase.initializeApp();

  // Initialize Log
  Log.init(
        logInDebugMode: true,
        logInReleaseMode: false,
        enableFirebaseCrashlyticsInDebug: false,
        enableFirebaseCrashlyticsInRelease: false);

  runApp(MyApp());
}

```

### Example Usage

You can use references parameter to mention any extra debug information to easily recognise in log

```

Log.i(TAG, 'initialized', references: ['initState']);
Log.d(TAG, '$_counter', references: ['_incrementCounter', 'begin']);
Log.w(TAG, 'about to hit the level => $_counter', references: ['_incrementCounter']);
Log.e(TAG, '$_counter', references: ['_incrementCounter'], exception: e);

```

