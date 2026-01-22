# Contributing to pin_plus_keyboard

First off, thank you for considering contributing to `pin_plus_keyboard`! 🎉

This document provides guidelines and instructions for contributing to this project. Following these guidelines helps communicate that you respect the time of the developers managing and developing this open source project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
  - [Reporting Bugs](#reporting-bugs)
  - [Suggesting Enhancements](#suggesting-enhancements)
  - [Pull Requests](#pull-requests)
- [Development Setup](#development-setup)
- [Coding Standards](#coding-standards)
- [Testing Guidelines](#testing-guidelines)
- [Documentation](#documentation)
- [Commit Message Guidelines](#commit-message-guidelines)

## Code of Conduct

This project adheres to a code of conduct that all contributors are expected to follow:

- **Be respectful**: Treat everyone with respect and kindness
- **Be inclusive**: Welcome newcomers and help them get started
- **Be constructive**: Provide helpful feedback and suggestions
- **Be patient**: Remember that maintainers are volunteers with limited time

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the issue list as you might find out that you don't need to create one. When you are creating a bug report, please include as many details as possible:

**Bug Report Template:**

```markdown
**Describe the bug**
A clear and concise description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:

1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

**Expected behavior**
A clear and concise description of what you expected to happen.

**Screenshots**
If applicable, add screenshots to help explain your problem.

**Environment:**

- Flutter version: [e.g., 3.24.0]
- Dart version: [e.g., 3.4.0]
- Device: [e.g., iPhone 13, Android Emulator]
- OS version: [e.g., iOS 17.0, Android 14]

**Additional context**
Add any other context about the problem here.
```

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, please include:

**Enhancement Template:**

```markdown
**Is your feature request related to a problem?**
A clear and concise description of what the problem is.

**Describe the solution you'd like**
A clear and concise description of what you want to happen.

**Describe alternatives you've considered**
A clear and concise description of any alternative solutions or features you've considered.

**Additional context**
Add any other context or screenshots about the feature request here.
```

### Pull Requests

Pull requests are the best way to propose changes to the codebase:

1. **Fork the repository** and create your branch from `main` (or `joshDev` if that's the active branch)
2. **Make your changes** following our coding standards
3. **Add tests** for any new functionality
4. **Update documentation** if you've changed APIs or added features
5. **Ensure all tests pass** and the code follows the style guidelines
6. **Submit the pull request** with a clear description of your changes

**Pull Request Template:**

- What changes does this PR introduce?
- Why are these changes needed?
- How were these changes tested?
- Screenshots (if applicable)
- Checklist:
  - [ ] Code follows the style guidelines
  - [ ] Self-review completed
  - [ ] Comments added for complex logic
  - [ ] Documentation updated
  - [ ] Tests added/updated
  - [ ] All tests passing

## Development Setup

### Prerequisites

- Flutter SDK >= 3.24.0
- Dart SDK >= 3.4.0
- Git
- A code editor (VS Code, Android Studio, or IntelliJ IDEA recommended)

### Getting Started

1. **Fork and clone the repository:**

   ```bash
   git clone https://github.com/YOUR_USERNAME/pin_plus_keyboard.git
   cd pin_plus_keyboard
   ```

2. **Add the upstream remote:**

   ```bash
   git remote add upstream https://github.com/JoshuaObateru/pin_plus_keyboard.git
   ```

3. **Install dependencies:**

   ```bash
   flutter pub get
   ```

4. **Run the example app:**

   ```bash
   cd example
   flutter run
   ```

5. **Run tests:**

   ```bash
   flutter test
   ```

6. **Check code quality:**
   ```bash
   flutter analyze
   ```

## Coding Standards

### General Guidelines

- **Follow Dart Style Guide**: Adhere to the [official Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- **Use meaningful names**: Variables, functions, and classes should have descriptive names
- **Keep functions small**: Functions should do one thing and do it well
- **Add comments**: Explain "why" not "what" - the code should be self-documenting
- **Use const constructors**: When possible, use `const` constructors for better performance

### Code Formatting

- Run `dart format .` before committing
- Use 2 spaces for indentation (not tabs)
- Maximum line length: 80 characters (soft limit, 100 hard limit)
- Use trailing commas in multi-line lists/maps

### Documentation Comments

- Use `///` for documentation comments (not `//`)
- Document all public APIs
- Include parameter descriptions
- Provide usage examples for complex APIs

**Example:**

````dart
/// A controller that manages the state of PIN input fields.
///
/// This controller extends [ChangeNotifier] to allow widgets to listen to
/// changes in the PIN input text.
///
/// Example usage:
/// ```dart
/// final controller = PinInputController(length: 6);
/// controller.addListener(() {
///   print('PIN: ${controller.text}');
/// });
/// ```
class PinInputController extends ChangeNotifier {
  // ...
}
````

### Widget Guidelines

- Use `const` constructors when possible
- Extract complex widgets into separate methods or classes
- Use meaningful widget keys for testing
- Prefer composition over inheritance

### Error Handling

- Use appropriate exception types
- Provide meaningful error messages
- Handle edge cases gracefully
- Log errors appropriately (but avoid logging sensitive data)

### Accessibility Guidelines

When adding new features or modifying existing ones, ensure accessibility is maintained:

- **Semantic Labels**: Always add semantic labels to interactive elements
  ```dart
  Semantics(
    label: 'Clear PIN input',
    button: true,
    child: IconButton(...),
  )
  ```

- **Keyboard Navigation**: Support keyboard navigation for all interactive elements
  ```dart
  Focus(
    focusNode: focusNode,
    child: Widget(...),
  )
  ```

- **Screen Reader Support**: Test with screen readers (TalkBack on Android, VoiceOver on iOS)
- **High Contrast Mode**: Ensure colors work in high contrast mode
- **Live Regions**: Use Semantics with `liveRegion: true` for dynamic content updates

### Animation Guidelines

When adding animations:

- **Performance**: Use `RepaintBoundary` to isolate expensive animations
- **Curves**: Provide customizable animation curves (default to `Curves.easeInOut`)
- **Duration**: Make animation durations configurable with sensible defaults
- **Accessibility**: Respect `MediaQuery.disableAnimations` for accessibility
  ```dart
  if (MediaQuery.of(context).disableAnimations) {
    // Skip animation
  }
  ```

- **Testing**: Test animations with different durations and curves
- **Platform**: Consider platform-specific animation styles (iOS spring, Android material)

### Security Best Practices

When working with security features:

- **No Logging**: Never log PIN values or sensitive data
- **Rate Limiting**: Always implement rate limiting for authentication attempts
- **Auto-Clear**: Consider auto-clear timeouts for sensitive inputs
- **Screenshot Blocking**: Only enable screenshot blocking when necessary (Android only)
- **Biometric**: Handle biometric failures gracefully with fallback to PIN
- **Validation**: Validate input on both client and server side
- **Error Messages**: Don't reveal sensitive information in error messages

Example security implementation:
```dart
// Good: Generic error message
setState(() {
  _errorText = 'Authentication failed. Please try again.';
});

// Bad: Revealing specific information
setState(() {
  _errorText = 'PIN incorrect. You have ${attemptsLeft} attempts remaining.';
});
```

## Testing Guidelines

### Writing Tests

- **Test coverage**: Aim for at least 80% code coverage
- **Test structure**: Use the AAA pattern (Arrange, Act, Assert)
- **Test names**: Use descriptive test names that explain what is being tested
- **Test isolation**: Each test should be independent and not rely on other tests

### Test Categories

1. **Unit Tests**: Test individual functions and classes
2. **Widget Tests**: Test widget rendering and interactions
3. **Integration Tests**: Test the complete flow (if applicable)
4. **Accessibility Tests**: Test screen reader support and keyboard navigation
5. **Animation Tests**: Test animation behavior and performance
6. **Security Tests**: Test rate limiting, auto-clear, and security features
7. **Biometric Tests**: Test biometric integration (mocked for CI/CD)

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run a specific test file
flutter test test/pin_input_controller_test.dart
```

### Example Test Structure

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:pin_plus_keyboard/package/controllers/pin_input_controller.dart';

void main() {
  group('PinInputController', () {
    test('should initialize with correct length', () {
      // Arrange
      const length = 6;

      // Act
      final controller = PinInputController(length: length);

      // Assert
      expect(controller.length, equals(length));
      expect(controller.text, isEmpty);
      expect(controller.isEmpty, isTrue);
      expect(controller.isComplete, isFalse);
    });

    test('should update text and notify listeners', () {
      // Arrange
      final controller = PinInputController(length: 4);
      var notified = false;
      controller.addListener(() => notified = true);

      // Act
      controller.changeText('1234');

      // Assert
      expect(controller.text, equals('1234'));
      expect(notified, isTrue);
      expect(controller.isComplete, isTrue);
    });
  });
}
```

### Accessibility Testing

When testing accessibility features:

```dart
testWidgets('should have semantic labels for screen readers', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: PinPlusKeyBoardPackage(
        pinInputController: controller,
        spacing: 40,
        onSubmit: () {},
        semanticLabel: 'Enter PIN',
      ),
    ),
  );

  // Verify semantic properties
  expect(
    find.bySemanticsLabel('Enter PIN'),
    findsOneWidget,
  );
});
```

### Animation Testing

When testing animations:

```dart
testWidgets('should animate input fill', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: PinPlusKeyBoardPackage(
        pinInputController: controller,
        spacing: 40,
        onSubmit: () {},
        enableAnimations: true,
      ),
    ),
  );

  // Trigger animation
  await tester.tap(find.text('1'));
  await tester.pump();

  // Verify animation started
  await tester.pump(const Duration(milliseconds: 100));
  // Add assertions for animation state
});
```

### Biometric Integration Testing

When testing biometric features, use mocks:

```dart
// Mock biometric service
class MockBiometricService extends BiometricService {
  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<bool> authenticate({String reason = '', ...}) async => true;
}

testWidgets('should show biometric button when available', (tester) async {
  final mockService = MockBiometricService();
  
  await tester.pumpWidget(
    MaterialApp(
      home: PinPlusKeyBoardPackage(
        pinInputController: controller,
        spacing: 40,
        onSubmit: () {},
        enableBiometric: true,
        biometricService: mockService,
      ),
    ),
  );

  // Verify biometric button is shown
  expect(find.byIcon(Icons.fingerprint), findsOneWidget);
});
```

## Documentation

### README Updates

- Keep the README up-to-date with new features
- Include code examples for new functionality
- Update screenshots when UI changes
- Maintain accurate version numbers

### API Documentation

- Document all public classes, methods, and properties
- Include parameter descriptions
- Provide usage examples
- Document any breaking changes

### Changelog

- Update `CHANGELOG.md` for all user-facing changes
- Follow the [Keep a Changelog](https://keepachangelog.com/) format
- Group changes by type: Added, Changed, Deprecated, Removed, Fixed, Security

## Commit Message Guidelines

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

### Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Code style changes (formatting, missing semicolons, etc.)
- `refactor`: Code refactoring without changing functionality
- `test`: Adding or updating tests
- `chore`: Maintenance tasks (dependencies, build config, etc.)

### Examples

```
feat(keyboard): add haptic feedback support

Add haptic feedback when keyboard buttons are pressed to improve
user experience on supported devices.

Closes #123
```

```
fix(controller): prevent text overflow in PIN input

The controller was not properly validating input length, causing
overflow errors when users typed too quickly.

Fixes #456
```

```
docs(readme): update installation instructions

Update README with latest Flutter version requirements and
improved setup instructions.
```

## Review Process

1. All pull requests require at least one review
2. Maintainers will review code quality, tests, and documentation
3. Address review comments promptly
4. Keep discussions constructive and respectful

## Questions?

If you have questions about contributing, feel free to:

- Open an issue with the `question` label
- Check existing issues and discussions
- Reach out to maintainers

Thank you for contributing to `pin_plus_keyboard`! 🚀
