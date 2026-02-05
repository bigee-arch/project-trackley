class Habit {
  final int? id;
  final String title;
  final String description;
  final int color; // Hex value
  final int iconCode; // IconData codePoint
  final String frequencyType; // 'daily', 'weekly', 'custom'
  final String frequencyDays; // Comma separated integers (1=Mon, 7=Sun)
  final int targetPerDay;
  final DateTime createdAt;
  final bool isArchived;

  // Stats
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastCompletedDate;

  Habit({
    this.id,
    required this.title,
    this.description = '',
    required this.color,
    required this.iconCode,
    required this.frequencyType,
    this.frequencyDays = '',
    this.targetPerDay = 1,
    required this.createdAt,
    this.isArchived = false,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastCompletedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'color': color,
      'icon_code': iconCode,
      'frequency_type': frequencyType,
      'frequency_days': frequencyDays,
      'target_per_day': targetPerDay,
      'created_at': createdAt.toIso8601String(),
      'is_archived': isArchived ? 1 : 0,
      'current_streak': currentStreak,
      'longest_streak': longestStreak,
      'last_completed_date': lastCompletedDate?.toIso8601String(),
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      title: map['title'],
      description: map['description'] ?? '',
      color: map['color'],
      iconCode: map['icon_code'],
      frequencyType: map['frequency_type'],
      frequencyDays: map['frequency_days'] ?? '',
      targetPerDay: map['target_per_day'] ?? 1,
      createdAt: DateTime.parse(map['created_at']),
      isArchived: (map['is_archived'] ?? 0) == 1,
      currentStreak: map['current_streak'] ?? 0,
      longestStreak: map['longest_streak'] ?? 0,
      lastCompletedDate: map['last_completed_date'] != null
          ? DateTime.parse(map['last_completed_date'])
          : null,
    );
  }

  Habit copyWith({
    bool? isArchived,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastCompletedDate,
  }) {
    return Habit(
      id: id,
      title: title,
      description: description,
      color: color,
      iconCode: iconCode,
      frequencyType: frequencyType,
      frequencyDays: frequencyDays,
      targetPerDay: targetPerDay,
      createdAt: createdAt,
      isArchived: isArchived ?? this.isArchived,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
    );
  }
}

class HabitLog {
  final int? id;
  final int habitId;
  final DateTime date; // Store as simple YYYY-MM-DD equivalent
  final int value; // Generic value, usually 1 for completion

  HabitLog({
    this.id,
    required this.habitId,
    required this.date,
    this.value = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'habit_id': habitId,
      'date': date
          .toIso8601String()
          .split('T')[0], // Store as Date string YYYY-MM-DD
      'value': value,
    };
  }

  factory HabitLog.fromMap(Map<String, dynamic> map) {
    return HabitLog(
      id: map['id'],
      habitId: map['habit_id'],
      date: DateTime.tryParse(map['date']) ?? DateTime.now(),
      value: map['value'],
    );
  }
}
