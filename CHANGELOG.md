# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.0.0] - 2025-01-XX

### Added

#### Accessibility
- Full screen reader support with semantic labels
- Keyboard navigation support
- High contrast mode support
- ARIA-like attributes for all interactive elements
- Semantic announcements for input changes

#### Animations & Micro-interactions
- Input field fill animations with customizable curves and duration
- Shake animation on validation errors
- Success checkmark animation on completion
- Button press ripple effects (Material ripple)
- Loading states during submission with CircularProgressIndicator
- Configurable animation curves and durations

#### Material 3 Enhancements
- Material 3 design token support (ColorScheme, TextTheme)
- Dynamic color support (Material You) via ColorScheme.fromSeed
- Adaptive theming based on system preferences
- Better elevation and surface color handling using Material 3 tokens
- Automatic color derivation from theme when useMaterial3 is enabled

#### Platform-Specific Improvements
- iOS/Android-specific styling and behaviors
- Platform-appropriate haptic patterns (different intensities per platform)
- Platform-specific animations (iOS spring, Android material)
- Automatic platform detection and styling

#### Biometric Integration
- Face ID / Touch ID / Fingerprint support via BiometricService
- Optional biometric authentication button in keyboard
- Fallback to PIN when biometrics fail
- Platform-agnostic biometric interface
- Support for local_auth package (optional dependency)

#### Security Features
- Auto-clear after inactivity timeout
- Optional screenshot blocking (Android only)
- Secure input handling (no logging of sensitive data)
- Rate limiting for failed attempts with configurable thresholds
- SecurityService for managing security features

#### Advanced Customization
- Gradient support for buttons and inputs
- Custom animation curves parameter
- Custom input field builders for complete control
- Custom keyboard button builders
- Theme presets (iOS-style, Android-style, Material 3, Minimal, Dark)
- PinThemePresets class with ready-to-use configurations

#### Performance Optimizations
- RepaintBoundary for keyboard buttons to reduce repaints
- More const constructors where possible
- Efficient rebuilds with optimized state management
- Lazy loading for large customizations

#### Developer Experience
- Better error messages and debugging information
- Comprehensive API documentation
- Enhanced example app with all new features
- Type-safe enums and parameters

### Changed

- **BREAKING**: Default `enableAnimations` is now `true` (was implicitly false)
- **BREAKING**: Default `useMaterial3` is now `true` (was implicitly false)
- **BREAKING**: Default `enableKeyboardNavigation` is now `true` (was implicitly false)
- **BREAKING**: Default `usePlatformSpecificStyling` is now `true` (was implicitly false)
- Improved color handling with Material 3 design tokens
- Enhanced haptic feedback with platform-specific patterns
- Better error handling with rate limiting support
- More consistent theming across all components

### Fixed

- Improved accessibility for screen readers
- Better focus management for keyboard navigation
- Fixed color handling in Material 3 mode
- Improved animation performance
- Better error message display and handling

### Security

- Added rate limiting to prevent brute force attacks
- Added screenshot blocking support (Android)
- Added auto-clear timeout for security
- Improved secure input handling

## [2.0.6] - 2025-11-23

### Added

- Haptic feedback support for better user experience on supported devices
- Custom validation function (`validator`) for PIN validation
- `onDigitEntered` callback to track individual digit entries
- Comprehensive code comments throughout the codebase
- Unit tests for `PinInputController` and widget tests
- Contributing guidelines (CONTRIBUTING.md)
- Enhanced example app with modern Flutter patterns

### Changed

- Upgraded Flutter SDK requirement from >=3.0.0 to >=3.24.0
- Upgraded Dart SDK requirement from >=3.0.0 to >=3.4.0
- Updated `flutter_lints` from ^3.0.0 to ^5.0.0
- Improved error handling with validation support
- Enhanced documentation with better examples
- Modernized example app with Material 3 and const constructors

### Fixed

- Improved validation flow to prevent submission of invalid PINs
- Better error message handling and display

## [2.0.5] - Previous

### Changed

- Internal improvements and bug fixes

## [2.0.4] - Previous

### Changed

- Internal improvements and bug fixes

## [2.0.3] - Previous

### Changed

- Internal improvements and bug fixes

## [2.0.2] - Previous

### Changed

- Internal improvements and bug fixes

## [2.0.1] - Previous

### Changed

- Internal improvements and bug fixes

## [2.0.0] - Previous

### Changed

- Major version update with significant improvements

## [0.0.10] - Previous

### Changed

- Internal improvements

## [0.0.9] - Previous

### Fixed

- Fixed cancel and done button color to take filled color or border color

## [0.0.8] - Previous

### Changed

- Internal improvements

## [0.0.7] - Previous

### Changed

- Internal improvements

## [0.0.6] - Previous

### Changed

- Updated example

## [0.0.5] - Previous

### Added

- Added example images

## [0.0.4] - Previous

### Fixed

- Bug fixes

## [0.0.3] - Previous

### Fixed

- Bug fixes

## [0.0.2] - Previous

### Fixed

- Fixed compatibility issues

## [0.0.1] - Initial Release

### Added

- A Flutter package that provides custom input fields and a custom keyboard for one-time password widgets, transaction PIN widgets, and simple login widgets

[2.0.6]: https://github.com/JoshuaObateru/pin_plus_keyboard/compare/2.0.5...2.0.6
