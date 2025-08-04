import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../services/app_state_provider.dart';
import '../constants/app_constants.dart';
import '../models/sobriety_models.dart';
import '../utils/responsive_helpers.dart';
import 'ios_notification_debug_screen.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  late AppSettings _currentSettings;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AppStateProvider>(context, listen: false);
    _currentSettings = provider.appSettings;
    _parseReminderTime();
  }

  void _parseReminderTime() {
    final timeParts = _currentSettings.reminderTime.split(':');
    _selectedTime = TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? const TimeOfDay(hour: 9, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppConstants.primaryPurple,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _currentSettings = _currentSettings.copyWith(
          reminderTime:
              '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}',
        );
      });
      await _saveSettings();
    }
  }

  Future<void> _saveSettings() async {
    final provider = Provider.of<AppStateProvider>(context, listen: false);
    await provider.updateAppSettings(_currentSettings);
  }

  Future<void> _requestPermissions() async {
    final provider = Provider.of<AppStateProvider>(context, listen: false);
    final granted = await provider.requestNotificationPermissions();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            granted
                ? 'Notification permissions granted!'
                : 'Notification permissions denied. You can enable them in device settings.',
          ),
          backgroundColor:
              granted ? AppConstants.successGreen : AppConstants.warningYellow,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundGray,
      appBar: AppBar(
        title: const Text('Notification Settings'),
        backgroundColor: AppConstants.primaryPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<AppStateProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(ResponsiveHelpers.getResponsivePadding(
                context, AppConstants.paddingLarge)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Permission Status Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.paddingLarge),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              provider.notificationPermissionsGranted
                                  ? Icons.check_circle
                                  : Icons.warning,
                              color: provider.notificationPermissionsGranted
                                  ? AppConstants.successGreen
                                  : AppConstants.warningYellow,
                            ),
                            const SizedBox(width: AppConstants.paddingMedium),
                            const Expanded(
                              child: SafeText(
                                'Notification Permissions',
                                style: TextStyle(
                                  fontSize: AppConstants.fontSizeXLarge,
                                  fontWeight: FontWeight.bold,
                                  color: AppConstants.textDark,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppConstants.paddingMedium),
                        SafeText(
                          provider.notificationPermissionsGranted
                              ? 'Notifications are enabled and ready to help support your recovery journey.'
                              : 'Enable notifications to receive daily check-in reminders, milestone celebrations, and motivational messages.',
                          style: TextStyle(
                            fontSize: ResponsiveHelpers.getResponsiveFontSize(
                                context, AppConstants.fontSizeMedium),
                            color: AppConstants.textGray,
                          ),
                          maxLines: 3,
                        ),

                        // Add debug information
                        const SizedBox(height: AppConstants.paddingMedium),
                        Container(
                          padding:
                              const EdgeInsets.all(AppConstants.paddingMedium),
                          decoration: BoxDecoration(
                            color: AppConstants.backgroundGray,
                            borderRadius: BorderRadius.circular(
                                AppConstants.borderRadiusMedium),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SafeText(
                                'Debug Info:',
                                style: TextStyle(
                                  fontSize: AppConstants.fontSizeSmall,
                                  fontWeight: FontWeight.bold,
                                  color: AppConstants.textDark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Permissions: ${provider.notificationPermissionsGranted ? "✅ Granted" : "❌ Denied"}',
                                style: const TextStyle(
                                  fontSize: AppConstants.fontSizeSmall,
                                  color: AppConstants.textGray,
                                ),
                              ),
                              Text(
                                'Notifications Enabled: ${provider.appSettings.notificationsEnabled ? "✅ Yes" : "❌ No"}',
                                style: const TextStyle(
                                  fontSize: AppConstants.fontSizeSmall,
                                  color: AppConstants.textGray,
                                ),
                              ),
                              Text(
                                'Reminder Time: ${provider.appSettings.reminderTime}',
                                style: const TextStyle(
                                  fontSize: AppConstants.fontSizeSmall,
                                  color: AppConstants.textGray,
                                ),
                              ),
                              Text(
                                'User Name: ${provider.userProfile?.name ?? "No user"}',
                                style: const TextStyle(
                                  fontSize: AppConstants.fontSizeSmall,
                                  color: AppConstants.textGray,
                                ),
                              ),
                            ],
                          ),
                        ),

                        if (!provider.notificationPermissionsGranted) ...[
                          const SizedBox(height: AppConstants.paddingMedium),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _requestPermissions,
                              child: const SafeText('Enable Notifications'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppConstants.paddingLarge),

                // Notification Settings Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.paddingLarge),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SafeText(
                          provider.notificationPermissionsGranted
                              ? 'Notifications Enabled'
                              : 'Notifications Disabled',
                          style: TextStyle(
                            fontSize: ResponsiveHelpers.getResponsiveFontSize(
                                context, AppConstants.fontSizeXLarge),
                            fontWeight: FontWeight.bold,
                            color: AppConstants.textDark,
                          ),
                          maxLines: 1,
                        ),
                        const SizedBox(height: AppConstants.paddingLarge),

                        // Enable Notifications Toggle
                        _buildSettingRow(
                          icon: Icons.notifications,
                          title: 'Enable Notifications',
                          subtitle: 'Receive reminders and encouragement',
                          value: _currentSettings.notificationsEnabled,
                          onChanged: (value) {
                            setState(() {
                              _currentSettings = _currentSettings.copyWith(
                                notificationsEnabled: value,
                              );
                            });
                            _saveSettings();
                          },
                        ),

                        if (_currentSettings.notificationsEnabled) ...[
                          const Divider(height: AppConstants.paddingLarge * 2),

                          // Daily Check-in Reminder Time
                          _buildTimeSettingRow(
                            icon: Icons.access_time,
                            title: 'Daily Check-in Reminder',
                            subtitle: 'When to remind you for daily check-ins',
                            time: _selectedTime,
                            onTap: _selectTime,
                          ),

                          const Divider(height: AppConstants.paddingLarge * 2),

                          // Daily Quotes Toggle
                          _buildSettingRow(
                            icon: Icons.format_quote,
                            title: 'Daily Inspirational Quotes',
                            subtitle:
                                'Receive motivational messages throughout the day',
                            value: _currentSettings.dailyQuoteEnabled,
                            onChanged: (value) {
                              setState(() {
                                _currentSettings = _currentSettings.copyWith(
                                  dailyQuoteEnabled: value,
                                );
                              });
                              _saveSettings();
                            },
                          ),

                          // iOS Debug Section (only show on iOS)
                          if (Platform.isIOS) ...[
                            const Divider(height: AppConstants.paddingLarge * 2),
                            ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppConstants.warningYellow.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.bug_report,
                                  color: AppConstants.warningYellow,
                                ),
                              ),
                              title: const SafeText(
                                'iOS Notification Debug',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: const SafeText(
                                'Test and troubleshoot iOS notifications',
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const IOSNotificationDebugScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSettingRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppConstants.lightPurple,
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
          ),
          child: Icon(
            icon,
            color: AppConstants.primaryPurple,
            size: 20,
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
                  fontSize: ResponsiveHelpers.getResponsiveFontSize(
                      context, AppConstants.fontSizeLarge),
                  fontWeight: FontWeight.w600,
                  color: AppConstants.textDark,
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 2),
              SafeText(
                subtitle,
                style: TextStyle(
                  fontSize: ResponsiveHelpers.getResponsiveFontSize(
                      context, AppConstants.fontSizeMedium),
                  color: AppConstants.textGray,
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppConstants.primaryPurple,
        ),
      ],
    );
  }

  Widget _buildTimeSettingRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required TimeOfDay? time,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(vertical: AppConstants.paddingSmall),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppConstants.lightBlue,
                borderRadius:
                    BorderRadius.circular(AppConstants.borderRadiusSmall),
              ),
              child: Icon(
                icon,
                color: AppConstants.blueAccent,
                size: 20,
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
                      fontSize: ResponsiveHelpers.getResponsiveFontSize(
                          context, AppConstants.fontSizeLarge),
                      fontWeight: FontWeight.w600,
                      color: AppConstants.textDark,
                    ),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 2),
                  SafeText(
                    subtitle,
                    style: TextStyle(
                      fontSize: ResponsiveHelpers.getResponsiveFontSize(
                          context, AppConstants.fontSizeMedium),
                      color: AppConstants.textGray,
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
                vertical: AppConstants.paddingSmall,
              ),
              decoration: BoxDecoration(
                color: AppConstants.backgroundGray,
                borderRadius:
                    BorderRadius.circular(AppConstants.borderRadiusMedium),
              ),
              child: SafeText(
                time?.format(context) ?? '9:00 AM',
                style: TextStyle(
                  fontSize: ResponsiveHelpers.getResponsiveFontSize(
                      context, AppConstants.fontSizeLarge),
                  fontWeight: FontWeight.w600,
                  color: AppConstants.primaryPurple,
                ),
                maxLines: 1,
              ),
            ),
            const SizedBox(width: AppConstants.paddingSmall),
            const Icon(
              Icons.chevron_right,
              color: AppConstants.textGray,
            ),
          ],
        ),
      ),
    );
  }
}
