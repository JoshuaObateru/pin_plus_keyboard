import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Service for handling security-related features.
///
/// This service provides utilities for:
/// - Auto-clearing PIN after inactivity
/// - Screenshot blocking (platform-specific)
/// - Secure input handling
/// - Rate limiting for failed attempts
///
/// Example usage:
/// ```dart
/// final service = SecurityService();
/// service.startAutoClearTimer(
///   timeout: Duration(seconds: 30),
///   onTimeout: () {
///     // Clear PIN after 30 seconds of inactivity
///   },
/// );
/// ```
class SecurityService {
  Timer? _autoClearTimer;
  int _failedAttempts = 0;
  DateTime? _lastFailedAttempt;
  final List<DateTime> _failedAttemptHistory = [];

  /// Starts an auto-clear timer that will call [onTimeout] after [timeout]
  /// duration of inactivity.
  ///
  /// The timer resets whenever [resetTimer] is called (typically when user
  /// interacts with the PIN input).
  void startAutoClearTimer({
    required Duration timeout,
    required VoidCallback onTimeout,
  }) {
    _autoClearTimer?.cancel();
    _autoClearTimer = Timer(timeout, onTimeout);
  }

  /// Resets the auto-clear timer.
  ///
  /// Call this whenever the user interacts with the PIN input to prevent
  /// auto-clearing during active use.
  void resetAutoClearTimer() {
    _autoClearTimer?.cancel();
  }

  /// Stops the auto-clear timer.
  void stopAutoClearTimer() {
    _autoClearTimer?.cancel();
    _autoClearTimer = null;
  }

  /// Enables screenshot blocking on supported platforms.
  ///
  /// On Android, this prevents screenshots while the PIN input is visible.
  /// On iOS, screenshot blocking is not supported by the system.
  ///
  /// Returns `true` if screenshot blocking was enabled, `false` otherwise.
  Future<bool> enableScreenshotBlocking() async {
    if (kIsWeb) {
      return false;
    }

    try {
      if (Platform.isAndroid) {
        // Use MethodChannel to communicate with native Android code
        // This requires platform-specific implementation
        const platform = MethodChannel('pin_plus_keyboard/security');
        await platform.invokeMethod('enableScreenshotBlocking');
        return true;
      } else if (Platform.isIOS) {
        // iOS doesn't support programmatic screenshot blocking
        // Apps can use UIApplication.shared.isIdleTimerDisabled but that's
        // not the same as blocking screenshots
        debugPrint('Screenshot blocking not supported on iOS');
        return false;
      }
    } catch (e) {
      debugPrint('SecurityService: Error enabling screenshot blocking: $e');
    }
    return false;
  }

  /// Disables screenshot blocking.
  Future<bool> disableScreenshotBlocking() async {
    if (kIsWeb) {
      return false;
    }

    try {
      if (Platform.isAndroid) {
        const platform = MethodChannel('pin_plus_keyboard/security');
        await platform.invokeMethod('disableScreenshotBlocking');
        return true;
      }
    } catch (e) {
      debugPrint('SecurityService: Error disabling screenshot blocking: $e');
    }
    return false;
  }

  /// Records a failed authentication attempt.
  ///
  /// This is used for rate limiting to prevent brute force attacks.
  void recordFailedAttempt() {
    _failedAttempts++;
    _lastFailedAttempt = DateTime.now();
    _failedAttemptHistory.add(DateTime.now());

    // Keep only last 10 failed attempts for memory efficiency
    if (_failedAttemptHistory.length > 10) {
      _failedAttemptHistory.removeAt(0);
    }
  }

  /// Records a successful authentication attempt.
  ///
  /// This resets the failed attempt counter.
  void recordSuccessfulAttempt() {
    _failedAttempts = 0;
    _lastFailedAttempt = null;
    _failedAttemptHistory.clear();
  }

  /// Checks if authentication should be rate limited.
  ///
  /// Returns `true` if too many failed attempts have occurred within
  /// the specified [timeWindow], `false` otherwise.
  ///
  /// [maxAttempts] is the maximum number of allowed attempts.
  /// [timeWindow] is the time window to check within.
  bool shouldRateLimit({
    int maxAttempts = 5,
    Duration timeWindow = const Duration(minutes: 15),
  }) {
    if (_failedAttempts < maxAttempts) {
      return false;
    }

    if (_lastFailedAttempt == null) {
      return false;
    }

    final now = DateTime.now();
    final timeSinceLastAttempt = now.difference(_lastFailedAttempt!);

    // Check if we're still within the time window
    if (timeSinceLastAttempt > timeWindow) {
      // Reset if outside time window
      _failedAttempts = 0;
      _lastFailedAttempt = null;
      return false;
    }

    // Count recent failed attempts within time window
    final cutoffTime = now.subtract(timeWindow);
    final recentAttempts = _failedAttemptHistory
        .where((attempt) => attempt.isAfter(cutoffTime))
        .length;

    return recentAttempts >= maxAttempts;
  }

  /// Gets the number of failed attempts.
  int get failedAttempts => _failedAttempts;

  /// Gets the time until rate limiting is lifted (if currently rate limited).
  ///
  /// Returns `null` if not rate limited, or the duration until rate limit
  /// is lifted if rate limited.
  Duration? getTimeUntilRateLimitLifted({
    int maxAttempts = 5,
    Duration timeWindow = const Duration(minutes: 15),
  }) {
    if (!shouldRateLimit(maxAttempts: maxAttempts, timeWindow: timeWindow)) {
      return null;
    }

    if (_lastFailedAttempt == null) {
      return null;
    }

    final now = DateTime.now();
    final timeSinceLastAttempt = now.difference(_lastFailedAttempt!);
    final remaining = timeWindow - timeSinceLastAttempt;

    return remaining.isNegative ? null : remaining;
  }

  /// Cleans up resources.
  void dispose() {
    _autoClearTimer?.cancel();
    _failedAttemptHistory.clear();
  }
}

