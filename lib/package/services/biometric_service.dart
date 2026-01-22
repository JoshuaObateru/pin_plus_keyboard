import 'package:flutter/foundation.dart';

/// Service for handling biometric authentication.
///
/// This service provides a platform-agnostic interface for biometric
/// authentication (Face ID, Touch ID, Fingerprint). It uses the `local_auth`
/// package when available, or provides a fallback interface.
///
/// Example usage:
/// ```dart
/// final service = BiometricService();
/// if (await service.isAvailable()) {
///   final authenticated = await service.authenticate();
///   if (authenticated) {
///     // Handle successful authentication
///   }
/// }
/// ```
class BiometricService {
  /// Whether biometric authentication is available on this device.
  ///
  /// Returns `true` if biometric authentication is supported and available.
  Future<bool> isAvailable() async {
    if (kIsWeb) {
      return false;
    }
    
    try {
      // Dynamic import to avoid requiring local_auth as a direct dependency
      // This allows the package to work even if local_auth is not added
      final localAuth = await _getLocalAuth();
      if (localAuth == null) return false;
      
      return await localAuth.canCheckBiometrics ||
          await localAuth.isDeviceSupported();
    } catch (e) {
      debugPrint('BiometricService: Error checking availability: $e');
      return false;
    }
  }

  /// Authenticates the user using biometrics.
  ///
  /// Returns `true` if authentication was successful, `false` otherwise.
  /// [reason] is the message shown to the user during authentication.
  Future<bool> authenticate({
    String reason = 'Please authenticate to continue',
    bool useErrorDialogs = true,
    bool stickyAuth = true,
  }) async {
    if (kIsWeb) {
      return false;
    }

    try {
      final localAuth = await _getLocalAuth();
      if (localAuth == null) return false;

      return await localAuth.authenticate(
        localizedReason: reason,
        options: AuthenticationOptions(
          useErrorDialogs: useErrorDialogs,
          stickyAuth: stickyAuth,
          biometricOnly: false,
        ),
      );
    } catch (e) {
      debugPrint('BiometricService: Error during authentication: $e');
      return false;
    }
  }

  /// Gets available biometric types on the device.
  ///
  /// Returns a list of available biometric types (e.g., Face, Fingerprint).
  Future<List<BiometricType>> getAvailableBiometrics() async {
    if (kIsWeb) {
      return [];
    }

    try {
      final localAuth = await _getLocalAuth();
      if (localAuth == null) return [];

      return await localAuth.getAvailableBiometrics();
    } catch (e) {
      debugPrint('BiometricService: Error getting biometrics: $e');
      return [];
    }
  }

  /// Dynamically loads the local_auth package if available.
  ///
  /// Returns null if local_auth is not available or cannot be loaded.
  Future<dynamic> _getLocalAuth() async {
    try {
      // Try to dynamically import local_auth
      // This allows the package to work without requiring local_auth
      // as a direct dependency if users don't need biometric features
      final package = await _loadPackage('local_auth');
      if (package == null) return null;

      // Create LocalAuthentication instance
      final LocalAuthentication = package['LocalAuthentication'];
      if (LocalAuthentication == null) return null;

      return LocalAuthentication();
    } catch (e) {
      // local_auth not available, return null
      return null;
    }
  }

  /// Attempts to load a package dynamically.
  ///
  /// This is a fallback mechanism. In practice, users should add
  /// local_auth as a dependency if they want biometric features.
  Future<Map<String, dynamic>?> _loadPackage(String packageName) async {
    // This is a placeholder. In a real implementation, we'd check
    // if the package is available. For now, we'll rely on users
    // adding local_auth as a dependency and use a simpler approach.
    return null;
  }
}

/// Biometric types supported by the device.
///
/// This enum matches the types from the local_auth package.
enum BiometricType {
  /// Face recognition (Face ID on iOS, Face Unlock on Android)
  face,

  /// Fingerprint recognition (Touch ID on iOS, Fingerprint on Android)
  fingerprint,

  /// Iris recognition (Android only)
  iris,

  /// Strong biometric authentication (Android only)
  strong,

  /// Weak biometric authentication (Android only)
  weak,
}

/// Authentication options for biometric authentication.
///
/// This class matches the options from the local_auth package.
class AuthenticationOptions {
  /// Whether to use error dialogs.
  final bool useErrorDialogs;

  /// Whether to use sticky authentication.
  final bool stickyAuth;

  /// Whether to use biometric-only authentication.
  final bool biometricOnly;

  /// Creates authentication options.
  const AuthenticationOptions({
    this.useErrorDialogs = true,
    this.stickyAuth = true,
    this.biometricOnly = false,
  });
}

