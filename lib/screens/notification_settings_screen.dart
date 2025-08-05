import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soberpath_app/widgets/safe_text.dart';

import 'dart:io';

import '../services/app_state_provider.dart';

import '../config/theme_extensions.dart';
import '../models/sobriety_models.dart';
import '../utils/responsive_helpers.dart' hide SafeText;
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
            colorScheme: ColorScheme.light(
              primary: context.colors.primary,
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
              granted ? context.colors.success : context.colors.warning,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: const Text('Notification Settings'),
        backgroundColor: context.colors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<AppStateProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(ResponsiveHelpers.getResponsivePadding(
                context, context.spacing.large)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Permission Status Card
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(context.spacing.large),
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
                                  ? context.colors.success
                                  : context.colors.warning,
                            ),
                            SizedBox(width: context.spacing.medium),
                            Expanded(
                              child: Text(
                                'Notification Permissions',
                                style: TextStyle(
                                  fontSize: context.typography.titleLarge,
                                  fontWeight: FontWeight.bold,
                                  color: context.colors.onSurface,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: context.spacing.medium),
                        Text(
                          provider.notificationPermissionsGranted
                              ? 'Notifications are enabled and ready to help support your recovery journey.'
                              : 'Enable notifications to receive daily check-in reminders, milestone celebrations, and motivational messages.',
                          style: TextStyle(
                            fontSize: context.typography.bodyMedium,
                            color: context.colors.onSurfaceVariant,
                          ),
                          maxLines: 3,
                        ),

                        // Add debug information
                        SizedBox(height: context.spacing.medium),
                        Container(
                          padding: EdgeInsets.all(context.spacing.medium),
                          decoration: BoxDecoration(
                            color: context.colors.surfaceVariant,
                            borderRadius: BorderRadius.circular(
                                context.borders.medium),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SafeText(
                                'Debug Info:',
                                style: TextStyle(
                                  fontSize: context.typography.bodySmall,
                                  fontWeight: FontWeight.bold,
                                  color: context.colors.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Permissions: ${provider.notificationPermissionsGranted ? "✅ Granted" : "❌ Denied"}',
                                style: TextStyle(
                                  fontSize: context.typography.bodySmall,
                                  color: context.colors.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                'Notifications Enabled: ${provider.appSettings.notificationsEnabled ? "✅ Yes" : "❌ No"}',
                                style: TextStyle(
                                  fontSize: context.typography.bodySmall,
                                  color: context.colors.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                'Reminder Time: ${provider.appSettings.reminderTime}',
                                style: TextStyle(
                                  fontSize: context.typography.bodySmall,
                                  color: context.colors.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                'User Name: ${provider.userProfile?.name ?? "No user"}',
                                style: TextStyle(
                                  fontSize: context.typography.bodySmall,
                                  color: context.colors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),

                        if (!provider.notificationPermissionsGranted) ...[
                          SizedBox(height: context.spacing.medium),
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

                SizedBox(height: context.spacing.large),

                // Notification Settings Card
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(context.spacing.large),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          provider.notificationPermissionsGranted
                              ? 'Notifications Enabled'
                              : 'Notifications Disabled',
                          style: TextStyle(
                            fontSize: context.typography.titleLarge,
                            fontWeight: FontWeight.bold,
                            color: context.colors.onSurface,
                          ),
                          maxLines: 1,
                        ),
                        SizedBox(height: context.spacing.large),

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
                          Divider(height: context.spacing.large * 2),

                          // Daily Check-in Reminder Time
                          _buildTimeSettingRow(
                            icon: Icons.access_time,
                            title: 'Daily Check-in Reminder',
                            subtitle: 'When to remind you for daily check-ins',
                            time: _selectedTime,
                            onTap: _selectTime,
                          ),

                          Divider(height: context.spacing.large * 2),

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
                            Divider(height: context.spacing.large * 2),
                            ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: context.colors.warning.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(context.borders.small),
                                ),
                                child: Icon(
                                  Icons.bug_report,
                                  color: context.colors.warning,
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
            color: context.colors.primaryLight,
            borderRadius: BorderRadius.circular(context.borders.small),
          ),
          child: Icon(
            icon,
            color: context.colors.primary,
            size: 20,
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
                maxLines: 1,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: context.typography.bodyMedium,
                  color: context.colors.onSurfaceVariant,
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: context.colors.primary,
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
      borderRadius: BorderRadius.circular(context.borders.medium),
      child: Padding(
        padding:
            EdgeInsets.symmetric(vertical: context.spacing.small),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.colors.primaryLight,
                borderRadius:
                    BorderRadius.circular(context.borders.small),
              ),
              child: Icon(
                icon,
                color: context.colors.secondary,
                size: 20,
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
                    maxLines: 1,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: context.typography.bodyMedium,
                      color: context.colors.onSurfaceVariant,
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.spacing.medium,
                vertical: context.spacing.small,
              ),
              decoration: BoxDecoration(
                color: context.colors.surfaceVariant,
                borderRadius:
                    BorderRadius.circular(context.borders.medium),
              ),
              child: Text(
                time?.format(context) ?? '9:00 AM',
                style: TextStyle(
                  fontSize: context.typography.titleMedium,
                  fontWeight: FontWeight.w600,
                  color: context.colors.primary,
                ),
                maxLines: 1,
              ),
            ),
            SizedBox(width: context.spacing.small),
            Icon(
              Icons.chevron_right,
              color: context.colors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
