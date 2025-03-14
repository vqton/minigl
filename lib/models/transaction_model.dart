import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  final int id;
  final String category;
  final double amount;
  final DateTime date;
  final String type; // "income" or "expense"

  const Transaction({
    required this.id,
    required this.category,
    required this.amount,
    required this.date,
    required this.type,
  });

  Transaction copyWith({double? amount}) {
    return Transaction(
      id: id,
      category: category,
      amount: amount ?? this.amount,
      date: date,
      type: type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      category: json['category'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      type: json['type'],
    );
  }

  @override
  List<Object> get props => [id, category, amount, date, type];
}
