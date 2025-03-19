import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:minigl/database/app_database.dart';

// Budget Recurrence Options
enum BudgetRecurrence { none, daily, weekly, monthly, yearly, custom }

class Budget extends Equatable {
  final int id;
  final String name; // ✅ Ensure name exists
  final double amount;
  final String category; // ✅ Ensure category exists
  final DateTime startDate; // ✅ Ensure startDate exists
  final DateTime? endDate;
  final BudgetRecurrence recurrence; // ✅ Ensure recurrence exists
  final double spent;

  const Budget({
    required this.id,
    required this.name,
    required this.amount,
    required this.category,
    required this.startDate,
    this.endDate,
    this.recurrence = BudgetRecurrence.none,
    this.spent = 0.0,
  });

  // Check if the budget is exceeded
  bool get isExceeded => spent >= amount;

  // Get percentage of spending
  double get spendingPercentage => (spent / amount) * 100;

  // Alert conditions
  bool get alert50 => spendingPercentage >= 50;
  bool get alert80 => spendingPercentage >= 80;
  bool get alert100 => spendingPercentage >= 100;

  // Copy method for immutability
  Budget copyWith({
    String? name,
    String? category,
    double? amount,
    double? spent,
    DateTime? startDate,
    DateTime? endDate,
    BudgetRecurrence? recurrence,
  }) {
    return Budget(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category, // Ensure category is copied
      amount: amount ?? this.amount,
      spent: spent ?? this.spent,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      recurrence: recurrence ?? this.recurrence,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'amount': amount,
      'spent': spent,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'recurrence': recurrence.toString().split('.').last,
    };
  }

  // Convert from JSON
  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'],
      name: json['name'],
      category: json['category'], // Deserialize category
      amount: json['amount'],
      spent: json['spent'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      recurrence: BudgetRecurrence.values.firstWhere(
        (e) => e.toString().split('.').last == json['recurrence'],
        orElse: () => BudgetRecurrence.none,
      ),
    );
  }

  // Convert from Database Model
  BudgetsCompanion toDbBudget() {
    return BudgetsCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      amount: Value(amount),
      spent: Value(spent),
      startDate: Value(startDate),
      endDate: Value(endDate),
      recurrence: Value(recurrence.index), // ✅ Store as int
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    amount,
    category,
    startDate,
    endDate,
    recurrence,
    spent,
  ];
}
