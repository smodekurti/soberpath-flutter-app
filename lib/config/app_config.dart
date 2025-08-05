import 'package:flutter/material.dart';

/// Centralized configuration system for the SoberPath app
/// All visual, behavioral, and content configurations are defined here
class AppConfig {
  // Private constructor to prevent instantiation
  AppConfig._();

  /// App Information Configuration
  static const AppInfo info = AppInfo();

  /// Color Configuration
  static const AppColors colors = AppColors();

  /// Typography Configuration
  static const AppTypography typography = AppTypography();

  /// Spacing Configuration
  static const AppSpacing spacing = AppSpacing();

  /// Border Configuration
  static const AppBorders borders = AppBorders();

  /// Animation Configuration
  static const AppAnimations animations = AppAnimations();

  /// Content Configuration
  static const AppContent content = AppContent();

  /// Layout Configuration
  static const AppLayout layout = AppLayout();

  /// Notification Configuration
  static const AppNotifications notifications = AppNotifications();

  /// Theme Configuration
  static const AppTheme theme = AppTheme();
}

/// App Information and Metadata
class AppInfo {
  const AppInfo();

  String get name => 'SoberPath';
  String get tagline => 'Your recovery journey';
  String get version => '3.0.0';
  String get description => 'A comprehensive sobriety support app for recovery journey';
}

/// Color Palette Configuration
class AppColors {
  const AppColors();

  // Primary Colors
  Color get primary => const Color(0xFF9333EA);
  Color get primaryDark => const Color(0xFF7C3AED);
  Color get primaryLight => const Color(0xFFF3E8FF);
  Color get primaryVariant => const Color(0xFF8B5CF6);

  // Secondary Colors
  Color get secondary => const Color(0xFF3B82F6);
  Color get secondaryDark => const Color(0xFF1D4ED8);
  Color get secondaryLight => const Color(0xFFDBEAFE);

  // Status Colors
  Color get success => const Color(0xFF10B981);
  Color get successLight => const Color(0xFFD1FAE5);
  Color get warning => const Color(0xFFF59E0B);
  Color get warningLight => const Color(0xFFFEF3C7);
  Color get error => const Color(0xFFEF4444);
  Color get errorLight => const Color(0xFFFEE2E2);
  Color get info => const Color(0xFF3B82F6);
  Color get infoLight => const Color(0xFFDBEAFE);

  // Neutral Colors
  Color get background => const Color(0xFFF9FAFB);
  Color get surface => const Color(0xFFFFFFFF);
  Color get surfaceVariant => const Color(0xFFF3F4F6);
  Color get outline => const Color(0xFFE5E7EB);
  Color get outlineVariant => const Color(0xFFD1D5DB);

  // Text Colors
  Color get onPrimary => const Color(0xFFFFFFFF);
  Color get onSecondary => const Color(0xFFFFFFFF);
  Color get onSurface => const Color(0xFF1F2937);
  Color get onSurfaceVariant => const Color(0xFF6B7280);
  Color get onBackground => const Color(0xFF111827);
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

  LinearGradient get successGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [success, const Color(0xFF059669)],
      );

  // Shadow Colors
  Color get shadow => const Color(0x1A000000);
  Color get shadowLight => const Color(0x0D000000);
  Color get shadowDark => const Color(0x26000000);
}

/// Typography Configuration
class AppTypography {
  const AppTypography();

  // Font Family
  String get fontFamily => 'Inter';
  String get displayFontFamily => 'Inter';

  // Font Sizes
  double get displayLarge => 57.0;
  double get displayMedium => 45.0;
  double get displaySmall => 36.0;
  double get headlineLarge => 32.0;
  double get headlineMedium => 28.0;
  double get headlineSmall => 24.0;
  double get titleLarge => 22.0;
  double get titleMedium => 16.0;
  double get titleSmall => 14.0;
  double get bodyLarge => 16.0;
  double get bodyMedium => 14.0;
  double get bodySmall => 12.0;
  double get labelLarge => 14.0;
  double get labelMedium => 12.0;
  double get labelSmall => 11.0;

  // Font Weights
  FontWeight get light => FontWeight.w300;
  FontWeight get regular => FontWeight.w400;
  FontWeight get medium => FontWeight.w500;
  FontWeight get semiBold => FontWeight.w600;
  FontWeight get bold => FontWeight.w700;
  FontWeight get extraBold => FontWeight.w800;

