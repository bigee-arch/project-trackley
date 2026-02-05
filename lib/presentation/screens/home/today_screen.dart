import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/habit_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/habit_card.dart';
import 'add_habit_sheet.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(todaysHabitsProvider);
    final userStatsAsync = ref.watch(userStatsProvider);

    // Simple XP Calculation for Bar
    double xpProgress = 0.0;
    int currentLevelXp = 0;
    int nextLevelXp = 100; // Default

    if (userStatsAsync.value != null) {
      final stats = userStatsAsync.value!;
      // Simplified Logic matching GamificationLogic: Level = xp/200 + 1
      currentLevelXp = stats.xp % 200;
      nextLevelXp = 200;
      xpProgress = currentLevelXp / nextLevelXp;
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 140,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primary.withOpacity(0.1),
                      Theme.of(context).scaffoldBackgroundColor,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppTheme.primary,
                      child: const Icon(Icons.person,
                          color: Colors.white, size: 30),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            userStatsAsync.value?.displayName ?? 'Hero',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                'Lvl ${userStatsAsync.value?.level ?? 1}',
                                style: TextStyle(
                                    color: AppTheme.primary,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: xpProgress,
                                    minHeight: 8,
                                    backgroundColor:
                                        AppTheme.primary.withOpacity(0.2),
                                    valueColor: const AlwaysStoppedAnimation(
                                        AppTheme.primary),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$currentLevelXp / $nextLevelXp XP',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Habit List
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 80),
            sliver: habitsAsync.when(
              data: (habits) {
                if (habits.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        children: [
                          Icon(Icons.list_alt,
                              size: 60, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          const Text(
                            "No habits for today!\nTap + to start your journey.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = habits[index];
                      return HabitCard(
                        habit: item.habit,
                        isCompleted: item.isCompleted,
                        onToggle: () {
                          ref
                              .read(todaysHabitsProvider.notifier)
                              .toggleHabit(item.habit, item.isCompleted);
                        },
                      );
                    },
                    childCount: habits.length,
                  ),
                );
              },
              loading: () => const SliverToBoxAdapter(
                child: Center(
                    child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                )),
              ),
              error: (err, stack) => SliverToBoxAdapter(
                child: Text('Error: $err'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (c) => const AddHabitSheet());
        },
        icon: const Icon(Icons.add),
        label: const Text('New Habit'),
      ),
    );
  }
}
