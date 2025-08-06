import 'package:flutter/material.dart';
import '../config/theme_extensions.dart';
import '../utils/responsive_helpers.dart' hide SafeText;
import '../widgets/theme_settings_widget.dart';

import 'notification_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: context.colors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveHelpers.getResponsivePadding(
            context, context.spacing.large)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme Section
            const ThemeSettingsWidget(),
            
            SizedBox(height: context.spacing.large),
            
            // Notifications Section
            _buildSectionHeader(context, 'Notifications'),
            _buildSettingsCard(
              context,
              icon: Icons.notifications_outlined,
              title: 'Notification Settings',
              subtitle: 'Manage reminders and alerts',
              onTap: () => _navigateToNotificationSettings(context),
              backgroundColor: context.colors.primary.withValues(alpha: 0.1),
              iconColor: context.colors.primary,
            ),

            SizedBox(height: context.spacing.large),

            // Privacy & Data Section
            _buildSectionHeader(context, 'Privacy & Data'),
            _buildSettingsCard(
              context,
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy & Data',
              subtitle: 'Manage your personal information',
              onTap: () => _openPrivacySettings(context),
              backgroundColor: context.colors.secondary.withValues(alpha: 0.1),
              iconColor: context.colors.secondary,
            ),

            SizedBox(height: context.spacing.large),

            // About Section
            _buildSectionHeader(context, 'About'),
            _buildSettingsCard(
              context,
              icon: Icons.info_outline,
              title: 'About SoberPath',
              subtitle: 'App version and information',
              onTap: () => _showAboutDialog(context),
              backgroundColor: context.colors.surface.withValues(alpha: 0.8),
              iconColor: context.colors.onSurface,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: context.spacing.medium,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: context.typography.headlineSmall,
          fontWeight: FontWeight.bold,
          color: context.colors.onSurface,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color backgroundColor,
    required Color iconColor,
  }) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(bottom: context.spacing.medium),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(context.borders.large),
        child: Padding(
          padding: EdgeInsets.all(context.spacing.large),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(context.spacing.small),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius:
                      BorderRadius.circular(context.borders.medium),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              SizedBox(width: context.spacing.medium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: context.typography.titleMedium,
                        fontWeight: FontWeight.w600,
                        color: context.colors.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: context.typography.bodyMedium,
                        color: context.colors.onSurfaceVariant,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: context.colors.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToNotificationSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NotificationSettingsScreen(),
      ),
    );
  }

  void _openPrivacySettings(BuildContext context) {
    // TODO: Implement privacy settings screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Privacy settings coming soon!'),
        backgroundColor: context.colors.primary,
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'SoberPath',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(
        Icons.favorite,
        color: context.colors.primary,
        size: 32,
      ),
      children: const [
        Text('Your personal companion for recovery and sobriety tracking.'),
        SizedBox(height: 16),
        Text('Built with ❤️ for your wellness journey.'),
      ],
    );
  }
}
