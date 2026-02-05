import '../../data/models/user_model.dart';
import 'dart:math';

class GamificationLogic {
  static const int xpPerHabit = 15;
  static const int coinsPerHabit = 5;
  static const int xpPerStreakBonus = 50;

  /// Calculates new stats after completing a habit
  static UserStats awardHabitCompletion(UserStats current,
      {bool isStreak = false}) {
    int newXp = current.xp + xpPerHabit + (isStreak ? xpPerStreakBonus : 0);
    int newCoins = current.coins + coinsPerHabit;
    int newTotal = current.totalHabitsCompleted + 1;

    // Level Calculation: Level = 0.1 * sqrt(XP) or simple thresholds
    // Let's use: XP needed for next level = Level * 100
    // Current Level logic: Level 1 (0-99), Level 2 (100-299), etc.
    // Simple: Level = floor(X / 100) + 1?
    // Let's do: Level up every 200 XP for simplicity or Use a quadratic curve.
    // Level N requires 100 * N * (N-1) / 2 XP ? No, too complex.
    // Linear progression for MVP: Level = (XP / 100).floor() + 1

    int newLevel = (newXp / 200).floor() + 1;

    return current.copyWith(
      xp: newXp,
      coins: newCoins,
      level: newLevel,
      totalHabitsCompleted: newTotal,
    );
  }
}