  // Line Heights
  double get lineHeightTight => 1.2;
  double get lineHeightNormal => 1.4;
  double get lineHeightRelaxed => 1.6;
  double get lineHeightLoose => 1.8;

  // Letter Spacing
  double get letterSpacingTight => -0.5;
  double get letterSpacingNormal => 0.0;
  double get letterSpacingWide => 0.5;
  double get letterSpacingWider => 1.0;
}

/// Spacing Configuration
class AppSpacing {
  const AppSpacing();

  // Base spacing unit (8px)
  double get unit => 8.0;

  // Spacing Scale
  double get xs => unit * 0.5; // 4px
  double get sm => unit * 1.0; // 8px
  double get md => unit * 2.0; // 16px
  double get lg => unit * 3.0; // 24px
  double get xl => unit * 4.0; // 32px
  double get xxl => unit * 5.0; // 40px
  double get xxxl => unit * 6.0; // 48px

  // Semantic Spacing
  double get tiny => xs;
  double get small => sm;
  double get medium => md;
  double get large => lg;
  double get extraLarge => xl;
  double get huge => xxl;
  double get massive => xxxl;

  // Component Specific
  double get cardPadding => md;
  double get screenPadding => lg;
  double get buttonPadding => md;
  double get inputPadding => md;
  double get listItemPadding => md;
  double get sectionSpacing => xl;
}

/// Border Configuration
class AppBorders {
  const AppBorders();

  // Border Radius
  double get none => 0.0;
  double get xs => 4.0;
  double get sm => 8.0;
  double get md => 12.0;
  double get lg => 16.0;
  double get xl => 20.0;
  double get xxl => 24.0;
  double get full => 9999.0;

  // Semantic Border Radius
  double get small => sm;
  double get medium => md;
  double get large => lg;
  double get extraLarge => xl;
  double get circular => full;

  // Border Widths
  double get thin => 1.0;
  double get mediumBorder => 2.0;
  double get thick => 4.0;

  // Component Specific
  double get button => lg;
  double get card => xl;
  double get input => md;
  double get dialog => lg;
  double get bottomSheet => lg;
}

/// Animation Configuration
class AppAnimations {
  const AppAnimations();

  // Duration
  Duration get instant => const Duration(milliseconds: 0);
  Duration get fast => const Duration(milliseconds: 150);
  Duration get normal => const Duration(milliseconds: 300);
  Duration get slow => const Duration(milliseconds: 500);
  Duration get slower => const Duration(milliseconds: 750);
  Duration get slowest => const Duration(milliseconds: 1000);

  // Curves
  Curve get easeIn => Curves.easeIn;
  Curve get easeOut => Curves.easeOut;
  Curve get easeInOut => Curves.easeInOut;
  Curve get bounceIn => Curves.bounceIn;
  Curve get bounceOut => Curves.bounceOut;
  Curve get elasticIn => Curves.elasticIn;
  Curve get elasticOut => Curves.elasticOut;

  // Component Specific
  Duration get pageTransition => normal;
  Duration get dialogTransition => fast;
  Duration get buttonPress => fast;
  Duration get loading => normal;
  Duration get splash => slow;
}

/// Content Configuration
class AppContent {
  const AppContent();

  // Milestone Days
  List<int> get milestoneDays => const [1, 7, 30, 60, 90, 180, 365, 730];

  // Health Benefits
  Map<int, String> get healthBenefits => const {
        1: "Your body begins to detox and repair itself",
        7: "Better sleep patterns and increased energy levels",
        30: "Improved mental clarity and emotional stability",
        60: "Enhanced immune system and better physical health",
        90: "Significant reduction in health risks and improved mood",
        180: "Major improvements in liver function and cardiovascular health",
        365: "Dramatically reduced risk of serious health complications",
        730: "Your body has healed significantly, and you've built strong recovery habits"
      };

  // Motivational Quotes
  List<String> get motivationalQuotes => const [
        "You are stronger than your addiction.",
        "Recovery is not a race. You don't have to feel guilty if it takes you longer than you thought it would.",
        "Every day you choose recovery is a day you choose to love yourself.",
        "The strongest people are not those who show strength in front of us, but those who win battles we know nothing about.",
        "You are braver than you believe, stronger than you seem, and more loved than you know.",
        "Progress, not perfection. Every step forward counts.",
        "Your current situation is not your final destination. Keep going.",
        "Recovery is giving yourself permission to live.",
        "One day at a time, one step at a time, one breath at a time.",
        "Your recovery is worth fighting for every single day."
      ];

