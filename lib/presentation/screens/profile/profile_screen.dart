import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/user_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userStatsAsync = ref.watch(userStatsProvider);

    return Scaffold(
      body: userStatsAsync.when(
        data: (stats) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(stats.displayName,
                      style: const TextStyle(color: Colors.white)),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(color: Theme.of(context).primaryColor),
                      const Center(
                        child:
                            Icon(Icons.person, size: 80, color: Colors.white54),
                      ),
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      // Settings (Reset Data etc)
                    },
                  )
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader('Statistics', context),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                              child: _buildStatCard('Level', '${stats.level}')),
                          const SizedBox(width: 16),
                          Expanded(child: _buildStatCard('XP', '${stats.xp}')),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                              child: _buildStatCard('Coins', '${stats.coins}')),
                          const SizedBox(width: 16),
                          Expanded(
                              child: _buildStatCard('Habits Done',
                                  '${stats.totalHabitsCompleted}')),
                        ],
                      ),

                      const SizedBox(height: 32),
                      _buildHeader('Achievements', context),
                      const SizedBox(height: 16),
                      // Mock Achievements
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.star, color: Colors.amber),
                              title: Text('First Step'),
                              subtitle: Text('Completed your first habit'),
                            ),
                            Divider(),
                            ListTile(
                              leading: Icon(Icons.local_fire_department,
                                  color: Colors.orange),
                              title: Text('On Fire!'),
                              subtitle: Text('Reached a 7-day streak'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildHeader(String title, BuildContext context) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleLarge
          ?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:
            Colors.white.withOpacity(0.05), // Adaptive based on theme usually
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(value,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
