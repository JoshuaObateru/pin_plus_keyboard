import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_plus_keyboard/package/controllers/pin_input_controller.dart';
import 'package:pin_plus_keyboard/package/services/biometric_service.dart';
import 'package:pin_plus_keyboard/package/services/security_service.dart';

/// Enum defining the shape options for keyboard buttons.
///
/// - [circular]: Fully circular buttons
/// - [rounded]: Buttons with rounded corners
/// - [defaultShape]: Default rectangular buttons
enum KeyboardButtonShape {
  /// Fully circular buttons
  circular,
  /// Buttons with rounded corners
  rounded,
  /// Default rectangular buttons
  defaultShape,
}

/// Enum defining the shape options for input fields.
///
/// - [circular]: Fully circular input fields
/// - [rounded]: Input fields with rounded corners
/// - [defaultShape]: Default rectangular input fields
enum InputShape {
  /// Fully circular input fields
  circular,
  /// Input fields with rounded corners
  rounded,
  /// Default rectangular input fields
  defaultShape,
}

/// Enum defining the visual style of input fields.
///
/// - [dash]: Underline style (dash at the bottom)
/// - [box]: Box style (full border around the input)
enum InputType {
  /// Underline style - shows a dash at the bottom
  dash,
  /// Box style - shows a full border around the input
  box,
}

/// A customizable PIN input widget with a custom numeric keyboard.
///
/// This widget provides a complete PIN entry solution with:
/// - Customizable input fields (shape, color, size, etc.)
/// - Custom numeric keyboard (0-9)
/// - Support for hidden input (password-style)
/// - Automatic submission when all fields are filled
/// - Error handling and validation
/// - Accessibility support (screen readers, keyboard navigation)
/// - Animations and micro-interactions
/// - Material 3 design support
/// - Platform-specific optimizations
/// - Biometric authentication support
/// - Security features (auto-clear, rate limiting)
///
/// Example usage:
/// ```dart
/// PinPlusKeyBoardPackage(
///   pinInputController: PinInputController(length: 6),
///   spacing: 40,
///   onSubmit: () {
///     print('PIN entered: ${controller.text}');
///   },
/// )
/// ```
class PinPlusKeyBoardPackage extends StatefulWidget {
  /// Shape of the keyboard buttons
  final KeyboardButtonShape keyboardButtonShape;

  /// Shape of the input fields
  final InputShape inputShape;

  /// Maximum width of the keyboard as a percentage of screen width (0-100)
  /// Default: 80
  final double keyboardMaxWidth;

  /// Vertical spacing between keyboard button rows
  final double keyboardVerticalSpacing;

  /// Spacing between the input fields and the keyboard
  /// This is required to ensure proper layout
  final double spacing;

  /// Fill color for keyboard buttons
  final Color? buttonFillColor;

  /// Border color for keyboard buttons
  final Color? buttonBorderColor;

  /// Text color for keyboard button numbers
  final Color? btnTextColor;

  /// Whether keyboard buttons should have borders
  final bool btnHasBorder;

  /// Thickness of keyboard button borders
  final double? btnBorderThickness;

  /// Elevation/shadow depth for keyboard buttons
  final double? btnElevation;

  /// Shadow color for keyboard buttons
  final Color? btnShadowColor;

  /// Width of individual input fields
  final double? inputWidth;

  /// Whether input should be hidden (password-style)
  final bool isInputHidden;

  /// Color used to hide the input when [isInputHidden] is true
  final Color inputHiddenColor;

  /// Maximum width of the input container as a percentage of screen width (0-100)
  /// Default: 70
  final double inputsMaxWidth;

  /// Controller that manages the PIN input state
  /// This is required and must be initialized with the desired PIN length
  final PinInputController pinInputController;

  /// Callback function called when PIN is submitted
  /// This is called automatically when all fields are filled, or when the done button is pressed
  final VoidCallback onSubmit;

  /// Fill color for empty input fields
  final Color? inputFillColor;

  /// Border color for input fields
  final Color? inputBorderColor;

  /// Text color for input field numbers
  final Color? inputTextColor;

  /// Whether input fields should have borders
  final bool inputHasBorder;

  /// Thickness of input field borders
  final double? inputBorderThickness;

