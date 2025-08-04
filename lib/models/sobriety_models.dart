class SobrietyStats {
  final int days;
  final int weeks;
  final int months;
  final int years;

  SobrietyStats({
    required this.days,
    required this.weeks,
    required this.months,
    required this.years,
  });

  Map<String, dynamic> toJson() {
    return {
      'days': days,
      'weeks': weeks,
      'months': months,
      'years': years,
    };
  }

  factory SobrietyStats.fromJson(Map<String, dynamic> json) {
    return SobrietyStats(
      days: json['days'] ?? 0,
      weeks: json['weeks'] ?? 0,
      months: json['months'] ?? 0,
      years: json['years'] ?? 0,
    );
  }

  static SobrietyStats calculateFromDate(DateTime soberDate) {
    final now = DateTime.now();
    final difference = now.difference(soberDate);
    final days = difference.inDays;
    final weeks = (days / 7).floor();
    final months = (days / 30).floor();
    final years = (days / 365).floor();

    return SobrietyStats(
      days: days,
      weeks: weeks,
      months: months,
      years: years,
    );
  }
}

class DailyCheckIn {
  final String id;
  final DateTime date;
  final int mood;
  final int cravingLevel;
  final String reflection;
  final DateTime createdAt;

  DailyCheckIn({
    required this.id,
    required this.date,
    required this.mood,
    required this.cravingLevel,
    required this.reflection,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'mood': mood,
      'cravingLevel': cravingLevel,
      'reflection': reflection,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory DailyCheckIn.fromJson(Map<String, dynamic> json) {
    return DailyCheckIn(
      id: json['id'] ?? '',
      date: DateTime.parse(json['date']),
      mood: json['mood'] ?? 5,
      cravingLevel: json['cravingLevel'] ?? 1,
      reflection: json['reflection'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  DailyCheckIn copyWith({
    String? id,
    DateTime? date,
    int? mood,
    int? cravingLevel,
    String? reflection,
    DateTime? createdAt,
  }) {
    return DailyCheckIn(
      id: id ?? this.id,
      date: date ?? this.date,
      mood: mood ?? this.mood,
      cravingLevel: cravingLevel ?? this.cravingLevel,
      reflection: reflection ?? this.reflection,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static DailyCheckIn create({
    required int mood,
    required int cravingLevel,
    required String reflection,
    DateTime? date,
  }) {
    final now = DateTime.now();
    return DailyCheckIn(
      id: '${now.millisecondsSinceEpoch}',
      date: date ?? DateTime(now.year, now.month, now.day),
      mood: mood,
      cravingLevel: cravingLevel,
      reflection: reflection,
      createdAt: now,
    );
  }
}

class Milestone {
  final int days;
  final bool achieved;
  final String benefit;
  final DateTime? achievedDate;

  Milestone({
    required this.days,
    required this.achieved,
    required this.benefit,
    this.achievedDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'days': days,
      'achieved': achieved,
      'benefit': benefit,
      'achievedDate': achievedDate?.toIso8601String(),
    };
  }

  factory Milestone.fromJson(Map<String, dynamic> json) {
    return Milestone(
      days: json['days'] ?? 0,
      achieved: json['achieved'] ?? false,
      benefit: json['benefit'] ?? '',
      achievedDate: json['achievedDate'] != null 
          ? DateTime.parse(json['achievedDate']) 
          : null,
    );
  }

  Milestone copyWith({
    int? days,
    bool? achieved,
    String? benefit,
    DateTime? achievedDate,
  }) {
    return Milestone(
      days: days ?? this.days,
      achieved: achieved ?? this.achieved,
      benefit: benefit ?? this.benefit,
      achievedDate: achievedDate ?? this.achievedDate,
    );
  }
}

class UserProfile {
  final String id;
  final DateTime? soberDate;
  final String substanceType;
  final double dailyCost;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UsageFrequency usageFrequency;

  UserProfile({
    required this.id,
    this.soberDate,
    required this.substanceType,
    required this.dailyCost,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.usageFrequency = UsageFrequency.daily,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'soberDate': soberDate?.toIso8601String(),
      'substanceType': substanceType,
      'dailyCost': dailyCost,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'usageFrequency': usageFrequency.name,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      soberDate: json['soberDate'] != null 
          ? DateTime.parse(json['soberDate']) 
          : null,
      substanceType: json['substanceType'] ?? 'alcohol',
      dailyCost: (json['dailyCost'] ?? 15.0).toDouble(),
      name: json['name'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      usageFrequency: UsageFrequency.values.firstWhere(
        (freq) => freq.name == json['usageFrequency'],
        orElse: () => UsageFrequency.daily,
      ),
    );
  }

  UserProfile copyWith({
    String? id,
    DateTime? soberDate,
    String? substanceType,
    double? dailyCost,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    UsageFrequency? usageFrequency,
  }) {
    return UserProfile(
      id: id ?? this.id,
      soberDate: soberDate ?? this.soberDate,
      substanceType: substanceType ?? this.substanceType,
      dailyCost: dailyCost ?? this.dailyCost,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      usageFrequency: usageFrequency ?? this.usageFrequency,
    );
  }

  static UserProfile create({
    required String name,
    DateTime? soberDate,
    String substanceType = 'alcohol',
    double dailyCost = 15.0,
    UsageFrequency usageFrequency = UsageFrequency.daily,
  }) {
    final now = DateTime.now();
    return UserProfile(
      id: '${now.millisecondsSinceEpoch}',
      soberDate: soberDate,
      substanceType: substanceType,
      dailyCost: dailyCost,
      name: name,
      createdAt: now,
      updatedAt: now,
      usageFrequency: usageFrequency,
    );
  }

  double calculateMoneySaved() {
    if (soberDate == null) return 0.0;
    final stats = SobrietyStats.calculateFromDate(soberDate!);
    // Calculate money saved based on usage frequency and daily cost
    // dailyCost is what they spent per day when using
    // usageFrequency.multiplier represents how often they used (daily = 1.0, etc.)
    // Money saved = days sober * daily cost * frequency factor
    return stats.days * dailyCost * usageFrequency.multiplier;
  }

  bool get hasSoberDate => soberDate != null;

  SobrietyStats? get sobrietyStats {
    if (soberDate == null) return null;
    return SobrietyStats.calculateFromDate(soberDate!);
  }
}

class AppSettings {
  final bool notificationsEnabled;
  final String reminderTime;
  final bool dailyQuoteEnabled;
  final String theme;
  final bool analyticsEnabled;

  AppSettings({
    this.notificationsEnabled = true,
    this.reminderTime = '09:00',
    this.dailyQuoteEnabled = true,
    this.theme = 'system',
    this.analyticsEnabled = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'reminderTime': reminderTime,
      'dailyQuoteEnabled': dailyQuoteEnabled,
      'theme': theme,
      'analyticsEnabled': analyticsEnabled,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      reminderTime: json['reminderTime'] ?? '09:00',
      dailyQuoteEnabled: json['dailyQuoteEnabled'] ?? true,
      theme: json['theme'] ?? 'system',
      analyticsEnabled: json['analyticsEnabled'] ?? true,
    );
  }

  AppSettings copyWith({
    bool? notificationsEnabled,
    String? reminderTime,
    bool? dailyQuoteEnabled,
    String? theme,
    bool? analyticsEnabled,
  }) {
    return AppSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      dailyQuoteEnabled: dailyQuoteEnabled ?? this.dailyQuoteEnabled,
      theme: theme ?? this.theme,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
    );
  }
}

enum MoodLevel {
  veryPoor(1, 'Very Poor'),
  poor(2, 'Poor'),
  okay(3, 'Okay'),
  good(4, 'Good'),
  veryGood(5, 'Very Good'),
  great(6, 'Great'),
  excellent(7, 'Excellent'),
  amazing(8, 'Amazing'),
  fantastic(9, 'Fantastic'),
  perfect(10, 'Perfect');

  const MoodLevel(this.value, this.label);

  final int value;
  final String label;

  static MoodLevel fromValue(int value) {
    return MoodLevel.values.firstWhere(
      (mood) => mood.value == value,
      orElse: () => MoodLevel.okay,
    );
  }
}

enum CravingLevel {
  none(1, 'None'),
  minimal(2, 'Minimal'),
  slight(3, 'Slight'),
  mild(4, 'Mild'),
  moderate(5, 'Moderate'),
  strong(6, 'Strong'),
  veryStrong(7, 'Very Strong'),
  intense(8, 'Intense'),
  severe(9, 'Severe'),
  overwhelming(10, 'Overwhelming');

  const CravingLevel(this.value, this.label);

  final int value;
  final String label;

  static CravingLevel fromValue(int value) {
    return CravingLevel.values.firstWhere(
      (craving) => craving.value == value,
      orElse: () => CravingLevel.none,
    );
  }
}

enum UsageFrequency {
  rarely(0.1, 'Rarely (1-2 times per month)'),
  occasionally(0.25, 'Occasionally (1-2 times per week)'),
  regularly(0.5, 'Regularly (3-4 times per week)'),
  frequently(0.75, 'Frequently (5-6 times per week)'),
  daily(1.0, 'Daily');

  const UsageFrequency(this.multiplier, this.label);

  final double multiplier;
  final String label;

  static UsageFrequency fromMultiplier(double multiplier) {
    return UsageFrequency.values.firstWhere(
      (freq) => freq.multiplier == multiplier,
      orElse: () => UsageFrequency.daily,
    );
  }
}