import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';
import '../../domain/logic/gamification_logic.dart';
import 'dependency_injection.dart';

final userStatsProvider =
    StateNotifierProvider<UserStatsNotifier, AsyncValue<UserStats>>((ref) {
  return UserStatsNotifier(ref);
});

class UserStatsNotifier extends StateNotifier<AsyncValue<UserStats>> {
  final Ref ref;

  UserStatsNotifier(this.ref) : super(const AsyncValue.loading()) {
    loadStats();
  }

  Future<void> loadStats() async {
    try {
      final repo = ref.read(userRepositoryProvider);
      final stats = await repo.getUserStats();
      state = AsyncValue.data(stats);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> onHabitCompletion({bool isStreak = false}) async {
    final stats = state.value;
    if (stats == null) return;

    final newStats =
        GamificationLogic.awardHabitCompletion(stats, isStreak: isStreak);

    // Save to DB
    await ref.read(userRepositoryProvider).updateUserStats(newStats);

    // Update State
    state = AsyncValue.data(newStats);
  }
}