  /// Elevation/shadow depth for input fields
  final double? inputElevation;

  /// Shadow color for input fields
  final Color? inputShadowColor;

  /// Color for error messages
  final Color errorColor;

  /// Font size for keyboard button text
  final double? keyboardFontSize;

  /// Custom border radius for input fields
  final BorderRadius? inputBorderRadius;

  /// Height of individual input fields
  final double? inputHeight;

  /// Color for the cancel/backspace button
  final Color? cancelColor;

  /// Extra input character to display on the keyboard (e.g., "*" or "#")
  final String? extraInput;

  /// Custom icon for the backspace button
  final Icon? backButton;

  /// Custom icon for the done/submit button
  final Icon? doneButton;

  /// Visual style of input fields (dash or box)
  final InputType inputType;

  /// Custom border radius for keyboard buttons
  final BorderRadius? keyoardBtnBorderRadius;

  /// Custom text style for input field text
  final TextStyle? inputTextStyle;

  /// Custom widget to display on the left side of the bottom keyboard row
  final Widget? leftExtraInputWidget;

  /// Custom size for keyboard buttons
  final double? keyboardBtnSize;

  /// Color for focused/active input fields
  final Color? focusColor;

  /// Font family for keyboard button text
  /// If null, uses the theme's default font family
  final String? keyboardFontFamily;

  /// Whether to enable haptic feedback when buttons are pressed
  /// Haptic feedback provides tactile response on supported devices
  /// Default: false
  final bool enableHapticFeedback;

  /// Optional validation function that returns an error message if PIN is invalid
  /// If this returns a non-empty string, it will be displayed as an error
  /// This allows for custom validation logic (e.g., PIN must not be all same digits)
  final String Function(String pin)? validator;

  /// Optional callback called when each digit is entered
  /// This can be used for analytics, logging, or custom behavior
  final void Function(String digit, int position)? onDigitEntered;

  // NEW FEATURES - Accessibility
  /// Semantic label for the PIN input widget
  /// Used by screen readers to describe the widget
  final String? semanticLabel;

  /// Whether to enable keyboard navigation
  /// When enabled, users can navigate using keyboard arrows
  final bool enableKeyboardNavigation;

  // NEW FEATURES - Animations
  /// Whether to enable input fill animations
  /// When enabled, input fields animate when filled
  final bool enableAnimations;

  /// Animation curve for input fill animations
  /// Default: Curves.easeInOut
  final Curve animationCurve;

  /// Duration for input fill animations
  /// Default: Duration(milliseconds: 200)
  final Duration animationDuration;

  /// Whether to show shake animation on validation errors
  final bool enableShakeAnimation;

  /// Whether to show success animation on completion
  final bool enableSuccessAnimation;

  /// Whether to show loading state during submission
  final bool showLoadingState;

  // NEW FEATURES - Material 3
  /// Whether to use Material 3 design tokens
  /// When enabled, colors are derived from the theme's ColorScheme
  final bool useMaterial3;

  /// Custom ColorScheme to use (overrides theme)
  final ColorScheme? colorScheme;

  // NEW FEATURES - Platform-specific
  /// Whether to use platform-specific styling
  /// When enabled, iOS and Android will have platform-appropriate styles
  final bool usePlatformSpecificStyling;

  // NEW FEATURES - Biometric
  /// Whether to show biometric authentication button
  final bool enableBiometric;

  /// Biometric service instance (optional, will create default if not provided)
  final BiometricService? biometricService;

  /// Callback when biometric authentication succeeds
  final VoidCallback? onBiometricSuccess;

  /// Callback when biometric authentication fails
  final VoidCallback? onBiometricFailure;

  /// Biometric authentication reason shown to user
  final String? biometricReason;

  // NEW FEATURES - Security
  /// Security service instance (optional, will create default if not provided)
  final SecurityService? securityService;

  /// Auto-clear timeout duration
  /// PIN will be cleared after this duration of inactivity
  /// If null, auto-clear is disabled
  final Duration? autoClearTimeout;

  /// Whether to enable screenshot blocking (Android only)
  final bool enableScreenshotBlocking;

  /// Maximum failed attempts before rate limiting
  /// Default: 5
  final int maxFailedAttempts;

