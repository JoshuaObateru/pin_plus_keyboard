import 'package:flutter/material.dart';
import '../pin_plus_keyboard_package.dart';

/// Predefined theme presets for PIN input widgets.
///
/// These presets provide ready-to-use configurations that match
/// common design patterns (iOS-style, Android-style, Material 3).
///
/// Example usage:
/// ```dart
/// PinPlusKeyBoardPackage(
///   pinInputController: controller,
///   spacing: 40,
///   onSubmit: () {},
///   ...PinThemePresets.iosStyle(),
/// )
/// ```
class PinThemePresets {
  /// iOS-style theme preset.
  ///
  /// Features:
  /// - Circular input fields
  /// - Circular keyboard buttons
  /// - Clean, minimal design
  /// - Subtle shadows
  static Map<String, dynamic> iosStyle() {
    return {
      'inputShape': InputShape.circular,
      'keyboardButtonShape': KeyboardButtonShape.circular,
      'inputFillColor': Colors.white,
      'inputBorderColor': Colors.grey.shade300,
      'inputBorderThickness': 1.0,
      'inputElevation': 2.0,
      'buttonFillColor': Colors.white,
      'buttonBorderColor': Colors.grey.shade300,
      'btnBorderThickness': 1.0,
      'btnElevation': 1.0,
      'btnTextColor': Colors.black,
      'inputTextColor': Colors.black,
      'keyboardMaxWidth': 75.0,
      'inputsMaxWidth': 60.0,
    };
  }

  /// Android Material Design theme preset.
  ///
  /// Features:
  /// - Rounded input fields
  /// - Rounded keyboard buttons
  /// - Material Design colors
  /// - Elevated surfaces
  static Map<String, dynamic> androidStyle() {
    return {
      'inputShape': InputShape.rounded,
      'keyboardButtonShape': KeyboardButtonShape.rounded,
      'inputFillColor': Colors.grey.shade100,
      'inputBorderColor': Colors.blue,
      'inputBorderThickness': 2.0,
      'inputElevation': 4.0,
      'buttonFillColor': Colors.blue,
      'buttonBorderColor': Colors.blue.shade700,
      'btnBorderThickness': 0.0,
      'btnHasBorder': false,
      'btnElevation': 2.0,
      'btnTextColor': Colors.white,
      'inputTextColor': Colors.black87,
      'keyboardMaxWidth': 85.0,
      'inputsMaxWidth': 70.0,
    };
  }

  /// Material 3 theme preset.
  ///
  /// Features:
  /// - Material 3 design tokens
  /// - Dynamic color support
  /// - Modern rounded corners
  /// - Adaptive theming
  static Map<String, dynamic> material3Style({
    ColorScheme? colorScheme,
  }) {
    final scheme = colorScheme ?? ColorScheme.fromSeed(seedColor: Colors.blue);
    
    return {
      'inputShape': InputShape.rounded,
      'keyboardButtonShape': KeyboardButtonShape.rounded,
      'inputFillColor': scheme.surface,
      'inputBorderColor': scheme.primary,
      'inputBorderThickness': 2.0,
      'inputElevation': 1.0,
      'buttonFillColor': scheme.primaryContainer,
      'buttonBorderColor': scheme.primary,
      'btnBorderThickness': 1.0,
      'btnElevation': 0.0,
      'btnTextColor': scheme.onPrimaryContainer,
      'inputTextColor': scheme.onSurface,
      'keyboardMaxWidth': 80.0,
      'inputsMaxWidth': 70.0,
      'focusColor': scheme.primary,
      'errorColor': scheme.error,
    };
  }

  /// Minimal theme preset.
  ///
  /// Features:
  /// - Dash-style input fields (underlines)
  /// - Simple, clean design
  /// - No borders on buttons
  /// - Minimal shadows
  static Map<String, dynamic> minimalStyle() {
    return {
      'inputType': InputType.dash,
      'inputShape': InputShape.defaultShape,
      'keyboardButtonShape': KeyboardButtonShape.defaultShape,
      'inputFillColor': Colors.transparent,
      'inputBorderColor': Colors.grey,
      'inputBorderThickness': 2.0,
      'inputElevation': 0.0,
      'buttonFillColor': Colors.transparent,
      'buttonBorderColor': Colors.grey.shade300,
      'btnBorderThickness': 1.0,
      'btnElevation': 0.0,
      'btnTextColor': Colors.black87,
      'inputTextColor': Colors.black87,
      'keyboardMaxWidth': 80.0,
      'inputsMaxWidth': 70.0,
    };
  }

  /// Dark theme preset.
  ///
  /// Features:
  /// - Dark color scheme
  /// - High contrast for visibility
  /// - Suitable for dark mode
  static Map<String, dynamic> darkStyle() {
    return {
      'inputShape': InputShape.rounded,
      'keyboardButtonShape': KeyboardButtonShape.rounded,
      'inputFillColor': Colors.grey.shade800,
      'inputBorderColor': Colors.grey.shade600,
      'inputBorderThickness': 2.0,
      'inputElevation': 2.0,
      'buttonFillColor': Colors.grey.shade800,
      'buttonBorderColor': Colors.grey.shade600,
      'btnBorderThickness': 1.0,
      'btnElevation': 2.0,
      'btnTextColor': Colors.white,
      'inputTextColor': Colors.white,
      'keyboardMaxWidth': 80.0,
      'inputsMaxWidth': 70.0,
      'errorColor': Colors.red.shade300,
    };
  }
}

