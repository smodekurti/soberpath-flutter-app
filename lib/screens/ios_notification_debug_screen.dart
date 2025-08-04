import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../services/app_state_provider.dart';
import '../services/notification_service.dart';
import '../constants/app_constants.dart';

class IOSNotificationDebugScreen extends StatefulWidget {
  const IOSNotificationDebugScreen({super.key});

  @override
  State<IOSNotificationDebugScreen> createState() => _IOSNotificationDebugScreenState();
}

class _IOSNotificationDebugScreenState extends State<IOSNotificationDebugScreen> {
  final NotificationService _notificationService = NotificationService();
  Map<String, dynamic>? _permissionStatus;
  List<String>? _pendingNotifications;
  String? _lastTestResult;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationStatus();
  }

  Future<void> _loadNotificationStatus() async {
    if (!Platform.isIOS) return;
    
    setState(() => _isLoading = true);
    
    try {
      final permissionStatus = await _notificationService.getPermissionStatus();
      if (!mounted) return;
      final provider = Provider.of<AppStateProvider>(context, listen: false);
      final pendingNotifications = await provider.notificationManager.getScheduledNotifications();
      
      if (mounted) {
        setState(() {
          _permissionStatus = permissionStatus;
          _pendingNotifications = pendingNotifications;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _lastTestResult = 'Error loading status: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _runIOSDebug() async {
    setState(() => _isLoading = true);
    
    try {
      await _notificationService.debugiOSNotifications();
      if (mounted) {
        setState(() {
          _lastTestResult = 'iOS debug completed - check console for details';
          _isLoading = false;
        });
        await _loadNotificationStatus();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _lastTestResult = 'iOS debug failed: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _sendTestNotification() async {
    setState(() => _isLoading = true);
    
    try {
      await _notificationService.sendSimpleiOSTest();
      if (mounted) {
        setState(() {
          _lastTestResult = 'Test notifications sent successfully! Check for immediate and 5-second delayed notifications.';
          _isLoading = false;
        });
        await _loadNotificationStatus();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _lastTestResult = 'Test notification failed: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _requestPermissions() async {
    setState(() => _isLoading = true);
    
    try {
      final granted = await _notificationService.requestPermissions();
      if (mounted) {
        setState(() {
          _lastTestResult = granted 
              ? 'Permissions granted successfully!' 
              : 'Permissions denied. Please enable in Settings app.';
          _isLoading = false;
        });
        await _loadNotificationStatus();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _lastTestResult = 'Permission request failed: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _scheduleDailyReminder() async {
    setState(() => _isLoading = true);
    
    try {
      final provider = Provider.of<AppStateProvider>(context, listen: false);
      final userName = provider.userProfile?.name ?? 'User';
      final reminderTime = provider.appSettings.reminderTime;
      
      await _notificationService.scheduleDailyCheckInReminder(
        time: reminderTime,
        userName: userName,
      );
      
      if (mounted) {
        setState(() {
          _lastTestResult = 'Daily reminder scheduled for $reminderTime';
          _isLoading = false;
        });
        await _loadNotificationStatus();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _lastTestResult = 'Daily reminder scheduling failed: $e';
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildStatusCard(String title, Widget content) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: AppConstants.fontSizeXLarge,
                fontWeight: FontWeight.bold,
                color: AppConstants.primaryPurple,
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed, {Color? color}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppConstants.primaryPurple,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingMedium),
        ),
        child: Text(label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('iOS Notification Debug'),
          backgroundColor: AppConstants.primaryPurple,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text(
            'This screen is only available on iOS devices.',
            style: TextStyle(fontSize: AppConstants.fontSizeLarge),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppConstants.backgroundGray,
      appBar: AppBar(
        title: const Text('iOS Notification Debug'),
        backgroundColor: AppConstants.primaryPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadNotificationStatus,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Permission Status
                  _buildStatusCard(
                    'Permission Status',
                    _permissionStatus != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _permissionStatus!.entries.map((entry) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  '${entry.key}: ${entry.value}',
                                  style: TextStyle(
                                    color: entry.key == 'authorizationStatus' && 
                                           (entry.value == 'authorized' || entry.value == 'provisional')
                                        ? AppConstants.successGreen
                                        : AppConstants.textDark,
                                  ),
                                ),
                              );
                            }).toList(),
                          )
                        : const Text('Loading...'),
                  ),

                  // Pending Notifications
                  _buildStatusCard(
                    'Scheduled Notifications',
                    _pendingNotifications != null
                        ? _pendingNotifications!.isEmpty
                            ? const Text(
                                'No notifications scheduled',
                                style: TextStyle(color: AppConstants.warningYellow),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _pendingNotifications!.map((notification) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Text(
                                      notification,
                                      style: const TextStyle(fontSize: AppConstants.fontSizeSmall),
                                    ),
                                  );
                                }).toList(),
                              )
                        : const Text('Loading...'),
                  ),

                  // Last Test Result
                  if (_lastTestResult != null)
                    _buildStatusCard(
                      'Last Test Result',
                      Text(
                        _lastTestResult!,
                        style: TextStyle(
                          color: _lastTestResult!.contains('failed') || _lastTestResult!.contains('Error')
                              ? AppConstants.dangerRed
                              : AppConstants.successGreen,
                        ),
                      ),
                    ),

                  // Action Buttons
                  const Text(
                    'Actions',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeXLarge,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textDark,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),

                  _buildActionButton(
                    'Request Notification Permissions',
                    _requestPermissions,
                    color: AppConstants.blueAccent,
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),

                  _buildActionButton(
                    'Send Test Notification',
                    _sendTestNotification,
                    color: AppConstants.successGreen,
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),

                  _buildActionButton(
                    'Schedule Daily Reminder',
                    _scheduleDailyReminder,
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),

                  _buildActionButton(
                    'Run iOS Debug Analysis',
                    _runIOSDebug,
                    color: AppConstants.warningYellow,
                  ),

                  const SizedBox(height: AppConstants.paddingLarge),

                  // Instructions
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.paddingLarge),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Troubleshooting Steps:',
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeLarge,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppConstants.paddingSmall),
                          const Text('1. Ensure notification permissions are granted'),
                          const Text('2. Test immediate notifications work'),
                          const Text('3. Schedule daily reminder and verify it appears in pending list'),
                          const Text('4. Check iOS Settings > Notifications > SoberPath'),
                          const Text('5. Ensure "Allow Notifications" is enabled'),
                          const Text('6. Check that app is not in "Do Not Disturb" mode'),
                          const Text('7. Verify Background App Refresh is enabled'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
