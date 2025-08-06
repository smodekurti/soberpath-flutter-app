import 'package:flutter/material.dart';

/// Dynamic color system that changes based on theme mode
class DynamicThemeColors {
  final bool isDarkMode;
  
  const DynamicThemeColors({required this.isDarkMode});

  // Primary Colors
  Color get primary => const Color(0xFF9333EA);
  Color get primaryDark => isDarkMode ? const Color(0xFFB794F6) : const Color(0xFF7C3AED);
  Color get primaryLight => isDarkMode ? const Color(0xFF2D1B69) : const Color(0xFFF3E8FF);
  Color get primaryVariant => isDarkMode ? const Color(0xFFA78BFA) : const Color(0xFF8B5CF6);

  // Secondary Colors
  Color get secondary => isDarkMode ? const Color(0xFF60A5FA) : const Color(0xFF3B82F6);
  Color get secondaryDark => isDarkMode ? const Color(0xFF3B82F6) : const Color(0xFF1D4ED8);
  Color get secondaryLight => isDarkMode ? const Color(0xFF1E3A8A) : const Color(0xFFDBEAFE);

  // Status Colors
  Color get success => isDarkMode ? const Color(0xFF34D399) : const Color(0xFF10B981);
  Color get successLight => isDarkMode ? const Color(0xFF064E3B) : const Color(0xFFD1FAE5);
  Color get warning => isDarkMode ? const Color(0xFFFBBF24) : const Color(0xFFF59E0B);
  Color get warningLight => isDarkMode ? const Color(0xFF92400E) : const Color(0xFFFEF3C7);
  Color get error => isDarkMode ? const Color(0xFFF87171) : const Color(0xFFEF4444);
  Color get errorLight => isDarkMode ? const Color(0xFF7F1D1D) : const Color(0xFFFEE2E2);
  Color get info => isDarkMode ? const Color(0xFF60A5FA) : const Color(0xFF3B82F6);
  Color get infoLight => isDarkMode ? const Color(0xFF1E3A8A) : const Color(0xFFDBEAFE);

  // Background and Surface Colors
  Color get background => isDarkMode ? const Color(0xFF0F0F0F) : const Color(0xFFF9FAFB);
  Color get surface => isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFFFFFFF);
  Color get surfaceVariant => isDarkMode ? const Color(0xFF2D2D2D) : const Color(0xFFF3F4F6);
  Color get outline => isDarkMode ? const Color(0xFF404040) : const Color(0xFFE5E7EB);
  Color get outlineVariant => isDarkMode ? const Color(0xFF525252) : const Color(0xFFD1D5DB);
  Color get shadow => isDarkMode ? const Color(0xFF000000) : const Color(0xFF000000);

  // Text Colors
  Color get onPrimary => const Color(0xFFFFFFFF);
  Color get onSecondary => const Color(0xFFFFFFFF);
  Color get onSurface => isDarkMode ? const Color(0xFFE5E5E5) : const Color(0xFF1F2937);
  Color get onSurfaceVariant => isDarkMode ? const Color(0xFFA3A3A3) : const Color(0xFF6B7280);
  Color get onBackground => isDarkMode ? const Color(0xFFF5F5F5) : const Color(0xFF111827);
  Color get onError => const Color(0xFFFFFFFF);

  // Gradient Colors
  LinearGradient get primaryGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [primary, primaryDark],
      );

  LinearGradient get secondaryGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [secondary, secondaryDark],
      );

  LinearGradient get backgroundGradient => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          background,
          surface,
        ],
      );

  // Card and Component Colors
  Color get cardBackground => isDarkMode ? const Color(0xFF262626) : const Color(0xFFFFFFFF);
  Color get cardBorder => isDarkMode ? const Color(0xFF404040) : const Color(0xFFE5E7EB);
  Color get divider => isDarkMode ? const Color(0xFF404040) : const Color(0xFFE5E7EB);
  
  // Interactive Colors
  Color get hover => isDarkMode ? const Color(0xFF404040) : const Color(0xFFF3F4F6);
  Color get pressed => isDarkMode ? const Color(0xFF525252) : const Color(0xFFE5E7EB);
  Color get focus => primary.withValues(alpha: 0.2);
  Color get disabled => isDarkMode ? const Color(0xFF525252) : const Color(0xFFD1D5DB);
  Color get disabledText => isDarkMode ? const Color(0xFF737373) : const Color(0xFF9CA3AF);
}
