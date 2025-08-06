import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_config.dart';
import 'dynamic_theme_colors.dart';
import '../services/theme_provider.dart';

/// Extension methods to easily access configuration values throughout the app
extension AppConfigExtension on BuildContext {
  /// Access dynamic theme-aware colors
  DynamicThemeColors get colors {
    final themeProvider = Provider.of<ThemeProvider>(this, listen: true);
    return DynamicThemeColors(isDarkMode: themeProvider.isDarkMode);
  }
  
  /// Access static app configuration (for non-color properties)
  AppColors get staticColors => AppConfig.colors;
  AppTypography get typography => AppConfig.typography;
  AppSpacing get spacing => AppConfig.spacing;
  AppBorders get borders => AppConfig.borders;
  AppAnimations get animations => AppConfig.animations;
  AppContent get content => AppConfig.content;
  AppLayout get layout => AppConfig.layout;
  AppNotifications get notifications => AppConfig.notifications;
  AppTheme get appTheme => AppConfig.theme;
  AppInfo get appInfo => AppConfig.info;

  /// Quick access to commonly used values
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  
  /// Responsive helpers
  bool get isMobile => MediaQuery.of(this).size.width < layout.tabletBreakpoint;
  bool get isTablet => MediaQuery.of(this).size.width >= layout.tabletBreakpoint && 
                      MediaQuery.of(this).size.width < layout.desktopBreakpoint;
  bool get isDesktop => MediaQuery.of(this).size.width >= layout.desktopBreakpoint;
  
  /// Screen dimensions
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  
  /// Safe area
  EdgeInsets get safeArea => MediaQuery.of(this).padding;
  double get statusBarHeight => safeArea.top;
  double get bottomSafeArea => safeArea.bottom;
}

