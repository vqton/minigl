// lib/models/category.dart
import 'package:minigl/models/transaction.dart';

class Category {
  final int? id;
  final String name;
  final TransactionType type;
  final String color;

  Category({
    this.id,
    required this.name,
    required this.type,
    this.color = '#FF0000',
  });

  // Convert to/from JSON for database
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type.name,
    'color': color,
  };

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['id'],
    name: json['name'],
    type: TransactionType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => TransactionType.expense,
    ),
    color: json['color'] ?? '#FF0000',
  );

  Category copyWith({
    int? id,
    String? name,
    TransactionType? type,
    String? color,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      color: color ?? this.color,
    );
  }
}
