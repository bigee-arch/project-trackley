import '../database/database_helper.dart';
import '../models/habit_model.dart';

class HabitRepository {
  final DatabaseHelper _dbHelper;

  HabitRepository(this._dbHelper);

  Future<List<Habit>> getHabits() async {
    final db = await _dbHelper.database;
    final result = await db.query('habits', orderBy: 'created_at DESC');
    return result.map((json) => Habit.fromMap(json)).toList();
  }

  Future<int> createHabit(Habit habit) async {
    final db = await _dbHelper.database;
    return await db.insert('habits', habit.toMap());
  }

  Future<void> updateHabit(Habit habit) async {
    final db = await _dbHelper.database;
    await db.update('habits', habit.toMap(),
        where: 'id = ?', whereArgs: [habit.id]);
  }

  Future<void> deleteHabit(int id) async {
    final db = await _dbHelper.database;
    await db.delete('habits', where: 'id = ?', whereArgs: [id]);
  }

  // Logs
  Future<List<HabitLog>> getLogsForDate(DateTime date) async {
    final db = await _dbHelper.database;
    final dateStr = date.toIso8601String().split('T')[0];
    final result =
        await db.query('habit_logs', where: 'date = ?', whereArgs: [dateStr]);
    return result.map((json) => HabitLog.fromMap(json)).toList();
  }

  Future<List<HabitLog>> getLogsForHabit(int habitId) async {
    final db = await _dbHelper.database;
    final result = await db
        .query('habit_logs', where: 'habit_id = ?', whereArgs: [habitId]);
    return result.map((json) => HabitLog.fromMap(json)).toList();
  }

  Future<void> logCompletion(int habitId, DateTime date) async {
    final db = await _dbHelper.database;
    final dateStr = date.toIso8601String().split('T')[0];

    // Check if already completed
    final existing = await db.query('habit_logs',
        where: 'habit_id = ? AND date = ?', whereArgs: [habitId, dateStr]);

    if (existing.isEmpty) {
      await db.insert(
          'habit_logs', {'habit_id': habitId, 'date': dateStr, 'value': 1});
    }
  }

  Future<void> removeCompletion(int habitId, DateTime date) async {
    final db = await _dbHelper.database;
    final dateStr = date.toIso8601String().split('T')[0];
    await db.delete('habit_logs',
        where: 'habit_id = ? AND date = ?', whereArgs: [habitId, dateStr]);
  }
}
