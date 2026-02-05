class MoneyTransaction {
  final int? id;
  final double amount;
  final String title;
  final String category; // 'Food', 'Salary', 'Transport'
  final bool isIncome;
  final DateTime date;

  MoneyTransaction({
    this.id,
    required this.amount,
    required this.title,
    required this.category,
    required this.isIncome,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'title': title,
      'category': category,
      'is_income': isIncome ? 1 : 0,
      'date': date.toIso8601String(),
    };
  }

  factory MoneyTransaction.fromMap(Map<String, dynamic> map) {
    return MoneyTransaction(
      id: map['id'],
      amount: map['amount'],
      title: map['title'],
      category: map['category'],
      isIncome: (map['is_income'] ?? 0) == 1,
      date: DateTime.parse(map['date']),
    );
  }
}