  // Crisis Support Information
  Map<String, String> get crisisSupport => const {
        'National Suicide Prevention': '988',
        'Crisis Text Line': 'Text HOME to 741741',
        'SAMHSA Helpline': '1-800-662-4357',
      };

  // Coping Strategies
  List<Map<String, String>> get copingStrategies => const [
        {
          'title': 'Deep Breathing',
          'description': 'Take 5 deep breaths, hold for 4 seconds each',
          'icon': 'air'
        },
        {
          'title': 'Call Someone',
          'description': 'Reach out to a trusted friend or sponsor',
          'icon': 'phone'
        },
        {
          'title': 'Go for a Walk',
          'description': 'Physical activity can help reduce cravings',
          'icon': 'directions_walk'
        },
        {
          'title': 'Practice Mindfulness',
          'description': 'Focus on the present moment and your surroundings',
          'icon': 'self_improvement'
        },
        {
          'title': 'Write in Journal',
          'description': 'Express your thoughts and feelings on paper',
          'icon': 'edit_note'
        }
      ];

  // Default Values
  double get defaultDailyCost => 15.0;
  String get defaultSubstanceType => 'alcohol';

  // Mood and Craving Thresholds
  int get moodPoor => 3;
  int get moodNeutral => 6;
  int get moodGood => 8;
  int get cravingNone => 3;
  int get cravingWarning => 6;
  int get cravingHigh => 8;
}

/// Layout Configuration
class AppLayout {
  const AppLayout();

  // Breakpoints
  double get mobileBreakpoint => 480.0;
  double get tabletBreakpoint => 768.0;
  double get desktopBreakpoint => 1024.0;

  // Max Widths
  double get maxContentWidth => 1200.0;
  double get maxCardWidth => 400.0;
  double get maxDialogWidth => 560.0;

  // Heights
  double get appBarHeight => 56.0;
  double get bottomNavHeight => 80.0;
  double get buttonHeight => 48.0;
  double get inputHeight => 56.0;
  double get listItemHeight => 72.0;

  // Grid
  int get gridColumns => 12;
  double get gridGutter => 16.0;

  // Component Sizes
  double get iconSizeSmall => 16.0;
  double get iconSizeMedium => 24.0;
  double get iconSizeLarge => 32.0;
  double get avatarSizeSmall => 32.0;
  double get avatarSizeMedium => 48.0;
  double get avatarSizeLarge => 64.0;
}

/// Notification Configuration
class AppNotifications {
  const AppNotifications();

  // Notification IDs
  int get dailyReminderBaseId => 1000;
  int get milestoneBaseId => 2000;
  int get motivationalBaseId => 3000;
  int get emergencyId => 9999;

  // Default Times
  TimeOfDay get defaultDailyReminderTime => const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay get defaultEveningReminderTime => const TimeOfDay(hour: 20, minute: 0);

  // Notification Channels
  String get dailyReminderChannelId => 'daily_reminders';
  String get milestoneChannelId => 'milestones';
  String get motivationalChannelId => 'motivational';
  String get emergencyChannelId => 'emergency';

  // Notification Titles
  String get dailyReminderTitle => 'Daily Check-in Reminder';
  String get milestoneTitle => 'Milestone Achieved!';
  String get motivationalTitle => 'Stay Strong';
  String get emergencyTitle => 'Emergency Support';
}

/// Theme Configuration
class AppTheme {
  const AppTheme();

  // Theme Mode
  ThemeMode get defaultThemeMode => ThemeMode.system;

  // Material 3 Settings
  bool get useMaterial3 => true;
  bool get useAdaptiveTheme => true;

  // Elevation
  double get elevationNone => 0.0;
  double get elevationLow => 1.0;
  double get elevationMedium => 3.0;
  double get elevationHigh => 6.0;
  double get elevationVeryHigh => 12.0;

  // Opacity
  double get disabledOpacity => 0.38;
  double get hoverOpacity => 0.08;
  double get focusOpacity => 0.12;
  double get pressedOpacity => 0.12;
  double get draggedOpacity => 0.16;
}
