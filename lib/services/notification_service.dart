import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import '../models/sobriety_models.dart';
import '../config/app_config.dart';
import '../main.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Initialize as a late variable
  late final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static bool _isInitialized = false;

  // Notification IDs
  static const int dailyCheckInId = 1000;
  static const int milestoneId = 2000;
  static const int motivationalId = 3000;
  static const int cravingSupportId = 4000;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize timezone
    tz.initializeTimeZones();
    
    // Use device's actual timezone instead of hard-coding
    try {
      // Try to get the device's timezone
      final String timeZoneName = DateTime.now().timeZoneName;
      final location = tz.getLocation(timeZoneName);
      tz.setLocalLocation(location);
    } catch (e) {
      // Fallback to local timezone if device timezone detection fails
      tz.setLocalLocation(tz.local);
    }

    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization with notification categories
    final List<DarwinNotificationCategory> darwinNotificationCategories = [
      DarwinNotificationCategory(
        'daily_checkin_category',
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.plain('complete_checkin', 'Complete Check-in'),
        ],
      ),
      DarwinNotificationCategory(
        'craving_support_category',
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.plain('view_support', 'View Support'),
        ],
      ),
      DarwinNotificationCategory(
        'milestone_category',
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.plain('celebrate', 'Celebrate'),
        ],
      ),
    ];

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      requestCriticalPermission: false,
      notificationCategories: darwinNotificationCategories,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
      onDidReceiveBackgroundNotificationResponse: _onBackgroundNotificationTapped,
    );

    // Create notification channels for Android
    await _createNotificationChannels();

    _isInitialized = true;
  }

  Future<void> _createNotificationChannels() async {
    // Only create channels on Android
    if (!Platform.isAndroid) return;

    const AndroidNotificationChannel dailyCheckInChannel =
        AndroidNotificationChannel(
      'daily_checkin_channel',
      'Daily Check-ins',
      description: 'Daily check-in reminders',
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
    );

    const AndroidNotificationChannel milestoneChannel =
        AndroidNotificationChannel(
      'milestone_channel',
      'Milestones',
      description: 'Milestone achievement notifications',
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
    );

    const AndroidNotificationChannel motivationalChannel =
        AndroidNotificationChannel(
      'motivational_channel',
      'Motivational Messages',
      description: 'Daily motivational messages',
      importance: Importance.defaultImportance,
      enableVibration: false,
      playSound: true,
    );

    const AndroidNotificationChannel cravingSupportChannel =
        AndroidNotificationChannel(
      'craving_support_channel',
      'Craving Support',
      description: 'Immediate support for cravings',
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
    );

    const AndroidNotificationChannel testChannel =
        AndroidNotificationChannel(
      'test_channel_basic',
      'Basic Test',
      description: 'Basic test notifications',
      importance: Importance.max,
      enableVibration: true,
      playSound: true,
    );

    final plugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (plugin != null) {
      await plugin.createNotificationChannel(dailyCheckInChannel);
      await plugin.createNotificationChannel(milestoneChannel);
      await plugin.createNotificationChannel(motivationalChannel);
      await plugin.createNotificationChannel(cravingSupportChannel);
      await plugin.createNotificationChannel(testChannel);
    }
  }

  static void _onNotificationTapped(NotificationResponse notificationResponse) {
    final String? payload = notificationResponse.payload;

    if (payload != null) {
      // Handle different notification types
      switch (payload) {
        case 'daily_checkin':
          // Navigate to check-in screen (home screen where daily check-in card is)
          _navigateToScreen('/checkIn');
          break;
        case 'milestone':
          // Navigate to progress screen to see milestone achievements
          _navigateToScreen('/progress');
          break;
        case 'motivational':
          // Navigate to home screen for motivational content
          _navigateToScreen('/home');
          break;
        case 'craving_support':
          // Navigate to support screen for resources
          _navigateToScreen('/support');
          break;
      }
    }
  }

  @pragma('vm:entry-point')
  static void _onBackgroundNotificationTapped(NotificationResponse notificationResponse) {
    // Handle background notification taps
    // This runs in an isolate, so we have limited capabilities
  }

  // Helper method to handle navigation
  static void _navigateToScreen(String route) {
    try {
      final context = navigatorKey.currentContext;
      if (context != null) {
        Navigator.of(context).pushNamed(route);
      }
    } catch (e) {
      // Fallback: try to navigate to home
      try {
        final context = navigatorKey.currentContext;
        if (context != null) {
          Navigator.of(context).pushNamed('/home');
        }
      } catch (fallbackError) {
        // Silently handle navigation errors in production
      }
    }
  }

  Future<void> sendSimpleiOSTest() async {
    if (!Platform.isIOS) return;

    try {
      // First check permissions
      final permissionStatus = await getPermissionStatus();
      final isAuthorized = permissionStatus['authorizationStatus'] == 'authorized' ||
                          permissionStatus['authorizationStatus'] == 'provisional';
      
      if (!isAuthorized) {
        throw Exception('iOS notification permissions not granted');
      }

      const DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'default',
        threadIdentifier: 'test_thread',
        interruptionLevel: InterruptionLevel.active,
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        iOS: iOSPlatformChannelSpecifics,
      );

      // Send immediate test notification
      await _notifications.show(
        999, // Test notification ID
        'iOS Test Notification ',
        'This test confirms iOS notifications are working properly. Time: ${DateTime.now().toString().substring(11, 19)}',
        platformChannelSpecifics,
        payload: 'test',
      );

      // Also schedule a test notification for 5 seconds from now
      final testTime = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5));
      await _notifications.zonedSchedule(
        998, // Scheduled test notification ID
        'iOS Scheduled Test ',
        'This scheduled test confirms iOS background notifications work.',
        testTime,
        platformChannelSpecifics,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'scheduled_test',
      );
    } catch (e) {
      throw Exception('iOS test notification failed: $e');
    }
  }

  Future<void> debugiOSNotifications() async {
    if (!Platform.isIOS) return;

    try {
      final permissionStatus = await getPermissionStatus();
      final pendingNotifications = await getPendingNotifications();

      // Enhanced iOS debugging information
      final debugInfo = {
        'permissionStatus': permissionStatus,
        'pendingNotificationsCount': pendingNotifications.length,
        'pendingNotifications': pendingNotifications.map((n) => {
          'id': n.id,
          'title': n.title,
          'body': n.body,
          'payload': n.payload,
        }).toList(),
        'isInitialized': _isInitialized,
        'currentTimezone': tz.local.name,
        'currentTime': tz.TZDateTime.now(tz.local).toString(),
      };

      // Check if daily check-in is scheduled
      final dailyCheckInScheduled = pendingNotifications.any((n) => n.id == dailyCheckInId);
      debugInfo['dailyCheckInScheduled'] = dailyCheckInScheduled;

      if (dailyCheckInScheduled) {
        final dailyCheckIn = pendingNotifications.firstWhere((n) => n.id == dailyCheckInId);
        debugInfo['dailyCheckInDetails'] = {
          'title': dailyCheckIn.title,
          'body': dailyCheckIn.body,
          'payload': dailyCheckIn.payload,
        };
      }

      // In production, you might want to log this or send to analytics
      // For debugging, this information is now available
      // ignore: avoid_print
      print('iOS Notification Debug Info: $debugInfo');
    } catch (e) {
      // Silently handle iOS debug errors in production
    }
  }

  Future<Map<String, dynamic>> getPermissionStatus() async {
    if (Platform.isIOS) {
      try {
        final plugin = _notifications.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();

        if (plugin != null) {
          // Check if permissions are enabled
          final permissions = await plugin.checkPermissions();
          final bool permissionGranted = permissions?.isEnabled == true;

          return {
            'permissionsGranted': permissionGranted.toString(),
            'platform': 'iOS',
          };
        } else {
          return {
            'error': 'iOS plugin not available',
            'platform': 'iOS',
          };
        }
      } catch (e) {
        // Silently handle iOS permission check errors in production
        return {
          'error': e.toString(),
          'platform': 'iOS',
        };
      }
    }
    return {'platform': 'Android or other'};
  }

  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      // Request notification permission for Android 13+
      final status = await Permission.notification.request();
      return status.isGranted;
    } else if (Platform.isIOS) {
      try {
        // For iOS, request permissions through the plugin
        final bool? result = await _notifications
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
              critical: false,
            );
        
        // Also check the actual permission status
        final permissionStatus = await getPermissionStatus();
        final isAuthorized = permissionStatus['authorizationStatus'] == 'authorized' ||
                            permissionStatus['authorizationStatus'] == 'provisional';
        
        return (result ?? false) && isAuthorized;
      } catch (e) {
        return false;
      }
    } else {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      final bool? grantedNotificationPermission =
          await androidImplementation?.requestNotificationsPermission();
      return grantedNotificationPermission ?? false;
    }
  }

  Future<void> scheduleDailyCheckInReminder({
    required String time, // Format: "HH:MM"
    required String userName,
  }) async {
    if (!_isInitialized) await initialize();

    // First, cancel any existing daily check-in reminder
    await cancelDailyCheckInReminder();

    // Check permissions before scheduling
    final permissionStatus = await getPermissionStatus();
    if (Platform.isIOS) {
      final isAuthorized = permissionStatus['authorizationStatus'] == 'authorized' ||
                          permissionStatus['authorizationStatus'] == 'provisional';
      if (!isAuthorized) {
        throw Exception('Notification permissions not granted for iOS');
      }
    }

    // Parse time
    final timeParts = time.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    // Create notification details with enhanced iOS configuration
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'daily_checkin_channel',
      'Daily Check-in Reminders',
      channelDescription: 'Reminders to complete your daily check-in',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(''),
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      categoryIdentifier: 'daily_checkin_category',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
      threadIdentifier: 'daily_checkin_thread',
      interruptionLevel: InterruptionLevel.active,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    // Create the scheduled time as TZDateTime
    final scheduledTime = _createScheduledTime(hour, minute);

    try {
      // Schedule the notification
      await _notifications.zonedSchedule(
        dailyCheckInId,
        'Time for your daily check-in! 💜',
        'Hi $userName! How are you feeling today? Take a moment to reflect on your journey.',
        scheduledTime,
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'daily_checkin',
      );

      // Verify the notification was scheduled (iOS debugging)
      if (Platform.isIOS) {
        final pendingNotifications = await getPendingNotifications();
        final dailyCheckInScheduled = pendingNotifications.any((n) => n.id == dailyCheckInId);
        if (!dailyCheckInScheduled) {
          throw Exception('Failed to schedule daily check-in notification on iOS');
        }
      }
    } catch (e) {
      // Enhanced error handling for iOS
      if (Platform.isIOS) {
        throw Exception('iOS notification scheduling failed: $e');
      } else {
        throw Exception('Notification scheduling failed: $e');
      }
    }
  }

  Future<void> scheduleMilestoneNotification({
    required int days,
    required String benefit,
    required String userName,
    DateTime? scheduledDate,
  }) async {
    if (!_isInitialized) await initialize();

    // Create TZDateTime for scheduling - always ensure it's in the future
    tz.TZDateTime scheduleTime;

    if (scheduledDate != null) {
      // Convert provided DateTime to TZDateTime at 9 AM
      scheduleTime = tz.TZDateTime(
        tz.local,
        scheduledDate.year,
        scheduledDate.month,
        scheduledDate.day,
        9, // 9 AM
        0, // 0 minutes
        0, // 0 seconds
      );

      // If the calculated time is in the past, schedule for next occurrence
      final now = tz.TZDateTime.now(tz.local);
      if (scheduleTime.isBefore(now) || scheduleTime.isAtSameMomentAs(now)) {
        // If the date is today but time has passed, schedule for tomorrow
        if (scheduleTime.year == now.year &&
            scheduleTime.month == now.month &&
            scheduleTime.day == now.day) {
          scheduleTime = scheduleTime.add(const Duration(days: 1));
        } else {
          // If the entire date is in the past, schedule for 2 seconds from now for immediate delivery
          scheduleTime = now.add(const Duration(seconds: 2));
        }
      }
    } else {
      // Schedule for tomorrow at 9 AM if no date provided
      final tomorrow = tz.TZDateTime.now(tz.local).add(const Duration(days: 1));
      scheduleTime = tz.TZDateTime(
        tz.local,
        tomorrow.year,
        tomorrow.month,
        tomorrow.day,
        9, // 9 AM
        0, // 0 minutes
        0, // 0 seconds
      );
    }

    // Double-check that the schedule time is in the future
    final now = tz.TZDateTime.now(tz.local);
    if (scheduleTime.isBefore(now) || scheduleTime.isAtSameMomentAs(now)) {
      // Fallback: schedule for 2 seconds from now
      scheduleTime = now.add(const Duration(seconds: 2));
      // Scheduled immediately (was in past)
    } else {
      // Scheduled for future
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'milestone_channel',
      'Milestone Celebrations',
      channelDescription: 'Celebrating your sobriety milestones',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(''),
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      categoryIdentifier: 'milestone_category',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _notifications.zonedSchedule(
      milestoneId + days, // Unique ID for each milestone
      '🎉 $days Days Strong! 🎉',
      'Congratulations $userName! You\'ve reached $days days of sobriety. $benefit',
      scheduleTime,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'milestone',
    );
  }

  Future<void> scheduleMotivationalNotifications({
    required String userName,
    required List<int> hours, // Times to send throughout the day
  }) async {
    if (!_isInitialized) await initialize();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'motivational_channel',
      'Motivational Messages',
      channelDescription: 'Daily motivation and encouragement',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      styleInformation: BigTextStyleInformation(''),
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      categoryIdentifier: 'motivational_category',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    // Schedule multiple motivational notifications throughout the day
    for (int i = 0; i < hours.length; i++) {
      final hour = hours[i];

      // Get current time as TZDateTime
      final currentTime = tz.TZDateTime.now(tz.local);

      // Get quote based on current day
      final quote = AppConfig.content.motivationalQuotes[
          (currentTime.day + i) % AppConfig.content.motivationalQuotes.length];

      // Create scheduled time
      final scheduledTime = _createScheduledTime(hour, 0);

      await _notifications.zonedSchedule(
        motivationalId + i,
        '✨ Daily Inspiration ✨',
        '$userName, $quote',
        scheduledTime,
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'motivational',
      );
    }
  }

  Future<void> sendImmediateMilestoneNotification({
    required int days,
    required String benefit,
    required String userName,
  }) async {
    if (!_isInitialized) await initialize();

    // For immediate milestone notifications, use the show method instead of zonedSchedule
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'milestone_channel',
      'Milestone Celebrations',
      channelDescription: 'Celebrating your sobriety milestones',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(''),
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      categoryIdentifier: 'milestone_category',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _notifications.show(
      milestoneId + days, // Unique ID for each milestone
      '🎉 $days Days Strong! 🎉',
      'Congratulations $userName! You\'ve reached $days days of sobriety. $benefit',
      platformChannelSpecifics,
      payload: 'milestone',
    );

    // Immediate milestone notification sent
  }

  Future<void> sendImmediateCravingSupport({
    required String userName,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'craving_support_channel',
      'Craving Support',
      channelDescription: 'Immediate support for cravings',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(''),
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      categoryIdentifier: 'craving_support_category',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    final supportMessages = [
      'You\'re stronger than this craving, $userName. Take 5 deep breaths.',
      'This feeling will pass. You\'ve overcome cravings before.',
      'Remember why you started this journey. You\'ve got this!',
      'Call a friend, go for a walk, or practice mindfulness. You\'re not alone.',
    ];

    // Get current time as TZDateTime and use for random selection
    final currentTime = tz.TZDateTime.now(tz.local);
    final message =
        supportMessages[currentTime.millisecond % supportMessages.length];

    try {
      await _notifications.show(
        cravingSupportId,
        '💪 You\'ve Got This!',
        message,
        platformChannelSpecifics,
        payload: 'craving_support',
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelDailyCheckInReminder() async {
    await _notifications.cancel(dailyCheckInId);
  }

  Future<void> cancelMilestoneNotification(int days) async {
    await _notifications.cancel(milestoneId + days);
  }

  Future<void> cancelMotivationalNotifications() async {
    // Cancel up to 10 motivational notifications
    for (int i = 0; i < 10; i++) {
      await _notifications.cancel(motivationalId + i);
    }
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  // Helper method to create TZDateTime for scheduling
  tz.TZDateTime _createScheduledTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
      0, // seconds
      0, // milliseconds
      0, // microseconds
    );

    // If the time has already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  // Method to update notifications when app settings change
  Future<void> updateNotificationSettings({
    required AppSettings settings,
    required String userName,
  }) async {
    // Cancel existing notifications
    await cancelDailyCheckInReminder();
    await cancelMotivationalNotifications();

    if (settings.notificationsEnabled) {
      // Reschedule with new settings
      await scheduleDailyCheckInReminder(
        time: settings.reminderTime,
        userName: userName,
      );

      if (settings.dailyQuoteEnabled) {
        await scheduleMotivationalNotifications(
          userName: userName,
          hours: [9, 15, 20], // Morning, afternoon, evening
        );
      }
    }
  }
}
