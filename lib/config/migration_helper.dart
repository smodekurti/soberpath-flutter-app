/// Migration helper for converting AppConstants to new configuration system
/// This file contains mappings and utilities to help with the refactoring process

/// Mapping of old AppConstants to new configuration paths
/// This helps with systematic replacement during refactoring
class MigrationHelper {
  static const Map<String, String> constantMappings = {
    // App Information
    'AppConstants.appName': 'AppConfig.info.name',
    'AppConstants.appTagline': 'AppConfig.info.tagline',
    
    // Colors - Primary
    'AppConstants.primaryPurple': 'context.colors.primary',
    'AppConstants.darkPurple': 'context.colors.primaryDark',
    'AppConstants.lightPurple': 'context.colors.primaryLight',
    'AppConstants.purpleGradientStart': 'context.colors.primary',
    'AppConstants.purpleGradientEnd': 'context.colors.primaryDark',
    'AppConstants.purpleGradient': 'context.colors.primaryGradient',
    
    // Colors - Status
    'AppConstants.successGreen': 'context.colors.success',
    'AppConstants.lightGreen': 'context.colors.successLight',
    'AppConstants.warningYellow': 'context.colors.warning',
    'AppConstants.lightYellow': 'context.colors.warningLight',
    'AppConstants.dangerRed': 'context.colors.error',
    'AppConstants.lightRed': 'context.colors.errorLight',
    'AppConstants.blueAccent': 'context.colors.secondary',
    'AppConstants.lightBlue': 'context.colors.secondaryLight',
    
    // Colors - Neutral
    'AppConstants.backgroundGray': 'context.colors.background',
    'AppConstants.cardWhite': 'context.colors.surface',
    'AppConstants.borderGray': 'context.colors.outline',
    'AppConstants.textGray': 'context.colors.onSurfaceVariant',
    'AppConstants.textDark': 'context.colors.onSurface',
    
    // Spacing
    'AppConstants.paddingSmall': 'context.spacing.small',
    'AppConstants.paddingMedium': 'context.spacing.medium',
    'AppConstants.paddingLarge': 'context.spacing.large',
    'AppConstants.paddingXLarge': 'context.spacing.extraLarge',
    
    // Border Radius
    'AppConstants.borderRadiusSmall': 'context.borders.small',
    'AppConstants.borderRadiusMedium': 'context.borders.medium',
    'AppConstants.borderRadiusLarge': 'context.borders.large',
    'AppConstants.borderRadiusXLarge': 'context.borders.extraLarge',
    
    // Font Sizes
    'AppConstants.fontSizeSmall': 'context.typography.bodySmall',
    'AppConstants.fontSizeMedium': 'context.typography.bodyMedium',
    'AppConstants.fontSizeLarge': 'context.typography.bodyLarge',
    'AppConstants.fontSizeXLarge': 'context.typography.titleMedium',
    'AppConstants.fontSizeXXLarge': 'context.typography.headlineSmall',
    'AppConstants.fontSizeTitle': 'context.typography.headlineLarge',
    'AppConstants.fontSizeDisplay': 'context.typography.displayMedium',
    
    // Animation Durations
    'AppConstants.animationFast': 'context.animations.fast',
    'AppConstants.animationMedium': 'context.animations.normal',
    'AppConstants.animationSlow': 'context.animations.slow',
    
    // Content
    'AppConstants.milestoneDays': 'context.content.milestoneDays',
    'AppConstants.healthBenefits': 'context.content.healthBenefits',
    'AppConstants.motivationalQuotes': 'context.content.motivationalQuotes',
    'AppConstants.crisisSupport': 'context.content.crisisSupport',
    'AppConstants.copingStrategies': 'context.content.copingStrategies',
    'AppConstants.defaultDailyCost': 'context.content.defaultDailyCost',
    'AppConstants.defaultSubstanceType': 'context.content.defaultSubstanceType',
    
    // Thresholds
    'AppConstants.moodPoor': 'context.content.moodPoor',
    'AppConstants.moodNeutral': 'context.content.moodNeutral',
    'AppConstants.cravingNone': 'context.content.cravingNone',
    'AppConstants.cravingWarning': 'context.content.cravingWarning',
  };
  
  /// Import statements that need to be updated
  static const Map<String, String> importMappings = {
    "import '../constants/app_constants.dart';": "import '../config/theme_extensions.dart';",
    "import 'constants/app_constants.dart';": "import 'config/theme_extensions.dart';",
    "import '../../constants/app_constants.dart';": "import '../../config/theme_extensions.dart';",
  };
  
  /// Common patterns that need special handling
  static const Map<String, String> specialPatterns = {
    'const EdgeInsets.all(AppConstants.': 'EdgeInsets.all(context.spacing.',
    'const EdgeInsets.symmetric(horizontal: AppConstants.': 'EdgeInsets.symmetric(horizontal: context.spacing.',
    'const EdgeInsets.symmetric(vertical: AppConstants.': 'EdgeInsets.symmetric(vertical: context.spacing.',
    'BorderRadius.circular(AppConstants.': 'BorderRadius.circular(context.borders.',
    'const SizedBox(width: AppConstants.': 'SizedBox(width: context.spacing.',
    'const SizedBox(height: AppConstants.': 'SizedBox(height: context.spacing.',
    'const TextStyle(fontSize: AppConstants.': 'TextStyle(fontSize: context.typography.',
    'const Duration(milliseconds: AppConstants.': 'context.animations.',
  };
  
  /// Files that require BuildContext parameter for context extensions
  static const List<String> contextRequiredFiles = [
    'screens/',
    'widgets/',
  ];
  
  /// Get replacement for a given AppConstants usage
  static String? getReplacement(String constantUsage) {
    return constantMappings[constantUsage];
  }
  
  /// Check if a file path requires BuildContext for configuration access
  static bool requiresContext(String filePath) {
    return contextRequiredFiles.any((pattern) => filePath.contains(pattern));
  }
  
  /// Generate import statement for a given file path
  static String getImportStatement(String filePath) {
    final depth = filePath.split('/').length - 2; // Adjust for lib/ directory
    final prefix = '../' * depth;
    return "import '${prefix}config/theme_extensions.dart';";
  }
}

/// Utility functions for the migration process
extension MigrationUtils on String {
  /// Replace AppConstants usage with new configuration system
  String migrateConstants() {
    String result = this;
    
    // Replace direct constant mappings
    MigrationHelper.constantMappings.forEach((oldConstant, newPath) {
      result = result.replaceAll(oldConstant, newPath);
    });
    
    // Handle special patterns
    MigrationHelper.specialPatterns.forEach((pattern, replacement) {
      if (result.contains(pattern)) {
        // This requires more complex replacement logic
        // For now, mark these for manual review
        result = result.replaceAll(pattern, '/* MIGRATE: $pattern */ $replacement');
      }
    });
    
    return result;
  }
  
  /// Update import statements
  String migrateImports() {
    String result = this;
    
    MigrationHelper.importMappings.forEach((oldImport, newImport) {
      result = result.replaceAll(oldImport, newImport);
    });
    
    return result;
  }
}
