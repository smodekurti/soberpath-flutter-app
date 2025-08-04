import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../utils/responsive_helpers.dart';
import 'notification_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundGray,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppConstants.primaryPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveHelpers.getResponsivePadding(
            context, AppConstants.paddingLarge)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notifications Section
            _buildSectionHeader('Notifications'),
            _buildSettingsCard(
              icon: Icons.notifications_outlined,
              title: 'Notification Settings',
              subtitle: 'Manage reminders and alerts',
              onTap: () => _navigateToNotificationSettings(context),
              backgroundColor: AppConstants.lightPurple,
              iconColor: AppConstants.primaryPurple,
            ),

            const SizedBox(height: AppConstants.paddingLarge),

            // Privacy & Data Section
            _buildSectionHeader('Privacy & Data'),
            _buildSettingsCard(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy & Data',
              subtitle: 'Manage your personal information',
              onTap: () => _openPrivacySettings(context),
              backgroundColor: AppConstants.lightBlue,
              iconColor: AppConstants.blueAccent,
            ),

            const SizedBox(height: AppConstants.paddingLarge),

            // About Section
            _buildSectionHeader('About'),
            _buildSettingsCard(
              icon: Icons.info_outline,
              title: 'About SoberPath',
              subtitle: 'App version and information',
              onTap: () => _showAboutDialog(context),
              backgroundColor: AppConstants.lightGreen,
              iconColor: AppConstants.successGreen,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppConstants.paddingMedium,
      ),
      child: SafeText(
        title,
        style: TextStyle(
          fontSize: AppConstants.fontSizeXLarge,
          fontWeight: FontWeight.bold,
          color: AppConstants.textDark,
        ),
        maxLines: 1,
      ),
    );
  }

  Widget _buildSettingsCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color backgroundColor,
    required Color iconColor,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius:
                      BorderRadius.circular(AppConstants.borderRadiusMedium),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppConstants.paddingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SafeText(
                      title,
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeLarge,
                        fontWeight: FontWeight.w600,
                        color: AppConstants.textDark,
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 2),
                    SafeText(
                      subtitle,
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeMedium,
                        color: AppConstants.textGray,
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppConstants.textGray,
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
      const SnackBar(
        content: Text('Privacy settings coming soon!'),
        backgroundColor: AppConstants.primaryPurple,
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'SoberPath',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.favorite,
        color: AppConstants.primaryPurple,
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
