import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/transaction_model.dart';
import 'dependency_injection.dart';

final moneyTransactionsProvider =
    StateNotifierProvider<MoneyNotifier, AsyncValue<List<MoneyTransaction>>>(
        (ref) {
  return MoneyNotifier(ref);
});

class MoneyNotifier extends StateNotifier<AsyncValue<List<MoneyTransaction>>> {
  final Ref ref;

  MoneyNotifier(this.ref) : super(const AsyncValue.loading()) {
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    try {
      final list = await ref.read(moneyRepositoryProvider).getTransactions();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addTransaction(MoneyTransaction t) async {
    await ref.read(moneyRepositoryProvider).addTransaction(t);
    await loadTransactions();
  }

  Future<void> deleteTransaction(int id) async {
    await ref.read(moneyRepositoryProvider).deleteTransaction(id);
    await loadTransactions();
  }
}
