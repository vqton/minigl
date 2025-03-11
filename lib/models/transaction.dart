// lib/models/transaction.dart
enum TransactionType { income, expense }

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final String category; // New field

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    this.category = 'Uncategorized', // Default category
  });

  // Validation rules
  factory Transaction.create({
    required String title,
    required double amount,
    required DateTime date,
    required TransactionType type,
    String category = 'Uncategorized',
  }) {
    if (title.trim().isEmpty) {
      throw ArgumentError("Title cannot be empty");
    }
    if (amount <= 0) {
      throw ArgumentError("Amount must be greater than zero");
    }
    if (date.isAfter(DateTime.now())) {
      throw ArgumentError("Future dates are not allowed");
    }

    return Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      amount: amount,
      date: date,
      type: type,
      category: category,
    );
  }

  // JSON serialization
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'amount': amount,
    'date': date.toIso8601String(),
    'type': type.name,
    'category': category,
  };

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json['id'],
    title: json['title'],
    amount: json['amount'],
    date: DateTime.parse(json['date']),
    type: TransactionType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => TransactionType.expense,
    ),
    category: json['category'] ?? 'Uncategorized',
  );
}