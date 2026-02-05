import '../database/database_helper.dart';
import '../models/transaction_model.dart';

class MoneyRepository {
  final DatabaseHelper _dbHelper;

  MoneyRepository(this._dbHelper);

  Future<List<MoneyTransaction>> getTransactions() async {
    final db = await _dbHelper.database;
    final result = await db.query('transactions', orderBy: 'date DESC');
    return result.map((json) => MoneyTransaction.fromMap(json)).toList();
  }

  Future<void> addTransaction(MoneyTransaction transaction) async {
    final db = await _dbHelper.database;
    await db.insert('transactions', transaction.toMap());
  }

  Future<void> deleteTransaction(int id) async {
    final db = await _dbHelper.database;
    await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }
}
