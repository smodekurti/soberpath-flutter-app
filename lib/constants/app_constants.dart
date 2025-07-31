import 'package:flutter/material.dart';

class AppConstants {
  // App Information
  static const String appName = 'SoberPath';
  static const String appTagline = 'Your recovery journey';

  // Colors
  static const Color primaryPurple = Color(0xFF9333EA);
  static const Color darkPurple = Color(0xFF7C3AED);
  static const Color lightPurple = Color(0xFFF3E8FF);
  static const Color purpleGradientStart = Color(0xFF9333EA);
  static const Color purpleGradientEnd = Color(0xFF7C3AED);

  static const Color successGreen = Color(0xFF10B981);
  static const Color lightGreen = Color(0xFFD1FAE5);
  static const Color warningYellow = Color(0xFFF59E0B);
  static const Color lightYellow = Color(0xFFFEF3C7);
  static const Color dangerRed = Color(0xFFEF4444);
  static const Color lightRed = Color(0xFFFEE2E2);

  static const Color blueAccent = Color(0xFF3B82F6);
  static const Color lightBlue = Color(0xFFDBEAFE);

  static const Color backgroundGray = Color(0xFFF9FAFB);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color borderGray = Color(0xFFE5E7EB);
  static const Color textGray = Color(0xFF6B7280);
  static const Color textDark = Color(0xFF1F2937);

  // Gradient Definitions
  static const LinearGradient purpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [purpleGradientStart, purpleGradientEnd],
  );

  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Border Radius
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusXLarge = 20.0;

  // Font Sizes
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeXLarge = 18.0;
  static const double fontSizeXXLarge = 24.0;
  static const double fontSizeTitle = 32.0;
  static const double fontSizeDisplay = 48.0;

  // Milestone Days
  static const List<int> milestoneDays = [1, 7, 30, 60, 90, 180, 365, 730];

  // Health Benefits
  static const Map<int, String> healthBenefits = {
    1: "Your body begins to detox and repair itself",
    7: "Better sleep patterns and increased energy levels",
    30: "Improved mental clarity and emotional stability",
    60: "Enhanced immune system and better physical health",
    90: "Significant reduction in health risks and improved mood",
    180: "Major improvements in liver function and cardiovascular health",
    365: "Dramatically reduced risk of serious health complications",
    730:
        "Your body has healed significantly, and you've built strong recovery habits"
  };

  // Motivational Quotes
  static const List<String> motivationalQuotes = [
    "You are stronger than your addiction.",
    "Recovery is not a race. You don't have to feel guilty if it takes you longer than you thought it would.",
    "Every day you choose recovery is a day you choose to love yourself.",
    "The strongest people are not those who show strength in front of us, but those who win battles we know nothing about.",
    "You are braver than you believe, stronger than you seem, and more loved than you know.",
    "Progress, not perfection. Every step forward counts.",
    "Your current situation is not your final destination. Keep going.",
    "Recovery is giving yourself permission to live."
  ];

  // Crisis Support Information
  static const Map<String, String> crisisSupport = {
    'National Suicide Prevention': '988',
    'Crisis Text Line': 'Text HOME to 741741',
    'SAMHSA Helpline': '1-800-662-4357',
  };

  // Coping Strategies
  static const List<Map<String, String>> copingStrategies = [
    {
      'title': 'Deep Breathing',
      'description': 'Take 5 deep breaths, hold for 4 seconds each'
    },
    {
      'title': 'Call Someone',
      'description': 'Reach out to a trusted friend or sponsor'
    },
    {
      'title': 'Go for a Walk',
      'description': 'Physical activity can help reduce cravings'
    },
    {
      'title': 'Practice Mindfulness',
      'description': 'Focus on the present moment and your surroundings'
    },
    {
      'title': 'Write in Journal',
      'description': 'Express your thoughts and feelings on paper'
    }
  ];

  // Default Values
  static const double defaultDailyCost = 15.0;
  static const String defaultSubstanceType = 'alcohol';

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  static const int moodPoor = 3;
  static const int moodNeutral = 6;
  static const int cravingNone = 3;
  static const int cravingWarning = 6;
}
