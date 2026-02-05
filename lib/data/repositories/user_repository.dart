import '../database/database_helper.dart';
import '../models/user_model.dart';

class UserRepository {
  final DatabaseHelper _dbHelper;

  UserRepository(this._dbHelper);

  Future<UserStats> getUserStats() async {
    final db = await _dbHelper.database;
    final result =
        await db.query('user_stats', where: 'id = ?', whereArgs: [1]);
    if (result.isNotEmpty) {
      return UserStats.fromMap(result.first);
    }
    // Should not happen as we seed in DB helper
    return UserStats(
        id: 1, lastActiveDate: DateTime.now().toIso8601String().split('T')[0]);
  }

  Future<void> updateUserStats(UserStats stats) async {
    final db = await _dbHelper.database;
    await db.update('user_stats', stats.toMap(),
        where: 'id = ?', whereArgs: [stats.id]);
  }
}
