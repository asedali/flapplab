import 'package:intl/intl.dart';

/// Formatting utilities for NooraSense
/// Handles percentages, numbers, dates, and nutrition values

class AppFormatters {
  AppFormatters._();

  static final _percentFormat = NumberFormat('#0%', 'en_US');
  static final _oneDecimalFormat = NumberFormat('#0.0', 'en_US');
  static final _noDecimalFormat = NumberFormat('#0', 'en_US');
  static final _dateTimeFormat = DateFormat('MMM d, yyyy • h:mm a');
  static final _shortDateFormat = DateFormat('MMM d');

  /// Format confidence/parameter values as percentage
  static String percent(double value) {
    return _percentFormat.format(value.clamp(0, 1));
  }

  /// Format with one decimal place
  static String oneDecimal(double value) {
    return _oneDecimalFormat.format(value);
  }

  /// Format without decimals
  static String noDecimal(num value) {
    return _noDecimalFormat.format(value);
  }

  /// Format calories
  static String calories(int value) {
    return '${noDecimal(value)} cal';
  }

  /// Format grams (protein, carbs, fat)
  static String grams(double value) {
    return '${oneDecimal(value)}g';
  }

  /// Format date time for chat messages
  static String dateTime(DateTime dateTime) {
    return _dateTimeFormat.format(dateTime);
  }

  /// Format short date for history items
  static String shortDate(DateTime dateTime) {
    return _shortDateFormat.format(dateTime);
  }

  /// Format parameter name (snake_case to Title Case)
  static String formatParameterName(String snakeCase) {
    return snakeCase
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  /// Get color-coded status text for parameter value
  static String getStatusText(double value) {
    if (value >= 0.8) return 'Excellent';
    if (value >= 0.6) return 'Good';
    if (value >= 0.4) return 'Fair';
    return 'Low';
  }
}