/// Custom theme data that extends Material Theme with app-specific configurations
class SoberPathThemeData {
  static ThemeData lightTheme() {
    const colors = AppConfig.colors;
    const typography = AppConfig.typography;
    const spacing = AppConfig.spacing;
    const borders = AppConfig.borders;
    const theme = AppConfig.theme;

    return ThemeData(
      useMaterial3: theme.useMaterial3,
      colorScheme: ColorScheme.light(
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        secondary: colors.secondary,
        onSecondary: colors.onSecondary,
        surface: colors.surface,
        onSurface: colors.onSurface,
        surfaceContainerLowest: colors.background, // Replacing deprecated background
        error: colors.error,
        onError: colors.onError,
        outline: colors.outline,
        outlineVariant: colors.outlineVariant,
        surfaceContainerHighest: colors.surfaceVariant,
        onSurfaceVariant: colors.onSurfaceVariant,
      ),
      
      // Typography
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: typography.displayLarge,
          fontWeight: typography.bold,
          fontFamily: typography.displayFontFamily,
          letterSpacing: typography.letterSpacingTight,
        ),
        displayMedium: TextStyle(
          fontSize: typography.displayMedium,
          fontWeight: typography.bold,
          fontFamily: typography.displayFontFamily,
          letterSpacing: typography.letterSpacingTight,
        ),
        displaySmall: TextStyle(
          fontSize: typography.displaySmall,
          fontWeight: typography.bold,
          fontFamily: typography.displayFontFamily,
          letterSpacing: typography.letterSpacingNormal,
        ),
        headlineLarge: TextStyle(
          fontSize: typography.headlineLarge,
          fontWeight: typography.semiBold,
          fontFamily: typography.fontFamily,
          letterSpacing: typography.letterSpacingNormal,
        ),
        headlineMedium: TextStyle(
          fontSize: typography.headlineMedium,
          fontWeight: typography.semiBold,
          fontFamily: typography.fontFamily,
          letterSpacing: typography.letterSpacingNormal,
        ),
        headlineSmall: TextStyle(
          fontSize: typography.headlineSmall,
          fontWeight: typography.semiBold,
          fontFamily: typography.fontFamily,
          letterSpacing: typography.letterSpacingNormal,
        ),
        titleLarge: TextStyle(
          fontSize: typography.titleLarge,
          fontWeight: typography.medium,
          fontFamily: typography.fontFamily,
          letterSpacing: typography.letterSpacingNormal,
        ),
        titleMedium: TextStyle(
          fontSize: typography.titleMedium,
          fontWeight: typography.medium,
          fontFamily: typography.fontFamily,
          letterSpacing: typography.letterSpacingNormal,
        ),
        titleSmall: TextStyle(
          fontSize: typography.titleSmall,
          fontWeight: typography.medium,
          fontFamily: typography.fontFamily,
          letterSpacing: typography.letterSpacingNormal,
        ),
        bodyLarge: TextStyle(
          fontSize: typography.bodyLarge,
          fontWeight: typography.regular,
          fontFamily: typography.fontFamily,
          letterSpacing: typography.letterSpacingNormal,
          height: typography.lineHeightNormal,
        ),
        bodyMedium: TextStyle(
          fontSize: typography.bodyMedium,
          fontWeight: typography.regular,
          fontFamily: typography.fontFamily,
          letterSpacing: typography.letterSpacingNormal,
          height: typography.lineHeightNormal,
        ),
        bodySmall: TextStyle(
          fontSize: typography.bodySmall,
          fontWeight: typography.regular,
          fontFamily: typography.fontFamily,
          letterSpacing: typography.letterSpacingNormal,
          height: typography.lineHeightNormal,
        ),
        labelLarge: TextStyle(
          fontSize: typography.labelLarge,
          fontWeight: typography.medium,
          fontFamily: typography.fontFamily,
          letterSpacing: typography.letterSpacingWide,
        ),
        labelMedium: TextStyle(
          fontSize: typography.labelMedium,
          fontWeight: typography.medium,
          fontFamily: typography.fontFamily,
          letterSpacing: typography.letterSpacingWide,
        ),
        labelSmall: TextStyle(
          fontSize: typography.labelSmall,
          fontWeight: typography.medium,
          fontFamily: typography.fontFamily,
          letterSpacing: typography.letterSpacingWide,
        ),
      ),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: theme.elevationNone,
        surfaceTintColor: Colors.transparent,
        foregroundColor: colors.onSurface,
        titleTextStyle: TextStyle(
          fontSize: typography.titleLarge,
          fontWeight: typography.semiBold,
          fontFamily: typography.fontFamily,
          color: colors.onSurface,
        ),
        iconTheme: IconThemeData(
          color: colors.onSurface,
          size: AppConfig.layout.iconSizeMedium,
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          elevation: theme.elevationLow,
          padding: EdgeInsets.symmetric(
            horizontal: spacing.large,
            vertical: spacing.medium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borders.button),
          ),
          textStyle: TextStyle(
            fontSize: typography.bodyLarge,
            fontWeight: typography.semiBold,
            fontFamily: typography.fontFamily,
          ),
          minimumSize: Size.fromHeight(AppConfig.layout.buttonHeight),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primary,
          side: BorderSide(
            color: colors.primary,
            width: borders.thin,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: spacing.large,
            vertical: spacing.medium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borders.button),
          ),
          textStyle: TextStyle(
            fontSize: typography.bodyLarge,
            fontWeight: typography.semiBold,
            fontFamily: typography.fontFamily,
          ),
          minimumSize: Size.fromHeight(AppConfig.layout.buttonHeight),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          padding: EdgeInsets.symmetric(
            horizontal: spacing.medium,
            vertical: spacing.small,
          ),
          textStyle: TextStyle(
            fontSize: typography.bodyMedium,
            fontWeight: typography.medium,
            fontFamily: typography.fontFamily,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borders.input),
          borderSide: BorderSide(
            color: colors.outline,
            width: borders.thin,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borders.input),
          borderSide: BorderSide(
            color: colors.outline,
            width: borders.thin,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borders.input),
          borderSide: BorderSide(
            color: colors.primary,
            width: borders.mediumBorder,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borders.input),
          borderSide: BorderSide(
            color: colors.error,
            width: borders.thin,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borders.input),
          borderSide: BorderSide(
            color: colors.error,
            width: borders.mediumBorder,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: spacing.medium,
          vertical: spacing.medium,
        ),
        hintStyle: TextStyle(
          color: colors.onSurfaceVariant,
          fontSize: typography.bodyMedium,
          fontFamily: typography.fontFamily,
        ),
        labelStyle: TextStyle(
          color: colors.onSurfaceVariant,
          fontSize: typography.bodyMedium,
          fontFamily: typography.fontFamily,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: theme.elevationLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borders.card),
        ),
        color: colors.surface,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.all(spacing.small),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.surface,
        selectedItemColor: colors.primary,
        unselectedItemColor: colors.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: theme.elevationMedium,
        selectedLabelStyle: TextStyle(
          fontSize: typography.labelSmall,
          fontWeight: typography.semiBold,
          fontFamily: typography.fontFamily,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: typography.labelSmall,
          fontWeight: typography.medium,
          fontFamily: typography.fontFamily,
        ),
      ),

      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: colors.primary,
        inactiveTrackColor: colors.outline,
        thumbColor: colors.primary,
        overlayColor: colors.primary.withValues(alpha: theme.hoverOpacity),
        thumbShape: RoundSliderThumbShape(
          enabledThumbRadius: spacing.small + 2,
        ),
        overlayShape: RoundSliderOverlayShape(
          overlayRadius: spacing.medium + 4,
        ),
        trackHeight: 4.0,
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: theme.elevationHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borders.dialog),
        ),
        titleTextStyle: TextStyle(
          fontSize: typography.headlineSmall,
          fontWeight: typography.semiBold,
          fontFamily: typography.fontFamily,
          color: colors.onSurface,
        ),
        contentTextStyle: TextStyle(
          fontSize: typography.bodyMedium,
          fontWeight: typography.regular,
          fontFamily: typography.fontFamily,
          color: colors.onSurface,
          height: typography.lineHeightNormal,
        ),
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: theme.elevationHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(borders.bottomSheet),
          ),
        ),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: colors.outline,
        thickness: borders.thin,
        space: spacing.medium,
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: colors.onSurface,
        size: AppConfig.layout.iconSizeMedium,
      ),

      // Primary Icon Theme
      primaryIconTheme: IconThemeData(
        color: colors.primary,
        size: AppConfig.layout.iconSizeMedium,
      ),
    );
  }

  static ThemeData darkTheme() {
    const darkColors = DynamicThemeColors(isDarkMode: true);
    const typography = AppConfig.typography;
    const spacing = AppConfig.spacing;
    const borders = AppConfig.borders;
    const theme = AppConfig.theme;

    return ThemeData(
      useMaterial3: theme.useMaterial3,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: darkColors.primary,
        onPrimary: darkColors.onPrimary,
        secondary: darkColors.secondary,
        onSecondary: darkColors.onSecondary,
        surface: darkColors.surface,
        onSurface: darkColors.onSurface,
        surfaceContainerLowest: darkColors.background,
        error: darkColors.error,
        onError: darkColors.onError,
        outline: darkColors.outline,
        outlineVariant: darkColors.outlineVariant,
        surfaceContainerHighest: darkColors.surfaceVariant,
        onSurfaceVariant: darkColors.onSurfaceVariant,
      ),
      
      // Use the same typography and component themes as light theme
      // but with dark color scheme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: typography.displayLarge,
          fontWeight: typography.bold,
          fontFamily: typography.displayFontFamily,
          letterSpacing: typography.letterSpacingTight,
          color: darkColors.onSurface,
        ),
        displayMedium: TextStyle(
          fontSize: typography.displayMedium,
          fontWeight: typography.bold,
          fontFamily: typography.displayFontFamily,
          letterSpacing: typography.letterSpacingTight,
          color: darkColors.onSurface,
        ),
        displaySmall: TextStyle(
          fontSize: typography.displaySmall,
          fontWeight: typography.bold,
          fontFamily: typography.displayFontFamily,
          letterSpacing: typography.letterSpacingNormal,
          color: darkColors.onSurface,
        ),
        headlineLarge: TextStyle(
          fontSize: typography.headlineLarge,
          fontWeight: typography.semiBold,
          fontFamily: typography.fontFamily,
          letterSpacing: typography.letterSpacingNormal,
          color: darkColors.onSurface,
        ),
        headlineMedium: TextStyle(
          fontSize: typography.headlineMedium,
          fontWeight: typography.semiBold,
          fontFamily: typography.fontFamily,
          letterSpacing: typography.letterSpacingNormal,
          color: darkColors.onSurface,
        ),
        headlineSmall: TextStyle(
          fontSize: typography.headlineSmall,
          fontWeight: typography.semiBold,
          fontFamily: typography.fontFamily,
          letterSpacing: typography.letterSpacingNormal,
          color: darkColors.onSurface,
        ),
        titleLarge: TextStyle(
          fontSize: typography.titleLarge,
          fontWeight: typography.semiBold,
          fontFamily: typography.fontFamily,
          letterSpacing: typography.letterSpacingNormal,
          color: darkColors.onSurface,
        ),
        titleMedium: TextStyle(
          fontSize: typography.titleMedium,
          fontWeight: typography.medium,
          fontFamily: typography.fontFamily,
          letterSpacing: typography.letterSpacingNormal,
          color: darkColors.onSurface,
        ),
        titleSmall: TextStyle(
          fontSize: typography.titleSmall,
          fontWeight: typography.medium,
          fontFamily: typography.fontFamily,
          letterSpacing: typography.letterSpacingNormal,
          color: darkColors.onSurface,
        ),
        bodyLarge: TextStyle(
          fontSize: typography.bodyLarge,
          fontWeight: typography.regular,
          fontFamily: typography.fontFamily,
          letterSpacing: typography.letterSpacingNormal,
          height: typography.lineHeightNormal,
          color: darkColors.onSurface,
        ),
        bodyMedium: TextStyle(
          fontSize: typography.bodyMedium,
          fontWeight: typography.regular,
          fontFamily: typography.fontFamily,
          letterSpacing: typography.letterSpacingNormal,
          height: typography.lineHeightNormal,
          color: darkColors.onSurface,
        ),
        bodySmall: TextStyle(
          fontSize: typography.bodySmall,
          fontWeight: typography.regular,
          fontFamily: typography.fontFamily,
          letterSpacing: typography.letterSpacingNormal,
          height: typography.lineHeightNormal,
          color: darkColors.onSurfaceVariant,
        ),
        labelLarge: TextStyle(
          fontSize: typography.labelLarge,
          fontWeight: typography.medium,
          fontFamily: typography.fontFamily,
          letterSpacing: typography.letterSpacingWide,
          color: darkColors.onSurface,
        ),
        labelMedium: TextStyle(
          fontSize: typography.labelMedium,
          fontWeight: typography.medium,
          fontFamily: typography.fontFamily,
          letterSpacing: typography.letterSpacingWide,
          color: darkColors.onSurface,
        ),
        labelSmall: TextStyle(
          fontSize: typography.labelSmall,
          fontWeight: typography.medium,
          fontFamily: typography.fontFamily,
          letterSpacing: typography.letterSpacingWide,
          color: darkColors.onSurfaceVariant,
        ),
      ),
      
      // Dark theme scaffold and app bar
      scaffoldBackgroundColor: darkColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: darkColors.surface,
        foregroundColor: darkColors.onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: typography.titleLarge,
          fontWeight: typography.semiBold,
          fontFamily: typography.fontFamily,
          color: darkColors.onSurface,
        ),
      ),
      
      // Card theme for dark mode
      cardTheme: CardTheme(
        color: darkColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: theme.elevationMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borders.medium),
        ),
      ),
      
      // Other component themes with dark colors
      iconTheme: IconThemeData(
        color: darkColors.onSurface,
        size: AppConfig.layout.iconSizeMedium,
      ),
      
      primaryIconTheme: IconThemeData(
        color: darkColors.primary,
        size: AppConfig.layout.iconSizeMedium,
      ),
    );
  }
}

