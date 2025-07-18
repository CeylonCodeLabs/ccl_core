import 'package:ccl_core/ccl_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NullStringExtension Tests', () {
    //-------------------------------------
    // Tests for isNotNullAndNotEmpty
    //-------------------------------------
    group('isNotNullAndNotEmpty', () {
      test('should return true for a non-null, non-empty string', () {
        const String? testString = 'hello';
        expect(testString.isNotNullAndNotEmpty, isTrue);
      });

      test('should return true for a string with whitespace if not trimmed', () {
        const String? testString = '  world  ';
        expect(testString.isNotNullAndNotEmpty, isTrue);
      });

      test('should return false for an empty string', () {
        const String? testString = '';
        expect(testString.isNotNullAndNotEmpty, isFalse);
      });

      test('should return false for a null string', () {
        const String? testString = null;
        expect(testString.isNotNullAndNotEmpty, isFalse);
      });

      // Example of using the promoted value (though the test is simple)
      test('allows safe access after true check with bang operator', () {
        const String? testString = "dart";
        if (testString.isNotNullAndNotEmpty) {
          // In a real scenario, you'd use testString! here
          expect(testString.length, 4); // Use '!' to satisfy the linter
        } else {
          fail('isNotNullAndNotEmpty should have been true');
        }
      });
    });

    //-------------------------------------
    // Tests for isNullOrEmpty
    //-------------------------------------
    group('isNullOrEmpty', () {
      test('should return false for a non-null, non-empty string', () {
        const String? testString = 'hello';
        expect(testString.isNullOrEmpty, isFalse);
      });

      test('should return false for a string with whitespace if not trimmed', () {
        // Your current implementation of isNullOrEmpty considers "  " as not empty.
        // If you wanted it to be empty after trimming, the logic would need to change.
        const String? testString = '  world  ';
        expect(testString.isNullOrEmpty, isFalse);
      });

      test('should return true for an empty string', () {
        const String? testString = '';
        expect(testString.isNullOrEmpty, isTrue);
      });

      test('should return true for a null string', () {
        const String? testString = null;
        expect(testString.isNullOrEmpty, isTrue);
      });

      // Example showing that after a false check, it's considered non-null and non-empty
      test('implies non-null and non-empty after false check', () {
        const String? testString = "flutter";
        if (!testString.isNullOrEmpty) {
          // If it's NOT null or empty, then it must be non-null.
          expect(testString.isNotEmpty, isTrue); // Use '!'
        } else {
          fail('isNullOrEmpty should have been false');
        }
      });
    });

    //----------------------------------------------------------------------
    // Test a few more scenarios combining the two for logical consistency
    //----------------------------------------------------------------------
    group('Combined Logic', () {
      test('isNotNullAndNotEmpty should be the opposite of isNullOrEmpty for non-null strings', () {
        const String? nonEmptyString = "text";
        const String? emptyString = "";

        expect(nonEmptyString.isNotNullAndNotEmpty, !nonEmptyString.isNullOrEmpty);
        expect(emptyString.isNotNullAndNotEmpty, !emptyString.isNullOrEmpty);
      });

      test('for null string, isNotNullAndNotEmpty is false and isNullOrEmpty is true', () {
        const String? nullString = null;
        expect(nullString.isNotNullAndNotEmpty, isFalse);
        expect(nullString.isNullOrEmpty, isTrue);
      });
    });
  });
}