import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/habit_model.dart';
import 'dependency_injection.dart';
import 'user_provider.dart';

class HabitWithStatus {
  final Habit habit;
  final bool isCompleted;

  HabitWithStatus({required this.habit, required this.isCompleted});
}

// Converted to AsyncNotifier for cleaner dependency handling
final habitsProvider = AsyncNotifierProvider<HabitsNotifier, List<Habit>>(() {
  return HabitsNotifier();
});

class HabitsNotifier extends AsyncNotifier<List<Habit>> {
  @override
  Future<List<Habit>> build() async {
    return _fetchHabits();
  }

  Future<List<Habit>> _fetchHabits() async {
    return ref.read(habitRepositoryProvider).getHabits();
  }

  Future<void> addHabit(Habit habit) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(habitRepositoryProvider).createHabit(habit);
      return _fetchHabits();
    });
  }
}

final todaysHabitsProvider =
    AsyncNotifierProvider<TodaysHabitsNotifier, List<HabitWithStatus>>(() {
  return TodaysHabitsNotifier();
});

class TodaysHabitsNotifier extends AsyncNotifier<List<HabitWithStatus>> {
  @override
  Future<List<HabitWithStatus>> build() async {
    // Now we can await the future of the habitsProvider
    final habits = await ref.watch(habitsProvider.future);

    final repo = ref.read(habitRepositoryProvider);
    final today = DateTime.now();
    final logs = await repo.getLogsForDate(today);

    // Filter habits based on Frequency
    final filteredHabits = habits.where((h) {
      if (h.isArchived) return false;
      if (h.frequencyType == 'daily') return true;
      if (h.frequencyType == 'weekly') {
        int weekday = today.weekday; // 1 = Mon, 7 = Sun
        return h.frequencyDays.contains(weekday.toString());
      }
      return true; // Custom TODO
    }).toList();

    return filteredHabits.map((habit) {
      final isCompleted = logs.any((log) => log.habitId == habit.id);
      return HabitWithStatus(habit: habit, isCompleted: isCompleted);
    }).toList();
  }

  Future<void> toggleHabit(Habit habit, bool currentStatus) async {
    final repo = ref.read(habitRepositoryProvider);
    final today = DateTime.now();

    if (currentStatus) {
      await repo.removeCompletion(habit.id!, today);
      // Remove XP logic if desired
    } else {
      await repo.logCompletion(habit.id!, today);

      // Update User Stats (Award XP)
      await ref
          .read(userStatsProvider.notifier)
          .onHabitCompletion(isStreak: false);

      // Update Streak in Habit (Optional polish)
      // We accept that Habit object in list might be slightly stale regarding streak
      // until full refresh, but completion status flips immediately.
    }

    // Refresh Today's list (re-fetches logs)
    ref.invalidateSelf();

    // Also invalidate main habits to eventually update streak stats
    ref.invalidate(habitsProvider);
  }
}