  /// Rate limiting time window
  /// Default: Duration(minutes: 15)
  final Duration rateLimitWindow;

  // NEW FEATURES - Advanced Customization
  /// Gradient for keyboard buttons
  /// If provided, overrides buttonFillColor
  final Gradient? buttonGradient;

  /// Gradient for input fields
  /// If provided, overrides inputFillColor
  final Gradient? inputGradient;

  /// Custom builder for input fields
  /// If provided, allows complete customization of input field appearance
  final Widget Function(BuildContext context, int position, bool hasCharacter, String? character)? inputFieldBuilder;

  /// Custom builder for keyboard buttons
  /// If provided, allows complete customization of button appearance
  final Widget Function(BuildContext context, String number)? keyboardButtonBuilder;

  /// Creates a [PinPlusKeyBoardPackage] widget.
  ///
  /// [pinInputController] and [onSubmit] are required.
  /// [spacing] is also required to ensure proper layout.
  ///
  /// All other parameters are optional and have sensible defaults.
  const PinPlusKeyBoardPackage({
    super.key,
    this.keyboardButtonShape = KeyboardButtonShape.defaultShape,
    this.inputShape = InputShape.defaultShape,
    this.keyboardMaxWidth = 80,
    this.keyboardVerticalSpacing = 8,
    required this.spacing,
    this.buttonFillColor,
    this.buttonBorderColor,
    this.btnTextColor,
    this.btnHasBorder = true,
    this.btnBorderThickness,
    this.btnElevation,
    this.btnShadowColor,
    this.inputWidth,
    this.isInputHidden = false,
    this.inputHiddenColor = Colors.black,
    this.inputsMaxWidth = 70,
    required this.pinInputController,
    required this.onSubmit,
    this.inputFillColor,
    this.inputBorderColor,
    this.inputTextColor,
    this.inputHasBorder = true,
    this.inputBorderThickness,
    this.inputElevation,
    this.inputShadowColor,
    this.errorColor = Colors.red,
    this.keyboardFontSize,
    this.inputBorderRadius,
    this.inputHeight,
    this.cancelColor,
    this.extraInput,
    this.backButton,
    this.doneButton,
    this.inputType = InputType.box,
    this.keyoardBtnBorderRadius,
    this.inputTextStyle,
    this.leftExtraInputWidget,
    this.keyboardBtnSize,
    this.focusColor,
    this.keyboardFontFamily,
    this.enableHapticFeedback = false,
    this.validator,
    this.onDigitEntered,
    // New features with defaults
    this.semanticLabel,
    this.enableKeyboardNavigation = true,
    this.enableAnimations = true,
    this.animationCurve = Curves.easeInOut,
    this.animationDuration = const Duration(milliseconds: 200),
    this.enableShakeAnimation = true,
    this.enableSuccessAnimation = true,
    this.showLoadingState = false,
    this.useMaterial3 = true,
    this.colorScheme,
    this.usePlatformSpecificStyling = true,
    this.enableBiometric = false,
    this.biometricService,
    this.onBiometricSuccess,
    this.onBiometricFailure,
    this.biometricReason,
    this.securityService,
    this.autoClearTimeout,
    this.enableScreenshotBlocking = false,
    this.maxFailedAttempts = 5,
    this.rateLimitWindow = const Duration(minutes: 15),
    this.buttonGradient,
    this.inputGradient,
    this.inputFieldBuilder,
    this.keyboardButtonBuilder,
  });

  @override
  State<PinPlusKeyBoardPackage> createState() => _PinPlusKeyBoardPackageState();
}

