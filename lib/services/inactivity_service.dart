import 'dart:async';
import 'package:flutter/material.dart';

/// Service to detect and manage user inactivity
/// Triggers automatic vault locking after a specified inactivity period
class InactivityService {
  Timer? _inactivityTimer;
  Duration _inactivityTimeout;
  VoidCallback? _onInactivityDetected;
  bool _isActive = true;

  InactivityService({
    Duration inactivityTimeout = const Duration(minutes: 5),
  }) : _inactivityTimeout = inactivityTimeout;

  /// Start monitoring for inactivity
  void startMonitoring({
    required VoidCallback onInactivityDetected,
  }) {
    _onInactivityDetected = onInactivityDetected;
    debugPrint(
        '[InactivityService] Starting monitoring with timeout: $_inactivityTimeout');
    _resetInactivityTimer();
  }

  /// Stop monitoring for inactivity
  void stopMonitoring() {
    _inactivityTimer?.cancel();
    _inactivityTimer = null;
    _onInactivityDetected = null;
  }

  /// Reset the inactivity timer (call on user activity)
  void resetInactivityTimer() {
    if (!_isActive) {
      debugPrint('[InactivityService] Ignoring reset - app is not active');
      return; // Don't reset if app is paused
    }
    debugPrint('[InactivityService] User activity detected - resetting timer');
    _resetInactivityTimer();
  }

  void _resetInactivityTimer() {
    // Cancel existing timer
    _inactivityTimer?.cancel();

    // Set new timer
    _inactivityTimer = Timer(_inactivityTimeout, () {
      debugPrint(
          '[InactivityService] Timer triggered after $_inactivityTimeout');
      if (_onInactivityDetected != null) {
        debugPrint('[InactivityService] Calling onInactivityDetected callback');
        _onInactivityDetected!();
      }
    });
    debugPrint('[InactivityService] Timer reset for $_inactivityTimeout');
  }

  /// Called when app lifecycle changes
  /// Pause monitoring when app is in background
  void handleAppLifecycleChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _isActive = true;
        // Reset timer when app returns to foreground
        _resetInactivityTimer();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.inactive:
        _isActive = false;
        // Don't cancel timer - let it run in background
        // This allows locking even if app was paused
        break;
    }
  }

  /// Update the inactivity timeout duration
  void updateTimeout(Duration newTimeout) {
    _inactivityTimeout = newTimeout;
    _resetInactivityTimer();
  }

  /// Get current inactivity status
  bool get isActive => _isActive;

  /// Dispose resources
  void dispose() {
    stopMonitoring();
  }
}
