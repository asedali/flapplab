import 'package:flutter/services.dart';

/// Haptic feedback utility for premium UX
/// Provides consistent haptic patterns across the app

class AppHaptics {
  AppHaptics._();

  /// Light impact for subtle interactions (button taps, toggles)
  static Future<void> light() async {
    try {
      await HapticFeedback.lightImpact();
    } catch (_) {}
  }

  /// Medium impact for important actions (send message, confirm)
  static Future<void> medium() async {
    try {
      await HapticFeedback.mediumImpact();
    } catch (_) {}
  }

  /// Heavy impact for significant events (scan complete, error)
  static Future<void> heavy() async {
    try {
      await HapticFeedback.heavyImpact();
    } catch (_) {}
  }

  /// Success pattern for positive outcomes
  static Future<void> success() async {
    try {
      await HapticFeedback.vibrate(VibrationType.success);
    } catch (_) {}
  }

  /// Warning pattern for alerts
  static Future<void> warning() async {
    try {
      await HapticFeedback.vibrate(VibrationType.warning);
    } catch (_) {}
  }

  /// Error pattern for failures
  static Future<void> error() async {
    try {
      await HapticFeedback.vibrate(VibrationType.error);
    } catch (_) {}
  }

  /// Selection tick for pickers and sliders
  static Future<void> selection() async {
    try {
      await HapticFeedback.selectionClick();
    } catch (_) {}
  }
}
