import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../models/sobriety_models.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'soberpath.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // User Profile Table
    await db.execute('''
      CREATE TABLE user_profiles(
        id TEXT PRIMARY KEY,
        sober_date TEXT,
        substance_type TEXT NOT NULL,
        daily_cost REAL NOT NULL,
        name TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Daily Check-ins Table
    await db.execute('''
      CREATE TABLE daily_checkins(
        id TEXT PRIMARY KEY,
        date TEXT NOT NULL,
        mood INTEGER NOT NULL,
        craving_level INTEGER NOT NULL,
        reflection TEXT NOT NULL,
        created_at TEXT NOT NULL,
        UNIQUE(date)
      )
    ''');

    // Milestones Table
    await db.execute('''
      CREATE TABLE milestones(
        days INTEGER PRIMARY KEY,
        achieved INTEGER NOT NULL,
        benefit TEXT NOT NULL,
        achieved_date TEXT
      )
    ''');

    // App Settings Table
    await db.execute('''
      CREATE TABLE app_settings(
        id INTEGER PRIMARY KEY,
        notifications_enabled INTEGER NOT NULL,
        reminder_time TEXT NOT NULL,
        daily_quote_enabled INTEGER NOT NULL,
        theme TEXT NOT NULL,
        analytics_enabled INTEGER NOT NULL
      )
    ''');

    // Insert default milestones
    const milestones = [
      [1, "Your body begins to detox and repair itself"],
      [7, "Better sleep patterns and increased energy levels"],
      [30, "Improved mental clarity and emotional stability"],
      [60, "Enhanced immune system and better physical health"],
      [90, "Significant reduction in health risks and improved mood"],
      [180, "Major improvements in liver function and cardiovascular health"],
      [365, "Dramatically reduced risk of serious health complications"],
      [730, "Your body has healed significantly, and you've built strong recovery habits"]
    ];

    for (final milestone in milestones) {
      await db.insert('milestones', {
        'days': milestone[0],
        'achieved': 0,
        'benefit': milestone[1],
        'achieved_date': null,
      });
    }

    // Insert default settings
    await db.insert('app_settings', {
      'id': 1,
      'notifications_enabled': 1,
      'reminder_time': '09:00',
      'daily_quote_enabled': 1,
      'theme': 'system',
      'analytics_enabled': 1,
    });
  }

  // User Profile Methods
  Future<UserProfile?> getUserProfile() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('user_profiles');
    
    if (maps.isEmpty) return null;
    
    final map = maps.first;
    return UserProfile(
      id: map['id'],
      soberDate: map['sober_date'] != null ? DateTime.parse(map['sober_date']) : null,
      substanceType: map['substance_type'],
      dailyCost: map['daily_cost'],
      name: map['name'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    final db = await database;
    await db.insert(
      'user_profiles',
      {
        'id': profile.id,
        'sober_date': profile.soberDate?.toIso8601String(),
        'substance_type': profile.substanceType,
        'daily_cost': profile.dailyCost,
        'name': profile.name,
        'created_at': profile.createdAt.toIso8601String(),
        'updated_at': profile.updatedAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    final db = await database;
    await db.update(
      'user_profiles',
      {
        'sober_date': profile.soberDate?.toIso8601String(),
        'substance_type': profile.substanceType,
        'daily_cost': profile.dailyCost,
        'name': profile.name,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [profile.id],
    );
  }

  // Daily Check-in Methods
  Future<List<DailyCheckIn>> getDailyCheckIns({int? limit}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'daily_checkins',
      orderBy: 'date DESC',
      limit: limit,
    );

    return List.generate(maps.length, (i) {
      return DailyCheckIn(
        id: maps[i]['id'],
        date: DateTime.parse(maps[i]['date']),
        mood: maps[i]['mood'],
        cravingLevel: maps[i]['craving_level'],
        reflection: maps[i]['reflection'],
        createdAt: DateTime.parse(maps[i]['created_at']),
      );
    });
  }

  Future<DailyCheckIn?> getDailyCheckInByDate(DateTime date) async {
    final db = await database;
    final dateString = date.toIso8601String().split('T')[0];
    
    final List<Map<String, dynamic>> maps = await db.query(
      'daily_checkins',
      where: 'date = ?',
      whereArgs: [dateString],
    );

    if (maps.isEmpty) return null;

    final map = maps.first;
    return DailyCheckIn(
      id: map['id'],
      date: DateTime.parse(map['date']),
      mood: map['mood'],
      cravingLevel: map['craving_level'],
      reflection: map['reflection'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Future<void> saveDailyCheckIn(DailyCheckIn checkIn) async {
    final db = await database;
    await db.insert(
      'daily_checkins',
      {
        'id': checkIn.id,
        'date': checkIn.date.toIso8601String().split('T')[0],
        'mood': checkIn.mood,
        'craving_level': checkIn.cravingLevel,
        'reflection': checkIn.reflection,
        'created_at': checkIn.createdAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Milestone Methods
  Future<List<Milestone>> getMilestones() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'milestones',
      orderBy: 'days ASC',
    );

    return List.generate(maps.length, (i) {
      return Milestone(
        days: maps[i]['days'],
        achieved: maps[i]['achieved'] == 1,
        benefit: maps[i]['benefit'],
        achievedDate: maps[i]['achieved_date'] != null 
            ? DateTime.parse(maps[i]['achieved_date']) 
            : null,
      );
    });
  }

  Future<void> updateMilestone(Milestone milestone) async {
    final db = await database;
    await db.update(
      'milestones',
      {
        'achieved': milestone.achieved ? 1 : 0,
        'achieved_date': milestone.achievedDate?.toIso8601String(),
      },
      where: 'days = ?',
      whereArgs: [milestone.days],
    );
  }

  Future<void> updateMilestonesBasedOnSobriety(DateTime soberDate) async {
    final stats = SobrietyStats.calculateFromDate(soberDate);
    final milestones = await getMilestones();

    for (final milestone in milestones) {
      final wasAchieved = milestone.achieved;
      final isNowAchieved = stats.days >= milestone.days;

      if (!wasAchieved && isNowAchieved) {
        final updatedMilestone = milestone.copyWith(
          achieved: true,
          achievedDate: DateTime.now(),
        );
        await updateMilestone(updatedMilestone);
      }
    }
  }

  // App Settings Methods
  Future<AppSettings> getAppSettings() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('app_settings');
    
    if (maps.isEmpty) {
      // Return default settings if none exist
      return AppSettings();
    }
    
    final map = maps.first;
    return AppSettings(
      notificationsEnabled: map['notifications_enabled'] == 1,
      reminderTime: map['reminder_time'],
      dailyQuoteEnabled: map['daily_quote_enabled'] == 1,
      theme: map['theme'],
      analyticsEnabled: map['analytics_enabled'] == 1,
    );
  }

  Future<void> saveAppSettings(AppSettings settings) async {
    final db = await database;
    await db.update(
      'app_settings',
      {
        'notifications_enabled': settings.notificationsEnabled ? 1 : 0,
        'reminder_time': settings.reminderTime,
        'daily_quote_enabled': settings.dailyQuoteEnabled ? 1 : 0,
        'theme': settings.theme,
        'analytics_enabled': settings.analyticsEnabled ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  // Utility Methods
  Future<void> deleteAllData() async {
    final db = await database;
    await db.delete('user_profiles');
    await db.delete('daily_checkins');
    await db.update('milestones', {
      'achieved': 0,
      'achieved_date': null,
    });
  }

  Future<Map<String, dynamic>> getStatistics() async {
    final db = await database;
    
    // Get total check-ins
    final checkInCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM daily_checkins')
    ) ?? 0;

    // Get average mood
    final avgMood = await db.rawQuery(
      'SELECT AVG(mood) as avg_mood FROM daily_checkins'
    );
    final averageMood = avgMood.isNotEmpty ? avgMood.first['avg_mood'] ?? 0.0 : 0.0;

    // Get average craving level
    final avgCraving = await db.rawQuery(
      'SELECT AVG(craving_level) as avg_craving FROM daily_checkins'
    );
    final averageCraving = avgCraving.isNotEmpty ? avgCraving.first['avg_craving'] ?? 0.0 : 0.0;

    // Get milestone achievements
    final milestoneCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM milestones WHERE achieved = 1')
    ) ?? 0;

    return {
      'totalCheckIns': checkInCount,
      'averageMood': averageMood,
      'averageCraving': averageCraving,
      'milestonesAchieved': milestoneCount,
    };
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}