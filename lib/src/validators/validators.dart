class Validators {
  /// Validate given value
  ///
  /// * [value] : any value
  static String? validateRequired(value) {
    return value == null || (value is String && value.trim().isEmpty)
        ? 'This filed is required'
        : null;
  }

  /// Validate given email address
  ///
  /// * [value] : email address
  static String? validateEmail(String? value) {
    const pattern =
        r'^(("[\w-\s]+")|([\w-]+(?:\.[\w-]+)*)|("[\w-\s]+")([\w-]+(?:\.[\w-]+)*))(@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][0-9]\.|1[0-9]{2}\.|[0-9]{1,2}\.))((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){2}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\]?$)';
    final RegExp regex = RegExp(pattern);
    if (value != null && value.isNotEmpty && regex.hasMatch(value)) {
      return null;
    } else if (value == null || value.isEmpty) {
      return 'This filed is required';
    } else {
      return 'Please enter valid email';
    }
  }

  /// Validate given mobile number.
  /// By default validate SL mobile number patters.
  /// Provide custom [pattern] to validate any format
  ///
  /// * [value] : mobile number
  /// * [allowLandNumber] : only for SL, accept land phone number validation
  /// * [optional] : sets if field is not required
  /// * [pattern] : for non SL country mobile number validation,
  /// automatically omit spaces
  static String? validateMobileNumber(String? value,
      {bool allowLandNumber = false, bool optional = false, String? pattern}) {
    if (pattern == null) {
      const pattern1 = r'^[0]?7[0-9]{8}$';
      const pattern2 = r'^[0-9]{9}$';
      const pattern3 = r'^[+]947[0-9]{8}$';
      final RegExp regex1 = RegExp(pattern1);
      final RegExp regex2 = RegExp(pattern2);
      final RegExp regex3 = RegExp(pattern3);
      if (allowLandNumber) {
        if ((value != null &&
                value.isNotEmpty &&
                value.length == 9 &&
                regex2.hasMatch(value)) ||
            ((value == null || value.isEmpty) && optional)) {
          return null;
        } else if (value == null || value.isEmpty) {
          return 'This filed is required';
        } else {
          return 'Please enter valid land number';
        }
      } else {
        if ((value == null || value.isEmpty) && optional) {
          return null;
        } else if (value == null || value.isEmpty) {
          return 'This filed is required';
        } else if (value.isNotEmpty &&
            (value.length == 9 ||
                value.length == 10 ||
                value.length == 12 ||
                value.length == 15)) {
          if ((value.length == 12 || value.length == 15) &&
              regex3.hasMatch(value.replaceAll(' ', ''))) {
            return null;
          } else if (regex1.hasMatch(value)) {
            return null;
          }
        }

        return 'Please enter valid mobile number';
      }
    } else {
      final RegExp regex = RegExp(pattern);
      if ((value == null || value.isEmpty) && optional) {
        return null;
      } else if (value == null || value.isEmpty) {
        return 'This filed is required';
      } else if (regex.hasMatch(value)) {
        return null;
      }

      return 'Please enter valid mobile number';
    }
  }

  /// Validate given NIC, this method only for SL
  ///
  /// * [value] : NIC number
  static String? validateNIC(String? value) {
    const pattern1 = r'^[0-9]{9}[vV]$';
    const pattern2 = r'^[0-9]{12}$';
    final RegExp regex1 = RegExp(pattern1);
    final RegExp regex2 = RegExp(pattern2);
    if (value != null &&
        value.isNotEmpty &&
        (regex1.hasMatch(value) || regex2.hasMatch(value))) {
      return null;
    } else if (value == null || value.isEmpty) {
      return 'This filed is required';
    } else {
      return 'Please enter valid NIC number';
    }
  }

  /// Validate [value] (new password) and [password] (current password)
  ///
  /// * [value] : password
  /// * [password] : existing password
  ///
  /// Example:
  /// ```dart
  /// TextFormField(
  ///   controller: newPasswordController,
  ///   focusNode: focusNewPassword,
  ///   keyboardType: TextInputType.visiblePassword,
  ///   obscureText: true,
  ///   maxLines: 1,
  ///   textInputAction: TextInputAction.next,
  ///   validator: (value) =>
  ///       Validators.validateConfirmPassword(
  ///     value,
  ///     currentPassword,
  ///   ),
  ///   decoration: InputDecoration(
  ///     labelText: 'New Password',
  ///   ),
  /// ),
  /// ```
  static String? validateConfirmPassword(String? value, String? password) {
    if (value != null &&
        value.isNotEmpty &&
        (password != null && password.isNotEmpty && value == password)) {
      return null;
    } else if (value == null || value.isEmpty) {
      return 'This filed is required';
    } else {
      return 'Passwords are not matching';
    }
  }

  /// Validate given pin code
  ///
  /// * [value] : pin code
  /// * [length] : pin code length
  /// * [numbersOnly] : allow only numbers as the pin code
  static String? validatePinCode(String? value,
      {int length = 6, bool numbersOnly = true}) {
    if (value != null && value.isNotEmpty && (value.length == length)) {
      if (numbersOnly && !value.contains(RegExp(r'[^0-9]'))) {
        return null;
      } else {
        return 'Only numbers are allowed';
      }
    } else if (value == null || value.isEmpty) {
      return 'This filed is required';
    } else {
      return 'Enter all $length digits';
    }
  }
}