/// Widget extension for easy styling
extension WidgetStyling on Widget {
  /// Add padding using configuration values
  Widget paddingAll(double value) => Padding(
        padding: EdgeInsets.all(value),
        child: this,
      );

  Widget paddingSymmetric({double? horizontal, double? vertical}) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal ?? 0,
          vertical: vertical ?? 0,
        ),
        child: this,
      );

  Widget paddingOnly({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) =>
      Padding(
        padding: EdgeInsets.only(
          left: left ?? 0,
          top: top ?? 0,
          right: right ?? 0,
          bottom: bottom ?? 0,
        ),
        child: this,
      );

  /// Add margin using configuration values
  Widget marginAll(double value) => Container(
        margin: EdgeInsets.all(value),
        child: this,
      );

  Widget marginSymmetric({double? horizontal, double? vertical}) => Container(
        margin: EdgeInsets.symmetric(
          horizontal: horizontal ?? 0,
          vertical: vertical ?? 0,
        ),
        child: this,
      );

  Widget marginOnly({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) =>
      Container(
        margin: EdgeInsets.only(
          left: left ?? 0,
          top: top ?? 0,
          right: right ?? 0,
          bottom: bottom ?? 0,
        ),
        child: this,
      );

  /// Add border radius
  Widget borderRadius(double radius) => ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: this,
      );

  /// Add elevation/shadow
  Widget elevation(double elevation) => Material(
        elevation: elevation,
        child: this,
      );
}
