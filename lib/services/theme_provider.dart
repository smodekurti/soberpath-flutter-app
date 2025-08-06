import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/theme_extensions.dart';

enum AppThemeMode { light, dark, system }

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  
  AppThemeMode _themeMode = AppThemeMode.system;
  bool _isSystemDarkMode = false;
  
  ThemeProvider() {
    _loadThemeMode();
    _listenToSystemTheme();
  }
  
  AppThemeMode get themeMode => _themeMode;
  bool get isSystemDarkMode => _isSystemDarkMode;
  
  /// Get the current effective theme (resolves system mode)
  bool get isDarkMode {
    switch (_themeMode) {
      case AppThemeMode.light:
        return false;
      case AppThemeMode.dark:
        return true;
      case AppThemeMode.system:
        return _isSystemDarkMode;
    }
  }
  
  /// Get the appropriate ThemeData based on current mode
  ThemeData get currentTheme {
    return isDarkMode ? SoberPathThemeData.darkTheme() : SoberPathThemeData.lightTheme();
  }
  
  /// Set theme mode and persist to storage
  Future<void> setThemeMode(AppThemeMode mode) async {
    if (_themeMode == mode) return;
    
    _themeMode = mode;
    await _saveThemeMode();
    
    // Add haptic feedback for theme switching
    HapticFeedback.lightImpact();
    
    notifyListeners();
  }
  
  /// Toggle between light and dark (skips system mode)
  Future<void> toggleTheme() async {
    final newMode = isDarkMode ? AppThemeMode.light : AppThemeMode.dark;
    await setThemeMode(newMode);
  }
  
  /// Load theme mode from storage
  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeModeString = prefs.getString(_themeKey);
      
      if (themeModeString != null) {
        _themeMode = AppThemeMode.values.firstWhere(
          (mode) => mode.toString() == themeModeString,
          orElse: () => AppThemeMode.system,
        );
      }
    } catch (e) {
      // If loading fails, default to system mode
      _themeMode = AppThemeMode.system;
    }
    
    notifyListeners();
  }
  
  /// Save theme mode to storage
  Future<void> _saveThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, _themeMode.toString());
    } catch (e) {
      // Handle save error silently
      debugPrint('Failed to save theme mode: $e');
    }
  }
  
  /// Listen to system theme changes
  void _listenToSystemTheme() {
    final window = WidgetsBinding.instance.platformDispatcher;
    _isSystemDarkMode = window.platformBrightness == Brightness.dark;
    
    window.onPlatformBrightnessChanged = () {
      final newSystemDarkMode = window.platformBrightness == Brightness.dark;
      if (_isSystemDarkMode != newSystemDarkMode) {
        _isSystemDarkMode = newSystemDarkMode;
        if (_themeMode == AppThemeMode.system) {
          notifyListeners();
        }
      }
    };
  }
  
  /// Get theme mode display name
  String getThemeModeDisplayName(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.system:
        return 'System';
    }
  }
  
  /// Get theme mode icon
  IconData getThemeModeIcon(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return Icons.light_mode;
      case AppThemeMode.dark:
        return Icons.dark_mode;
      case AppThemeMode.system:
        return Icons.brightness_auto;
    }
  }
}
