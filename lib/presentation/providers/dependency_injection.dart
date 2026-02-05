import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/database_helper.dart';
import '../../data/repositories/habit_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/money_repository.dart';

// Database Instance
final databaseHelperProvider =
    Provider<DatabaseHelper>((ref) => DatabaseHelper.instance);

// Repositories
final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  return HabitRepository(ref.watch(databaseHelperProvider));
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(ref.watch(databaseHelperProvider));
});

final moneyRepositoryProvider = Provider<MoneyRepository>((ref) {
  return MoneyRepository(ref.watch(databaseHelperProvider));
});
