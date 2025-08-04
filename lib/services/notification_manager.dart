import 'package:flutter/foundation.dart';
import '../services/notification_service.dart';
import '../services/database_service.dart';
import '../models/sobriety_models.dart';

class NotificationManager with ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  final DatabaseService _databaseService = DatabaseService();

  bool _isInitialized = false;
  bool _permissionsGranted = false;

  bool get isInitialized => _isInitialized;
  bool get permissionsGranted => _permissionsGranted;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _notificationService.initialize();
      _permissionsGranted = await _notificationService.requestPermissions();
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      // Silently handle initialization errors in production
    }
  }

  Future<bool> requestPermissions() async {
    _permissionsGranted = await _notificationService.requestPermissions();
    notifyListeners();
    return _permissionsGranted;
  }

  Future<Map<String, dynamic>> getPermissionStatus() async {
    return await _notificationService.getPermissionStatus();
  }

  Future<void> debugiOSNotifications() async {
    return await _notificationService.debugiOSNotifications();
  }

  Future<void> sendSimpleiOSTest() async {
    return await _notificationService.sendSimpleiOSTest();
  }

  Future<void> setupUserNotifications({
    required UserProfile userProfile,
    required AppSettings appSettings,
  }) async {
    if (!_isInitialized || !_permissionsGranted) {
      await initialize();
    }

    if (!_permissionsGranted || !appSettings.notificationsEnabled) {
      return;
    }

    try {
      // Setup daily check-in reminder
      await _notificationService.scheduleDailyCheckInReminder(
        time: appSettings.reminderTime,
        userName: userProfile.name,
      );

      // Setup motivational notifications if enabled
      if (appSettings.dailyQuoteEnabled) {
        await _notificationService.scheduleMotivationalNotifications(
          userName: userProfile.name,
          hours: [9, 15, 20], // 9 AM, 3 PM, 8 PM
        );
      }

      // Setup upcoming milestone notifications if user has sober date
      if (userProfile.hasSoberDate) {
        await _setupMilestoneNotifications(userProfile);
      }
    } catch (e) {
      // Silently handle setup errors in production
    }
  }

  Future<void> _setupMilestoneNotifications(UserProfile userProfile) async {
    if (!userProfile.hasSoberDate) return;

    final stats = userProfile.sobrietyStats!;
    final milestones = await _databaseService.getMilestones();

    // Find next unachieved milestone
    final nextMilestone =
        milestones.where((m) => !m.achieved && m.days > stats.days).isNotEmpty
            ? milestones.where((m) => !m.achieved && m.days > stats.days).first
            : null;

    if (nextMilestone != null) {
      final daysUntilMilestone = nextMilestone.days - stats.days;

      // Convert DateTime to TZDateTime properly
      final milestoneDateTime =
          DateTime.now().add(Duration(days: daysUntilMilestone));

      await _notificationService.scheduleMilestoneNotification(
        days: nextMilestone.days,
        benefit: nextMilestone.benefit,
        userName: userProfile.name,
        scheduledDate:
            milestoneDateTime, // This will be converted in NotificationService
      );
    }
  }

  Future<void> onMilestoneAchieved({
    required Milestone milestone,
    required String userName,
  }) async {
    if (!_isInitialized || !_permissionsGranted) return;

    try {
      // Use immediate notification method for milestone achievements
      await _notificationService.sendImmediateMilestoneNotification(
        days: milestone.days,
        benefit: milestone.benefit,
        userName: userName,
      );
    } catch (e) {
      // Silently handle milestone notification errors in production
    }
  }

  Future<void> onHighCravingDetected({
    required String userName,
    required int cravingLevel,
  }) async {
    if (!_isInitialized || !_permissionsGranted) return;

    // Send support notification for high cravings (7+)
    if (cravingLevel >= 7) {
      try {
        await _notificationService.sendImmediateCravingSupport(
          userName: userName,
        );
      } catch (e) {
        // Silently handle craving support notification errors in production
      }
    }
  }

  Future<void> updateNotificationSettings({
    required AppSettings settings,
    required String userName,
  }) async {
    if (!_isInitialized) return;

    try {
      await _notificationService.updateNotificationSettings(
        settings: settings,
        userName: userName,
      );
    } catch (e) {
      // Silently handle notification settings update errors in production
    }
  }

  Future<void> onDailyCheckInComplete({
    required DailyCheckIn checkIn,
    required String userName,
  }) async {
    // Check for high cravings and send support if needed
    await onHighCravingDetected(
      userName: userName,
      cravingLevel: checkIn.cravingLevel,
    );
  }

  Future<void> sendTestNotification({
    required String userName,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    if (!_permissionsGranted) {
      _permissionsGranted = await _notificationService.requestPermissions();
    }

    if (!_isInitialized || !_permissionsGranted) {
      throw Exception('Notifications not initialized or permissions denied');
    }

    try {
      await _notificationService.sendImmediateCravingSupport(
        userName: userName,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendEncouragementAfterMissedCheckIn({
    required String userName,
  }) async {
    if (!_isInitialized || !_permissionsGranted) return;

    // This could be called by a background task to check for missed check-ins
    // For now, we'll leave it as a placeholder for future implementation
  }

  Future<void> cancelAllNotifications() async {
    if (!_isInitialized) return;

    try {
      await _notificationService.cancelAllNotifications();
    } catch (e) {
      // Silently handle notification cancellation errors in production
    }
  }

  Future<List<String>> getScheduledNotifications() async {
    if (!_isInitialized) return [];

    try {
      final pendingNotifications =
          await _notificationService.getPendingNotifications();
      return pendingNotifications.map((n) => '${n.title}: ${n.body}').toList();
    } catch (e) {
      // Silently handle scheduled notifications retrieval errors in production
      return [];
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
