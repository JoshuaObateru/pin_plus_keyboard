import 'package:flutter/material.dart';
import 'package:pin_plus_keyboard/pin_plus_keyboard.dart';
import 'package:pin_plus_keyboard/package/controllers/pin_input_controller.dart';

/// Example application demonstrating the usage of PinPlusKeyBoardPackage
///
/// This example shows:
/// - Basic PIN input setup
/// - Controller initialization and disposal
/// - Handling PIN submission
/// - Modern Flutter patterns (const constructors, super parameters)
/// - All new features: animations, Material 3, biometric, security, etc.
void main() {
  runApp(const MyApp());
}

/// Root widget of the example application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PIN Plus Keyboard Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const Example(),
    );
  }
}

/// Main example screen demonstrating PIN input with all features
class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  /// Controller that manages the PIN input state
  /// The length parameter (6) determines how many input fields will be displayed
  /// This is a required parameter - you must specify the PIN length
  late final PinInputController _pinInputController = PinInputController(
    length: 6,
  );

  /// Optional: Track submission attempts for demonstration
  int _submissionCount = 0;

  /// Track if biometric is available
  bool _biometricAvailable = false;

  @override
  void initState() {
    super.initState();
    // Check biometric availability (would need local_auth package)
    // _checkBiometricAvailability();
  }

  @override
  void dispose() {
    // CRITICAL: Always dispose controllers to prevent memory leaks
    // Controllers extend ChangeNotifier and may hold references to listeners
    // Failing to dispose can cause memory leaks and unexpected behavior
    _pinInputController.dispose();
    super.dispose();
  }

  /// Handles PIN submission
  ///
  /// This callback is called when:
  /// - All PIN fields are filled (auto-submit)
  /// - The user presses the "Done" button
  void _handlePinSubmission() {
    setState(() {
      _submissionCount++;
    });

    // In a real app, you would:
    // 1. Validate the PIN with your backend
    // 2. Navigate to the next screen on success
    // 3. Show error message on failure
    // 4. Clear the PIN on error: _pinInputController.clear()

    debugPrint('PIN entered: ${_pinInputController.text}');
    debugPrint('Submission attempt #$_submissionCount');

    // Example: Show a dialog (in real app, handle authentication)
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('PIN Entered'),
          content: Text('PIN: ${_pinInputController.text}\n'
              'Attempts: $_submissionCount'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Clear PIN after showing dialog
                _pinInputController.clear();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  /// Handles biometric authentication success
  void _handleBiometricSuccess() {
    debugPrint('Biometric authentication successful');
    _handlePinSubmission();
  }

  /// Handles biometric authentication failure
  void _handleBiometricFailure() {
    debugPrint('Biometric authentication failed');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Biometric authentication failed. Please use PIN.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive design
    final Size size = MediaQuery.of(context).size;
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PIN Plus Keyboard Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Welcome message
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: size.width * 0.07,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Instruction text
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Enter Passcode',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w300,
                    fontSize: size.width * 0.05,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Feature badges
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                alignment: WrapAlignment.center,
                children: [
                  Chip(
                    label: const Text('Material 3'),
                    avatar: const Icon(Icons.palette, size: 18),
                  ),
                  Chip(
                    label: const Text('Animations'),
                    avatar: const Icon(Icons.animation, size: 18),
                  ),
                  Chip(
                    label: const Text('Accessibility'),
                    avatar: const Icon(Icons.accessibility, size: 18),
                  ),
                  if (_biometricAvailable)
                    Chip(
                      label: const Text('Biometric'),
                      avatar: const Icon(Icons.fingerprint, size: 18),
                    ),
                ],
              ),

              // Spacing between text and PIN input
              SizedBox(height: size.height * 0.05),

              // PIN input widget with custom keyboard
              // This is the main widget from the package
              // Demonstrating all new features
              PinPlusKeyBoardPackage(
                // Required: Controller that manages PIN state
                pinInputController: _pinInputController,

                // Required: Spacing between input fields and keyboard
                // This ensures proper layout and visual separation
                spacing: size.height * 0.06,

                // Required: Callback when PIN is submitted
                // Called automatically when all fields are filled,
                // or when user presses the "Done" button
                onSubmit: _handlePinSubmission,

                // Material 3 features
                useMaterial3: true,
                usePlatformSpecificStyling: true,

                // Accessibility features
                semanticLabel: 'Enter your 6-digit PIN code',
                enableKeyboardNavigation: true,

                // Animation features
                enableAnimations: true,
                enableShakeAnimation: true,
                enableSuccessAnimation: true,
                animationCurve: Curves.easeInOut,
                animationDuration: const Duration(milliseconds: 250),
                showLoadingState: false,

                // Haptic feedback
                enableHapticFeedback: true,

                // Biometric features (optional - requires local_auth)
                enableBiometric: _biometricAvailable,
                onBiometricSuccess: _handleBiometricSuccess,
                onBiometricFailure: _handleBiometricFailure,
                biometricReason: 'Please authenticate to access your account',

                // Security features
                autoClearTimeout: const Duration(seconds: 30),
                enableScreenshotBlocking: false, // Set to true for Android
                maxFailedAttempts: 5,
                rateLimitWindow: const Duration(minutes: 15),

                // Custom validation
                // This example validates that PIN is not all the same digit
                validator: (String pin) {
                  if (pin.split('').every((digit) => digit == pin[0])) {
                    return 'PIN cannot be all the same digit';
                  }
                  // Example: Prevent sequential PINs
                  if (pin == '123456' || pin == '654321') {
                    return 'PIN cannot be sequential';
                  }
                  return ''; // Empty string means validation passed
                },

                // Track each digit entry (for analytics, etc.)
                onDigitEntered: (String digit, int position) {
                  debugPrint('Digit "$digit" entered at position $position');
                },

                // Optional: Custom styling (Material 3 will override these if useMaterial3 is true)
                inputShape: InputShape.rounded,
                keyboardButtonShape: KeyboardButtonShape.circular,
              ),

              // Optional: Show submission count (for demonstration)
              if (_submissionCount > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    'Submissions: $_submissionCount',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ),

              // Information section
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Features Demonstrated:',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildFeatureItem('✓ Material 3 design tokens'),
                        _buildFeatureItem('✓ Smooth animations'),
                        _buildFeatureItem('✓ Accessibility support'),
                        _buildFeatureItem('✓ Platform-specific styling'),
                        _buildFeatureItem('✓ Haptic feedback'),
                        _buildFeatureItem('✓ Security features'),
                        if (_biometricAvailable) _buildFeatureItem('✓ Biometric authentication'),
                        _buildFeatureItem('✓ Custom validation'),
                        _buildFeatureItem('✓ Error handling'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
