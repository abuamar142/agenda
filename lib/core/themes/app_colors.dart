import 'package:flutter/material.dart';

class AppColors {
  // Base Colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const MaterialColor blue = Colors.blue;
  static const Color transparent = Colors.transparent;

  // Primary Colors
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color primaryLight = Color(0xFFBBDEFB);

  // Secondary Colors
  static const Color secondary = Color(0xFF03DAC6);
  static const Color secondaryDark = Color(0xFF018786);
  static const Color secondaryLight = Color(0xFFB2DFDB);

  // Background Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color textOnPrimary = Colors.white;
  static const Color textOnSecondary = Colors.white;

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Opacity Colors
  static Color blackWithOpacity10 = Colors.black.withValues(alpha: 0.1);
  static Color whiteWithOpacity70 = Colors.white.withValues(alpha: 0.7);
  static Color whiteWithOpacity80 = Colors.white.withValues(alpha: 0.8);
  static Color whiteWithOpacity90 = Colors.white.withValues(alpha: 0.9);
  static Color successWithOpacity10 = success.withValues(alpha: 0.1);

  // Calendar Colors
  static const Color calendarToday = Color(0xFF2196F3);
  static const Color calendarSelected = Color(0xFF1976D2);
  static const Color calendarWeekend = Color(0xFFE0E0E0);
  static const Color calendarEvent = Color(0xFF4CAF50);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  // Utility Methods
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }
}
