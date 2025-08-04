import 'package:flutter/foundation.dart';
import '../models/sobriety_models.dart';
import '../services/database_service.dart';
import '../services/notification_manager.dart';
import '../constants/app_constants.dart';

class AppStateProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final NotificationManager _notificationManager = NotificationManager();

  // Core State
  UserProfile? _userProfile;
  List<DailyCheckIn> _dailyCheckIns = [];
  List<Milestone> _milestones = [];
  AppSettings _appSettings = AppSettings();
  bool _isLoading = false;
  bool _isInitializing = false;
  String? _error;

  // Current form state
  int _currentMood = 5;
  int _currentCravingLevel = 1;
  String _currentReflection = '';

  // Notification state
  bool get notificationsInitialized => _notificationManager.isInitialized;
  bool get notificationPermissionsGranted =>
      _notificationManager.permissionsGranted;

  // Expose notification manager for testing
  NotificationManager get notificationManager => _notificationManager;

  // Getters
  UserProfile? get userProfile => _userProfile;
  List<DailyCheckIn> get dailyCheckIns => _dailyCheckIns;
  List<Milestone> get milestones => _milestones;
  AppSettings get appSettings => _appSettings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get currentMood => _currentMood;
  int get currentCravingLevel => _currentCravingLevel;
  String get currentReflection => _currentReflection;

  // Computed properties
  bool get hasUserProfile => _userProfile != null;
  bool get hasSoberDate => _userProfile?.soberDate != null;

  SobrietyStats? get sobrietyStats {
    if (_userProfile?.soberDate == null) return null;
    return SobrietyStats.calculateFromDate(_userProfile!.soberDate!);
  }

  double get moneySaved {
    if (_userProfile == null) return 0.0;
    return _userProfile!.calculateMoneySaved();
  }

  int get achievedMilestonesCount {
    return _milestones.where((m) => m.achieved).length;
  }

  Milestone? get nextMilestone {
    return _milestones.where((m) => !m.achieved).isNotEmpty
        ? _milestones.where((m) => !m.achieved).first
        : null;
  }

  String get todaysQuote {
    final today = DateTime.now().day;
    return AppConstants
        .motivationalQuotes[today % AppConstants.motivationalQuotes.length];
  }

  DailyCheckIn? get todaysCheckIn {
    final today = DateTime.now();
    return _dailyCheckIns
            .where((checkIn) =>
                checkIn.date.year == today.year &&
                checkIn.date.month == today.month &&
                checkIn.date.day == today.day)
            .isNotEmpty
        ? _dailyCheckIns
            .where((checkIn) =>
                checkIn.date.year == today.year &&
                checkIn.date.month == today.month &&
                checkIn.date.day == today.day)
            .first
        : null;
  }

  bool get hasCheckedInToday => todaysCheckIn != null;

  // Initialization
  Future<void> initialize() async {
    _isInitializing = true;
    _setLoading(true);
    try {
      await _loadUserProfile();
      await _loadDailyCheckIns();
      await _loadMilestones();
      await _loadAppSettings();
      await _initializeNotifications();
      
      // Fix usage frequency if needed (migration)
      await fixUsageFrequencyIfNeeded();
      
      _clearError();
    } catch (e) {
      _setError('Failed to initialize app: $e');
    } finally {
      _setLoading(false);
      _isInitializing = false;
      // Only notify listeners after initialization is complete
      notifyListeners();
    }
  }

  Future<void> _initializeNotifications() async {
    try {
      await _notificationManager.initialize();

      // Setup notifications if user profile exists
      if (_userProfile != null) {
        await _notificationManager.setupUserNotifications(
          userProfile: _userProfile!,
          appSettings: _appSettings,
        );
      }
    } catch (e) {
      // Silently handle notification initialization errors in production
      // Don't throw error - notifications are optional
    }
  }

  // Notification Management
  Future<bool> requestNotificationPermissions() async {
    final granted = await _notificationManager.requestPermissions();
    notifyListeners();
    return granted;
  }

  Future<List<String>> getScheduledNotifications() async {
    return await _notificationManager.getScheduledNotifications();
  }

  Future<Map<String, dynamic>> getPermissionStatus() async {
    return await _notificationManager.getPermissionStatus();
  }

  Future<void> debugiOSNotifications() async {
    return await _notificationManager.debugiOSNotifications();
  }

  Future<void> sendSimpleiOSTest() async {
    return await _notificationManager.sendSimpleiOSTest();
  }

  // Add test notification method
  Future<void> sendTestNotification() async {
    if (_userProfile?.name != null) {
      // Use the existing craving support method as a test notification
      await _notificationManager.onHighCravingDetected(
        userName: _userProfile!.name,
        cravingLevel: 8, // High craving level to trigger support notification
      );
    }
  }

  // User Profile Management
  Future<void> createUserProfile({
    required String name,
    DateTime? soberDate,
    String substanceType = 'alcohol',
    double dailyCost = 15.0,
    UsageFrequency usageFrequency = UsageFrequency.occasionally,
  }) async {
    _setLoading(true);
    try {
      final profile = UserProfile.create(
        name: name,
        soberDate: soberDate,
        substanceType: substanceType,
        dailyCost: dailyCost,
        usageFrequency: usageFrequency,
      );

      await _databaseService.saveUserProfile(profile);
      _userProfile = profile;

      if (soberDate != null) {
        await _updateMilestonesForSobriety(soberDate);
      }

      // Setup notifications for new user
      await _notificationManager.setupUserNotifications(
        userProfile: profile,
        appSettings: _appSettings,
      );

      _clearError();
      notifyListeners();
    } catch (e) {
      _setError('Failed to create user profile: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateSoberDate(DateTime soberDate) async {
    if (_userProfile == null) return;

    _setLoading(true);
    try {
      final updatedProfile = _userProfile!.copyWith(soberDate: soberDate);
      await _databaseService.updateUserProfile(updatedProfile);
      _userProfile = updatedProfile;

      await _updateMilestonesForSobriety(soberDate);

      // Update notifications with new sober date
      await _notificationManager.setupUserNotifications(
        userProfile: updatedProfile,
        appSettings: _appSettings,
      );

      _clearError();
      notifyListeners();
    } catch (e) {
      _setError('Failed to update sober date: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateUserProfile({
    String? name,
    String? substanceType,
    double? dailyCost,
    UsageFrequency? usageFrequency,
  }) async {
    if (_userProfile == null) return;

    _setLoading(true);
    try {
      final updatedProfile = _userProfile!.copyWith(
        name: name,
        substanceType: substanceType,
        dailyCost: dailyCost,
        usageFrequency: usageFrequency,
      );

      await _databaseService.updateUserProfile(updatedProfile);
      _userProfile = updatedProfile;

      // Update notifications if name changed
      if (name != null) {
        await _notificationManager.setupUserNotifications(
          userProfile: updatedProfile,
          appSettings: _appSettings,
        );
      }

      _clearError();
      notifyListeners();
    } catch (e) {
      _setError('Failed to update user profile: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Daily Check-in Management
  void updateCurrentMood(int mood) {
    _currentMood = mood;
    notifyListeners();
  }

  void updateCurrentCravingLevel(int level) {
    _currentCravingLevel = level;
    notifyListeners();
  }

  void updateCurrentReflection(String reflection) {
    _currentReflection = reflection;
    notifyListeners();
  }

  Future<bool> saveDailyCheckIn() async {
    _setLoading(true);
    try {
      final checkIn = DailyCheckIn.create(
        mood: _currentMood,
        cravingLevel: _currentCravingLevel,
        reflection: _currentReflection,
      );

      await _databaseService.saveDailyCheckIn(checkIn);

      // Update local list
      _dailyCheckIns.removeWhere((c) =>
          c.date.year == checkIn.date.year &&
          c.date.month == checkIn.date.month &&
          c.date.day == checkIn.date.day);
      _dailyCheckIns.insert(0, checkIn);

      // Handle notification responses to check-in
      if (_userProfile != null) {
        await _notificationManager.onDailyCheckInComplete(
          checkIn: checkIn,
          userName: _userProfile!.name,
        );
      }

      // Reset form
      _currentMood = 5;
      _currentCravingLevel = 1;
      _currentReflection = '';

      _clearError();
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to save daily check-in: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Data Loading Methods
  Future<void> _loadUserProfile() async {
    _userProfile = await _databaseService.getUserProfile();
  }

  Future<void> _loadDailyCheckIns() async {
    _dailyCheckIns = await _databaseService.getDailyCheckIns(limit: 50);
  }

  Future<void> _loadMilestones() async {
    _milestones = await _databaseService.getMilestones();
  }

  Future<void> _loadAppSettings() async {
    _appSettings = await _databaseService.getAppSettings();
  }

  Future<void> _updateMilestonesForSobriety(DateTime soberDate) async {
    // Store previous milestones to detect new achievements
    final previousMilestones = List<Milestone>.from(_milestones);

    await _databaseService.updateMilestonesBasedOnSobriety(soberDate);
    await _loadMilestones();

    // Check for newly achieved milestones and send notifications
    if (_userProfile != null) {
      for (final milestone in _milestones) {
        final wasAlreadyAchieved = previousMilestones
            .where((m) => m.days == milestone.days && m.achieved)
            .isNotEmpty;

        if (milestone.achieved && !wasAlreadyAchieved) {
          await _notificationManager.onMilestoneAchieved(
            milestone: milestone,
            userName: _userProfile!.name,
          );
        }
      }
    }
  }

  // App Settings Management
  Future<void> updateAppSettings(AppSettings settings) async {
    _setLoading(true);
    try {
      await _databaseService.saveAppSettings(settings);
      _appSettings = settings;

      // Update notification settings
      if (_userProfile != null) {
        await _notificationManager.updateNotificationSettings(
          settings: settings,
          userName: _userProfile!.name,
        );
      }

      _clearError();
      notifyListeners();
    } catch (e) {
      _setError('Failed to update app settings: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Statistics
  Future<Map<String, dynamic>> getStatistics() async {
    try {
      return await _databaseService.getStatistics();
    } catch (e) {
      _setError('Failed to load statistics: $e');
      return {};
    }
  }

  // Data Management
  Future<void> refreshData() async {
    await initialize();
  }

  Future<void> deleteAllData() async {
    _setLoading(true);
    try {
      await _databaseService.deleteAllData();
      await _notificationManager.cancelAllNotifications();

      _userProfile = null;
      _dailyCheckIns = [];
      _milestones = [];
      await _loadMilestones(); // Reload default milestones
      _clearError();
      notifyListeners();
    } catch (e) {
      _setError('Failed to delete data: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Progress Tracking
  double getMilestoneProgress(int milestoneDays) {
    if (_userProfile?.soberDate == null) return 0.0;
    final stats = sobrietyStats!;
    return (stats.days / milestoneDays).clamp(0.0, 1.0);
  }

  int getDaysUntilMilestone(int milestoneDays) {
    if (_userProfile?.soberDate == null) return milestoneDays;
    final stats = sobrietyStats!;
    return (milestoneDays - stats.days).clamp(0, milestoneDays);
  }

  // Mood and Craving Analytics
  List<DailyCheckIn> getCheckInsForDateRange(DateTime start, DateTime end) {
    return _dailyCheckIns
        .where((checkIn) =>
            checkIn.date.isAfter(start.subtract(const Duration(days: 1))) &&
            checkIn.date.isBefore(end.add(const Duration(days: 1))))
        .toList();
  }

  double getAverageMoodForPeriod(int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    final recentCheckIns = _dailyCheckIns
        .where((checkIn) => checkIn.date.isAfter(cutoff))
        .toList();

    if (recentCheckIns.isEmpty) return 0.0;

    final sum =
        recentCheckIns.fold<double>(0, (sum, checkIn) => sum + checkIn.mood);
    return sum / recentCheckIns.length;
  }

  double getAverageCravingForPeriod(int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    final recentCheckIns = _dailyCheckIns
        .where((checkIn) => checkIn.date.isAfter(cutoff))
        .toList();

    if (recentCheckIns.isEmpty) return 0.0;

    final sum = recentCheckIns.fold<double>(
        0, (sum, checkIn) => sum + checkIn.cravingLevel);
    return sum / recentCheckIns.length;
  }

  // Migration helper for fixing frequency issue
  Future<void> fixUsageFrequencyIfNeeded() async {
    if (_userProfile != null &&
        _userProfile!.usageFrequency == UsageFrequency.daily) {
      // If the profile was created with the old default (daily), update it to occasionally
      await updateUserProfile(usageFrequency: UsageFrequency.occasionally);
    }
  }

  // Helper Methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    // Only notify listeners if not in initialization phase
    if (!_isInitializing) {
      notifyListeners();
    }
  }

  void _setError(String error) {
    _error = error;
    // Only notify listeners if not in initialization phase
    if (!_isInitializing) {
      notifyListeners();
    }
  }

  void _clearError() {
    _error = null;
    // Only notify listeners if not in initialization phase
    if (!_isInitializing) {
      notifyListeners();
    }
  }

  // Cleanup
  @override
  void dispose() {
    _notificationManager.dispose();
    super.dispose();
  }
}