/// Internal state class for [PinPlusKeyBoardPackage].
///
/// Manages the current PIN input value, error messages, animations, and security.
class _PinPlusKeyBoardPackageState extends State<PinPlusKeyBoardPackage>
    with TickerProviderStateMixin {
  /// List of input field indices (0 to length-1)
  /// This is dynamically updated when the controller's length changes
  List<int> inputNumbers = [];

  /// Current PIN input value as a string
  String _currentPin = '';

  /// Error message to display (empty string means no error)
  String _errorText = '';

  /// Whether PIN submission is in progress
  bool _isSubmitting = false;

  /// Whether biometric authentication is available
  bool _biometricAvailable = false;

  /// Security service instance
  late SecurityService _securityService;

  /// Biometric service instance
  late BiometricService _biometricService;

  // Animation controllers
  late AnimationController _shakeController;
  late AnimationController _successController;
  late List<AnimationController> _fillControllers;
  late List<Animation<double>> _fillAnimations;

  // Focus management for accessibility
  final List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();
    _updateInputNumbers();

    // Initialize services
    _securityService = widget.securityService ?? SecurityService();
    _biometricService = widget.biometricService ?? BiometricService();

    // Initialize animations
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Initialize fill animations for each input field
    _fillControllers = List.generate(
      widget.pinInputController.length,
      (index) => AnimationController(
        vsync: this,
        duration: widget.animationDuration,
      ),
    );
    _fillAnimations = _fillControllers
        .map((controller) => Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(
          parent: controller,
          curve: widget.animationCurve,
        )))
        .toList();

    // Initialize focus nodes for accessibility
    _focusNodes.addAll(
      List.generate(
        widget.pinInputController.length,
        (index) => FocusNode(),
      ),
    );

    // Check biometric availability
    if (widget.enableBiometric) {
      _checkBiometricAvailability();
    }

    // Setup auto-clear timer if enabled
    if (widget.autoClearTimeout != null) {
      _securityService.startAutoClearTimer(
        timeout: widget.autoClearTimeout!,
        onTimeout: () {
          if (mounted) {
            setState(() {
              _currentPin = '';
              widget.pinInputController.clear();
            });
          }
        },
      );
    }

    // Enable screenshot blocking if requested
    if (widget.enableScreenshotBlocking) {
      _securityService.enableScreenshotBlocking();
    }

    // Listen to controller changes
    widget.pinInputController.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.pinInputController.removeListener(_onControllerChanged);
    _shakeController.dispose();
    _successController.dispose();
    for (final controller in _fillControllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    _securityService.dispose();
    super.dispose();
  }

  /// Checks if biometric authentication is available
  Future<void> _checkBiometricAvailability() async {
    final available = await _biometricService.isAvailable();
    if (mounted) {
      setState(() {
        _biometricAvailable = available;
      });
    }
  }

  /// Updates the input numbers list when controller length changes
  void _updateInputNumbers() {
    inputNumbers = List.generate(
      widget.pinInputController.length,
      (index) => index,
    );
  }

  /// Callback when the controller notifies of changes
  void _onControllerChanged() {
    _updateInputNumbers();
    final String newPin = widget.pinInputController.text;
    final bool wasCleared = _currentPin.isNotEmpty && newPin.isEmpty;
    
    _currentPin = newPin;
    
    // If PIN was cleared, reset all fill animations
    if (wasCleared && widget.enableAnimations) {
      for (final controller in _fillControllers) {
        controller.reset();
      }
    }
    
    // Reset security timer on user interaction
    if (widget.autoClearTimeout != null) {
      _securityService.resetAutoClearTimer();
      _securityService.startAutoClearTimer(
        timeout: widget.autoClearTimeout!,
        onTimeout: () {
          if (mounted) {
            setState(() {
              _currentPin = '';
              widget.pinInputController.clear();
            });
          }
        },
      );
    }

    if (mounted) {
      setState(() {});
    }
  }

  /// Gets theme-aware colors using Material 3 design tokens
  Color _getThemeColor(Color? customColor, ColorScheme scheme, ColorType type) {
    if (customColor != null) return customColor;
    if (!widget.useMaterial3) return _getDefaultColor(type);

    switch (type) {
      case ColorType.buttonFill:
        return scheme.primaryContainer;
      case ColorType.buttonBorder:
        return scheme.primary;
      case ColorType.buttonText:
        return scheme.onPrimaryContainer;
      case ColorType.inputFill:
        return scheme.surface;
      case ColorType.inputBorder:
        return scheme.primary;
      case ColorType.inputText:
        return scheme.onSurface;
      case ColorType.error:
        return scheme.error;
      case ColorType.focus:
        return scheme.primary;
    }
  }

  Color _getDefaultColor(ColorType type) {
    switch (type) {
      case ColorType.buttonFill:
        return Colors.transparent;
      case ColorType.buttonBorder:
        return Colors.black;
      case ColorType.buttonText:
        return Colors.black;
      case ColorType.inputFill:
        return Colors.transparent;
      case ColorType.inputBorder:
        return Colors.black;
      case ColorType.inputText:
        return Colors.black;
      case ColorType.error:
        return Colors.red;
      case ColorType.focus:
        return Colors.blue;
    }
  }

  /// Gets platform-appropriate haptic feedback
  void _performHapticFeedback(HapticType type) {
    if (!widget.enableHapticFeedback) return;

    if (kIsWeb) return;

    switch (type) {
      case HapticType.light:
        if (Platform.isIOS) {
          HapticFeedback.selectionClick();
        } else {
          HapticFeedback.lightImpact();
        }
        break;
      case HapticType.medium:
        if (Platform.isIOS) {
          HapticFeedback.mediumImpact();
        } else {
          HapticFeedback.mediumImpact();
        }
        break;
      case HapticType.heavy:
        if (Platform.isIOS) {
          HapticFeedback.heavyImpact();
        } else {
          HapticFeedback.heavyImpact();
        }
        break;
      case HapticType.success:
        HapticFeedback.mediumImpact();
        break;
      case HapticType.error:
        HapticFeedback.heavyImpact();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = widget.colorScheme ?? theme.colorScheme;

    return Semantics(
      label: widget.semanticLabel ?? 'PIN input',
      hint: 'Enter your ${widget.pinInputController.length}-digit PIN',
      child: Column(
        children: [
          // Input fields container with shake animation
          AnimatedBuilder(
            animation: _shakeController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_shakeController.value * 10, 0),
                child: child!,
              );
            },
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width * (widget.inputsMaxWidth / 100),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: inputNumbers
                    .map((index) => _buildInputWidget(index, scheme))
                    .toList(),
              ),
            ),
          ),
          // Error message display
          if (_errorText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Semantics(
                label: 'Error: $_errorText',
                liveRegion: true,
                child: Text(
                  _errorText,
                  style: TextStyle(
                    color: _getThemeColor(
                      widget.errorColor,
                      scheme,
                      ColorType.error,
                    ),
                  ),
                ),
              ),
            ),
          // Loading indicator
          if (_isSubmitting && widget.showLoadingState)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          // Success animation
          if (widget.enableSuccessAnimation && _successController.value > 0)
            AnimatedBuilder(
              animation: _successController,
              builder: (context, child) {
                return Opacity(
                  opacity: _successController.value,
                  child: Transform.scale(
                    scale: _successController.value,
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 24 * (1 - _successController.value * 0.3),
                    ),
                  ),
                );
              },
            ),
          // Spacing between inputs and keyboard
          SizedBox(height: widget.spacing),
          // Custom numeric keyboard
          _buildCustomKeyboard(size: size, scheme: scheme),
        ],
      ),
    );
  }

  /// Builds a single keyboard button widget with accessibility and animations.
  Widget _buildKeyboardButton(String number, {required ColorScheme scheme}) {
    // Use custom builder if provided
    if (widget.keyboardButtonBuilder != null) {
      return widget.keyboardButtonBuilder!(context, number);
    }

    final double screenWidth = MediaQuery.of(context).size.width;
    final double buttonSize = widget.keyboardBtnSize ??
        (widget.keyboardButtonShape == KeyboardButtonShape.circular
            ? screenWidth * 0.13
            : screenWidth * 0.1);

    final buttonFill = _getThemeColor(
      widget.buttonFillColor,
      scheme,
      ColorType.buttonFill,
    );
    final buttonBorder = _getThemeColor(
      widget.buttonBorderColor,
      scheme,
      ColorType.buttonBorder,
    );
    final buttonText = _getThemeColor(
      widget.btnTextColor,
      scheme,
      ColorType.buttonText,
    );

    return Expanded(
      child: RepaintBoundary(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: widget.keyboardVerticalSpacing,
            horizontal: screenWidth * 0.01,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _onButtonClicked(number),
              borderRadius: widget.keyoardBtnBorderRadius ??
                  (widget.keyboardButtonShape == KeyboardButtonShape.rounded
                      ? BorderRadius.circular(screenWidth)
                      : null),
              child: Semantics(
                label: 'Number $number',
                button: true,
                child: Container(
                  alignment: Alignment.center,
                  width: buttonSize,
                  height: buttonSize,
                  decoration: BoxDecoration(
                    gradient: widget.buttonGradient,
                    color: widget.buttonGradient == null ? buttonFill : null,
                    border: widget.btnHasBorder
                        ? Border.all(
                            color: buttonBorder,
                            width: widget.btnBorderThickness ?? 1,
                          )
                        : null,
                    borderRadius: widget.keyoardBtnBorderRadius ??
                        (widget.keyboardButtonShape ==
                                KeyboardButtonShape.rounded
                            ? BorderRadius.circular(screenWidth)
                            : null),
                    boxShadow: widget.btnElevation != null
                        ? [
                            BoxShadow(
                              color: widget.btnShadowColor?.withOpacity(0.6) ??
                                  buttonFill.withOpacity(0.6),
                              spreadRadius: 3,
                              blurRadius: 9,
                              offset: Offset(0, widget.btnElevation ?? 0),
                            ),
                          ]
                        : null,
                    shape: widget.keyboardButtonShape ==
                            KeyboardButtonShape.circular
                        ? BoxShape.circle
                        : BoxShape.rectangle,
                  ),
                  child: Text(
                    number,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: widget.keyboardFontFamily ??
                          Theme.of(context).textTheme.titleMedium?.fontFamily,
                      color: buttonText,
                      fontSize: widget.keyboardFontSize ?? screenWidth * 0.05,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Handles button click events from the keyboard.
  void _onButtonClicked(String btnText) {
    _performHapticFeedback(HapticType.light);

    if (_currentPin.length < widget.pinInputController.length) {
      final int newPosition = _currentPin.length;
      setState(() {
        _currentPin += btnText;
        widget.pinInputController.changeText(_currentPin);
        _errorText = '';

        // Animate fill if enabled
        if (widget.enableAnimations && newPosition < _fillControllers.length) {
          _fillControllers[newPosition].forward();
        }
      });

      widget.onDigitEntered?.call(btnText, newPosition);

      // Announce to screen readers using Semantics
      if (mounted) {
        // The Semantics widget with liveRegion will handle announcements
      }
    }

    if (_currentPin.length >= widget.pinInputController.length) {
      _handleSubmission();
    }
  }

  /// Handles PIN submission with validation and animations
  Future<void> _handleSubmission() async {
    // Check rate limiting
    if (_securityService.shouldRateLimit(
      maxAttempts: widget.maxFailedAttempts,
      timeWindow: widget.rateLimitWindow,
    )) {
      final timeRemaining = _securityService.getTimeUntilRateLimitLifted(
        maxAttempts: widget.maxFailedAttempts,
        timeWindow: widget.rateLimitWindow,
      );
      setState(() {
        _errorText = 'Too many failed attempts. Please wait ${timeRemaining?.inMinutes ?? 0} minutes.';
      });
      _performHapticFeedback(HapticType.error);
      if (widget.enableShakeAnimation) {
        _shakeController.forward(from: 0.0).then((_) {
          _shakeController.reverse();
        });
      }
      return;
    }

    // Validate the PIN
    if (widget.validator != null) {
      final String? validationError = widget.validator!(_currentPin);
      if (validationError != null && validationError.isNotEmpty) {
        setState(() {
          _errorText = validationError;
        });
        _securityService.recordFailedAttempt();
        _performHapticFeedback(HapticType.error);
        if (widget.enableShakeAnimation) {
          _shakeController.forward(from: 0.0).then((_) {
            _shakeController.reverse();
          });
        }
        return;
      }
    }

    // Show loading state
    if (widget.showLoadingState) {
      setState(() {
        _isSubmitting = true;
      });
    }

    // All validations passed
    _securityService.recordSuccessfulAttempt();
    _performHapticFeedback(HapticType.success);

    if (widget.enableSuccessAnimation) {
      _successController.forward(from: 0.0).then((_) {
        _successController.reverse();
      });
    }

    // Submit
    widget.onSubmit();

    if (widget.showLoadingState) {
      setState(() {
        _isSubmitting = false;
      });
    }

    setState(() {
      _errorText = '';
    });
  }

  /// Builds a single input field widget with animations and accessibility.
  Widget _buildInputWidget(int position, ColorScheme scheme) {
    // Use custom builder if provided
    if (widget.inputFieldBuilder != null) {
      final hasCharacter = position < _currentPin.length;
      final character = hasCharacter ? _currentPin[position] : null;
      return widget.inputFieldBuilder!(
        context,
        position,
        hasCharacter,
        character,
      );
    }

    final double screenWidth = MediaQuery.of(context).size.width;
    final double inputSize = widget.inputWidth ?? screenWidth * 0.1;
    final double inputHeight = widget.inputHeight ?? inputSize;

    final bool hasCharacter = position < _currentPin.length;
    final String? character = hasCharacter ? _currentPin[position] : null;

    final inputFill = _getThemeColor(
      widget.inputFillColor,
      scheme,
      ColorType.inputFill,
    );
    final inputText = _getThemeColor(
      widget.inputTextColor,
      scheme,
      ColorType.inputText,
    );

    final Color backgroundColor = widget.isInputHidden && hasCharacter
        ? widget.inputHiddenColor
        : inputFill;

    // Build the character widget with animation if enabled
    Widget? characterWidget;
    if (character != null) {
      final textWidget = Text(
        character,
        style: widget.inputTextStyle ??
            TextStyle(
              color: widget.isInputHidden
                  ? widget.inputHiddenColor
                  : inputText,
            ),
      );

      // Add fill animation only to the character, not the container
      if (widget.enableAnimations && position < _fillAnimations.length) {
        characterWidget = AnimatedBuilder(
          animation: _fillAnimations[position],
          builder: (context, child) {
            return Opacity(
              opacity: _fillAnimations[position].value,
              child: Transform.scale(
                scale: 0.8 + (_fillAnimations[position].value * 0.2),
                child: child,
              ),
            );
          },
          child: textWidget,
        );
      } else {
        characterWidget = textWidget;
      }
    }

    // Container is always visible, regardless of whether it has a character
    Widget inputWidget = Container(
      height: inputHeight,
      width: inputSize,
      decoration: BoxDecoration(
        gradient: widget.inputGradient,
        color: widget.inputGradient == null ? backgroundColor : null,
        border: _buildInputBorder(scheme),
        borderRadius: widget.inputBorderRadius ??
            (widget.inputShape == InputShape.rounded
                ? const BorderRadius.all(Radius.circular(100))
                : null),
        boxShadow: widget.inputElevation != null
            ? [
                BoxShadow(
                  color: widget.inputShadowColor?.withOpacity(0.6) ??
                      inputFill.withOpacity(0.6),
                  spreadRadius: 3,
                  blurRadius: 9,
                  offset: Offset(0, widget.inputElevation ?? 0),
                ),
              ]
            : null,
        shape: widget.inputShape == InputShape.circular
            ? BoxShape.circle
            : BoxShape.rectangle,
      ),
      child: Center(
        child: characterWidget,
      ),
    );

    return Semantics(
      label: 'PIN digit ${position + 1}',
      value: character ?? 'empty',
      focusable: widget.enableKeyboardNavigation,
      child: Focus(
        focusNode: widget.enableKeyboardNavigation && position < _focusNodes.length
            ? _focusNodes[position]
            : null,
        child: inputWidget,
      ),
    );
  }

  /// Builds the border for input fields based on the input type.
  Border? _buildInputBorder(ColorScheme scheme) {
    final borderColor = _getThemeColor(
      widget.focusColor ?? widget.inputBorderColor,
      scheme,
      ColorType.inputBorder,
    );

    if (widget.inputType == InputType.dash) {
      return Border(
        bottom: BorderSide(
          color: borderColor,
          width: widget.inputBorderThickness ?? 1,
        ),
      );
    }

    if (!widget.inputHasBorder) {
      return null;
    }

    return Border.all(
      color: borderColor,
      width: widget.inputBorderThickness ?? 1,
    );
  }

  /// Builds the custom numeric keyboard widget.
  Widget _buildCustomKeyboard({required Size size, required ColorScheme scheme}) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: size.width * (widget.keyboardMaxWidth / 100),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Row 1: 1, 2, 3
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeyboardButton('1', scheme: scheme),
              _buildKeyboardButton('2', scheme: scheme),
              _buildKeyboardButton('3', scheme: scheme),
            ],
          ),
          // Row 2: 4, 5, 6
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeyboardButton('4', scheme: scheme),
              _buildKeyboardButton('5', scheme: scheme),
              _buildKeyboardButton('6', scheme: scheme),
            ],
          ),
          // Row 3: 7, 8, 9
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeyboardButton('7', scheme: scheme),
              _buildKeyboardButton('8', scheme: scheme),
              _buildKeyboardButton('9', scheme: scheme),
            ],
          ),
          // Row 4: Biometric/Extra input/Done, 0, Backspace
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Left side: Biometric, custom widget, extra input, or done button
              _buildLeftButton(scheme),
              // Center: Zero button
              _buildKeyboardButton('0', scheme: scheme),
              // Right side: Backspace button
              _buildBackspaceButton(scheme),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the left button (biometric, extra input, or done)
  Widget _buildLeftButton(ColorScheme scheme) {
    if (widget.enableBiometric && _biometricAvailable) {
      return Expanded(
        child: Semantics(
          label: 'Biometric authentication',
          button: true,
          child: IconButton(
            onPressed: _handleBiometricAuth,
            icon: Icon(
              Platform.isIOS ? Icons.face : Icons.fingerprint,
              color: _getThemeColor(null, scheme, ColorType.buttonText),
            ),
          ),
        ),
      );
    }

    return widget.leftExtraInputWidget ??
        (widget.extraInput != null
            ? _buildKeyboardButton(widget.extraInput!, scheme: scheme)
            : Expanded(
                child: Semantics(
                  label: 'Submit PIN',
                  button: true,
                  child: IconButton(
                    onPressed: _onDonePressed,
                    icon: widget.doneButton ??
                        Icon(
                          Icons.done,
                          color: _getThemeColor(
                            widget.inputFillColor ?? widget.inputBorderColor,
                            scheme,
                            ColorType.buttonText,
                          ),
                        ),
                  ),
                ),
              ));
  }

  /// Builds the backspace button
  Widget _buildBackspaceButton(ColorScheme scheme) {
    return Expanded(
      child: Semantics(
        label: 'Delete last digit',
        button: true,
        child: IconButton(
          onPressed: _onBackspacePressed,
          icon: widget.backButton ??
              Icon(
                Icons.backspace,
                color: _getThemeColor(
                  widget.cancelColor,
                  scheme,
                  ColorType.buttonText,
                ),
              ),
        ),
      ),
    );
  }

  /// Handles biometric authentication
  Future<void> _handleBiometricAuth() async {
    _performHapticFeedback(HapticType.medium);
    final authenticated = await _biometricService.authenticate(
      reason: widget.biometricReason ?? 'Please authenticate to continue',
    );

    if (authenticated) {
      _performHapticFeedback(HapticType.success);
      widget.onBiometricSuccess?.call();
      widget.onSubmit();
    } else {
      _performHapticFeedback(HapticType.error);
      widget.onBiometricFailure?.call();
    }
  }

  /// Handles the done/submit button press.
  void _onDonePressed() {
    _performHapticFeedback(HapticType.medium);
    if (_currentPin.length >= widget.pinInputController.length) {
      _handleSubmission();
    } else {
      setState(() {
        _errorText = 'Please fill all fields';
      });
      _performHapticFeedback(HapticType.error);
    }
  }

  /// Handles the backspace button press.
  void _onBackspacePressed() {
    _performHapticFeedback(HapticType.light);
    if (_currentPin.isNotEmpty) {
      final removedPosition = _currentPin.length - 1;
        setState(() {
          _currentPin = _currentPin.substring(0, _currentPin.length - 1);
          widget.pinInputController.changeText(_currentPin);
          _errorText = '';

          // Reverse fill animation if enabled
          if (widget.enableAnimations &&
              removedPosition < _fillControllers.length) {
            _fillControllers[removedPosition].reverse();
          }
        });
    }
  }
}

/// Helper enums for type safety
enum ColorType {
  buttonFill,
  buttonBorder,
  buttonText,
  inputFill,
  inputBorder,
  inputText,
  error,
  focus,
}

enum HapticType {
  light,
  medium,
  heavy,
  success,
  error,
}
