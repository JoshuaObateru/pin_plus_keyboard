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
  String text;

  /// Creates a new [PinInputController].
  ///
  /// [length] is required and specifies how many input fields to display.
  /// [text] is optional and defaults to an empty string.
  PinInputController({required this.length, this.text = ''});

  /// Updates the text value and notifies all listeners.
  ///
  /// This method should be called whenever the PIN input changes (when user
  /// types or deletes). All widgets listening to this controller will be
  /// notified of the change.
  ///
  /// [text] - The new text value to set.
  void changeText(String text) {
    this.text = text;
    notifyListeners();
  }

  /// Clears the current text value.
  ///
  /// This is useful for resetting the PIN input after submission or error.
  void clear() {
    text = '';
    notifyListeners();
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
