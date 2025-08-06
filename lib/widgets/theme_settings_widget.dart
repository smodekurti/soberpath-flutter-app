import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/theme_provider.dart';
import '../config/theme_extensions.dart';
import '../widgets/safe_text.dart';

class ThemeSettingsWidget extends StatelessWidget {
  const ThemeSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          margin: EdgeInsets.all(context.spacing.medium),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(context.borders.medium),
            boxShadow: [
              BoxShadow(
                color: context.colors.shadow.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(context.spacing.large),
                child: Row(
                  children: [
                    Icon(
                      Icons.palette,
                      color: context.colors.primary,
                      size: context.spacing.large,
                    ),
                    SizedBox(width: context.spacing.medium),
                    SafeText(
                      'Theme',
                      style: TextStyle(
                        fontSize: context.typography.titleLarge,
                        fontWeight: FontWeight.w600,
                        color: context.colors.onSurface,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              
              // Theme options
              ...AppThemeMode.values.map((mode) => _buildThemeOption(
                context,
                themeProvider,
                mode,
              )),
              
              SizedBox(height: context.spacing.small),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    ThemeProvider themeProvider,
    AppThemeMode mode,
  ) {
    final isSelected = themeProvider.themeMode == mode;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      margin: EdgeInsets.symmetric(
        horizontal: context.spacing.medium,
        vertical: context.spacing.small / 2,
      ),
      decoration: BoxDecoration(
        color: isSelected 
            ? context.colors.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(context.borders.small),
        border: isSelected
            ? Border.all(
                color: context.colors.primary.withValues(alpha: 0.5),
                width: 1.5,
              )
            : null,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.spacing.large,
          vertical: context.spacing.small,
        ),
        leading: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(context.spacing.small),
          decoration: BoxDecoration(
            color: isSelected 
                ? context.colors.primary
                : context.colors.surfaceVariant,
            shape: BoxShape.circle,
          ),
          child: Icon(
            themeProvider.getThemeModeIcon(mode),
            color: isSelected 
                ? context.colors.onPrimary
                : context.colors.onSurfaceVariant,
            size: context.spacing.medium,
          ),
        ),
        title: SafeText(
          themeProvider.getThemeModeDisplayName(mode),
          style: TextStyle(
            fontSize: context.typography.bodyLarge,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected 
                ? context.colors.primary
                : context.colors.onSurface,
          ),
          maxLines: 1,
        ),
        subtitle: SafeText(
          _getThemeModeDescription(mode),
          style: TextStyle(
            fontSize: context.typography.bodySmall,
            color: context.colors.onSurfaceVariant,
          ),
          maxLines: 2,
        ),
        trailing: isSelected
            ? Icon(
                Icons.check_circle,
                color: context.colors.primary,
                size: context.spacing.medium,
              )
            : null,
        onTap: () async {
          if (!isSelected) {
            // Add haptic feedback
            HapticFeedback.selectionClick();
            
            // Animate the selection with a slight delay for visual feedback
            await Future.delayed(const Duration(milliseconds: 100));
            
            await themeProvider.setThemeMode(mode);
          }
        },
      ),
    );
  }

  String _getThemeModeDescription(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return 'Always use light theme';
      case AppThemeMode.dark:
        return 'Always use dark theme';
      case AppThemeMode.system:
        return 'Follow system settings';
    }
  }
}

/// Quick theme toggle button for app bars
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return RotationTransition(
              turns: animation,
              child: child,
            );
          },
          child: IconButton(
            key: ValueKey(themeProvider.isDarkMode),
            icon: Icon(
              themeProvider.isDarkMode 
                  ? Icons.light_mode 
                  : Icons.dark_mode,
              color: context.colors.onSurface,
            ),
            onPressed: () async {
              HapticFeedback.lightImpact();
              await themeProvider.toggleTheme();
            },
            tooltip: themeProvider.isDarkMode 
                ? 'Switch to light theme' 
                : 'Switch to dark theme',
          ),
        );
      },
    );
  }
}
