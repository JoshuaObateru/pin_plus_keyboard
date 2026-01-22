import 'package:flutter/widgets.dart';

/// A controller class that manages the state of PIN input fields.
///
/// This controller extends [ChangeNotifier] to allow widgets to listen to
/// changes in the PIN input text. It's used to control the number of input
/// fields and track the current text value.
///
/// Example usage:
/// ```dart
/// final controller = PinInputController(length: 6);
/// // Listen to changes
/// controller.addListener(() {
///   print('Current PIN: ${controller.text}');
/// });
/// ```
class PinInputController extends ChangeNotifier {
  /// The number of PIN input fields to display.
  ///
  /// This determines how many input boxes will be shown in the UI.
  final int length;

  /// The current text value entered in the PIN fields.
  ///
  /// This value is updated as the user types or deletes characters.
  /// 
  /// **Note:** Do not assign to this field directly. Use [changeText] or [clear]
  /// methods instead to ensure listeners are notified of changes.
  String _text;

  /// Gets the current text value.
  ///
  /// Use [changeText] or [clear] to modify the text value.
  String get text => _text;

  /// Creates a new [PinInputController].
  ///
  /// [length] is required and specifies how many input fields to display.
  /// [text] is optional and defaults to an empty string.
  PinInputController({required this.length, String text = ''}) : _text = text;

  /// Updates the text value and notifies all listeners.
  ///
  /// This method should be called whenever the PIN input changes (when user
  /// types or deletes). All widgets listening to this controller will be
  /// notified of the change.
  ///
  /// [text] - The new text value to set.
  void changeText(String text) {
    if (_text != text) {
      _text = text;
      notifyListeners();
    }
  }

  /// Clears the current text value.
  ///
  /// This is useful for resetting the PIN input after submission or error.
  /// All listeners will be notified of the change.
  ///
  /// Example:
  /// ```dart
  /// // After validation error
  /// pinInputController.clear();
  /// ```
  void clear() {
    if (_text.isNotEmpty) {
      _text = '';
      notifyListeners();
    }
  }

  /// Checks if the PIN input is complete (all fields filled).
  ///
  /// Returns `true` if the text length equals the required length.
  bool get isComplete => text.length == length;

  /// Checks if the PIN input is empty.
  ///
  /// Returns `true` if no text has been entered.
  bool get isEmpty => text.isEmpty;
}
