class UserStats {
  final int id; // usually 1 (singleton user for now)
  final String displayName;
  final int xp;
  final int level;
  final int coins;
  final int totalHabitsCompleted;

  // These could be derived, but caching them helps performance
  final int currentStreak;
  final int longestStreak;
  final String lastActiveDate; // YYYY-MM-DD

  UserStats({
    this.id = 1,
    this.displayName = 'Hero',
    this.xp = 0,
    this.level = 1,
    this.coins = 0,
    this.totalHabitsCompleted = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    required this.lastActiveDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'display_name': displayName,
      'xp': xp,
      'level': level,
      'coins': coins,
      'total_habits_completed': totalHabitsCompleted,
      'current_streak': currentStreak,
      'longest_streak': longestStreak,
      'last_active_date': lastActiveDate,
    };
  }

  factory UserStats.fromMap(Map<String, dynamic> map) {
    return UserStats(
      id: map['id'],
      displayName: map['display_name'],
      xp: map['xp'] ?? 0,
      level: map['level'] ?? 1,
      coins: map['coins'] ?? 0,
      totalHabitsCompleted: map['total_habits_completed'] ?? 0,
      currentStreak: map['current_streak'] ?? 0,
      longestStreak: map['longest_streak'] ?? 0,
      lastActiveDate: map['last_active_date'] ?? '',
    );
  }

  UserStats copyWith({
    String? displayName,
    int? xp,
    int? level,
    int? coins,
    int? totalHabitsCompleted,
    int? currentStreak,
    int? longestStreak,
    String? lastActiveDate,
  }) {
    return UserStats(
      id: this.id,
      displayName: displayName ?? this.displayName,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      coins: coins ?? this.coins,
      totalHabitsCompleted: totalHabitsCompleted ?? this.totalHabitsCompleted,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
    );
  }
}
