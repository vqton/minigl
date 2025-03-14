import 'package:equatable/equatable.dart';

class Budget extends Equatable {
  final int id;
  final String category;
  final double amount;
  final double spent;

  const Budget({
    required this.id,
    required this.category,
    required this.amount,
    required this.spent,
  });

  Budget copyWith({double? spent}) {
    return Budget(
      id: id,
      category: category,
      amount: amount,
      spent: spent ?? this.spent,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'amount': amount,
      'spent': spent,
    };
  }

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'],
      category: json['category'],
      amount: json['amount'],
      spent: json['spent'],
    );
  }

  @override
  List<Object> get props => [id, category, amount, spent];
}
