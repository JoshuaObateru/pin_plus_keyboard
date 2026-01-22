import 'package:flutter_test/flutter_test.dart';
import 'package:pin_plus_keyboard/package/controllers/pin_input_controller.dart';

/// Test suite for [PinInputController]
///
/// These tests verify that the controller properly manages PIN input state,
/// notifies listeners of changes, and provides correct status information.
void main() {
  group('PinInputController', () {
    /// Test that the controller initializes with the correct length
    ///
    /// This ensures that when a controller is created with a specific length,
    /// it correctly stores that length and initializes with empty text.
    test('should initialize with correct length and empty text', () {
      // Arrange & Act
      const length = 6;
      final controller = PinInputController(length: length);

      // Assert
      expect(controller.length, equals(length),
          reason: 'Controller should store the specified length');
      expect(controller.text, isEmpty,
          reason: 'Controller should start with empty text');
      expect(controller.isEmpty, isTrue,
          reason: 'isEmpty should be true when text is empty');
      expect(controller.isComplete, isFalse,
          reason: 'isComplete should be false when text is empty');
    });

    /// Test that the controller initializes with provided text
    ///
    /// This verifies that the optional text parameter works correctly
    /// when initializing the controller with a pre-filled value.
    test('should initialize with provided text', () {
      // Arrange & Act
      const length = 4;
      const initialText = '1234';
      final controller = PinInputController(length: length, text: initialText);

      // Assert
      expect(controller.text, equals(initialText),
          reason: 'Controller should store the provided text');
      expect(controller.isEmpty, isFalse,
          reason: 'isEmpty should be false when text is provided');
      expect(controller.isComplete, isTrue,
          reason: 'isComplete should be true when text length equals length');
    });

    /// Test that changeText updates the text and notifies listeners
    ///
    /// This is a critical test because the controller uses ChangeNotifier,
    /// and widgets depend on being notified when the text changes.
    test('should update text and notify listeners', () {
      // Arrange
      final controller = PinInputController(length: 4);
      var notificationCount = 0;
      controller.addListener(() {
        notificationCount++;
      });

      // Act
      controller.changeText('1234');

      // Assert
      expect(controller.text, equals('1234'),
          reason: 'Text should be updated to the new value');
      expect(notificationCount, equals(1),
          reason: 'Listeners should be notified when text changes');
      expect(controller.isComplete, isTrue,
          reason: 'isComplete should be true when text length equals length');
    });

    /// Test that multiple listeners are notified
    ///
    /// This ensures that the ChangeNotifier pattern works correctly
    /// when multiple widgets are listening to the controller.
    test('should notify all listeners when text changes', () {
      // Arrange
      final controller = PinInputController(length: 4);
      var listener1Called = false;
      var listener2Called = false;

      controller.addListener(() => listener1Called = true);
      controller.addListener(() => listener2Called = true);

      // Act
      controller.changeText('1234');

      // Assert
      expect(listener1Called, isTrue,
          reason: 'First listener should be notified');
      expect(listener2Called, isTrue,
          reason: 'Second listener should be notified');
    });

    /// Test that clear() resets the text to empty
    ///
    /// This is important for resetting the PIN input after submission
    /// or when an error occurs.
    test('should clear text and notify listeners', () {
      // Arrange
      final controller = PinInputController(length: 4);
      controller.changeText('1234');
      var notificationCount = 0;
      controller.addListener(() {
        notificationCount++;
      });

      // Act
      controller.clear();

      // Assert
      expect(controller.text, isEmpty,
          reason: 'Text should be empty after clear()');
      expect(controller.isEmpty, isTrue,
          reason: 'isEmpty should be true after clear()');
      expect(controller.isComplete, isFalse,
          reason: 'isComplete should be false after clear()');
      expect(notificationCount, equals(1),
          reason: 'Listeners should be notified when text is cleared');
    });

    /// Test that clear() doesn't notify if text is already empty
    ///
    /// This is a performance optimization - no need to notify if nothing changed.
    test('should not notify listeners when clearing already empty text', () {
      // Arrange
      final controller = PinInputController(length: 4);
      var notificationCount = 0;
      controller.addListener(() {
        notificationCount++;
      });

      // Act - clear when already empty
      controller.clear();

      // Assert
      expect(controller.text, isEmpty,
          reason: 'Text should still be empty');
      expect(notificationCount, equals(0),
          reason: 'Listeners should not be notified when clearing already empty text');
    });

    /// Test that isComplete returns true only when text length equals length
    ///
    /// This ensures that the completion status is correctly calculated
    /// for various text lengths.
    test('should correctly determine completion status', () {
      // Arrange
      final controller = PinInputController(length: 6);

      // Act & Assert - Empty text
      expect(controller.isComplete, isFalse,
          reason: 'Should not be complete when text is empty');

      // Act & Assert - Partial text
      controller.changeText('123');
      expect(controller.isComplete, isFalse,
          reason: 'Should not be complete when text length is less than required');

      // Act & Assert - Complete text
      controller.changeText('123456');
      expect(controller.isComplete, isTrue,
          reason: 'Should be complete when text length equals required length');

      // Act & Assert - Over-length text (edge case)
      controller.changeText('1234567');
      expect(controller.isComplete, isFalse,
          reason: 'Should not be complete when text length exceeds required length');
    });

    /// Test that isEmpty returns true only when text is empty
    ///
    /// This verifies the isEmpty getter works correctly.
    test('should correctly determine empty status', () {
      // Arrange
      final controller = PinInputController(length: 4);

      // Act & Assert - Empty text
      expect(controller.isEmpty, isTrue,
          reason: 'Should be empty when text is empty');

      // Act & Assert - Non-empty text
      controller.changeText('1');
      expect(controller.isEmpty, isFalse,
          reason: 'Should not be empty when text has content');
    });

    /// Test that listeners can be removed
    ///
    /// This is important for preventing memory leaks when widgets
    /// are disposed.
    test('should allow removing listeners', () {
      // Arrange
      final controller = PinInputController(length: 4);
      var notificationCount = 0;
      void listener() {
        notificationCount++;
      }

      controller.addListener(listener);

      // Act - Remove listener
      controller.removeListener(listener);
      controller.changeText('1234');

      // Assert
      expect(notificationCount, equals(0),
          reason: 'Removed listener should not be notified');
    });

    /// Test edge case: empty string change
    ///
    /// This ensures that setting text to an empty string works correctly.
    test('should handle empty string change', () {
      // Arrange
      final controller = PinInputController(length: 4);
      controller.changeText('1234');
      var notificationCount = 0;
      controller.addListener(() {
        notificationCount++;
      });

      // Act
      controller.changeText('');

      // Assert
      expect(controller.text, isEmpty,
          reason: 'Text should be empty after setting to empty string');
      expect(controller.isEmpty, isTrue,
          reason: 'isEmpty should be true after setting to empty string');
      expect(notificationCount, equals(1),
          reason: 'Listeners should be notified');
    });

    /// Test edge case: very long text
    ///
    /// This ensures the controller handles text longer than the required length.
    test('should handle text longer than required length', () {
      // Arrange
      final controller = PinInputController(length: 4);

      // Act
      controller.changeText('1234567890');

      // Assert
      expect(controller.text, equals('1234567890'),
          reason: 'Controller should store text even if longer than length');
      expect(controller.isComplete, isFalse,
          reason: 'isComplete should be false for over-length text');
      expect(controller.isEmpty, isFalse,
          reason: 'isEmpty should be false for non-empty text');
    });
  });
}

