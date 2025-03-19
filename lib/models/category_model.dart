import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int id;
  final String name;
  final String type; // "income" or "expense"
  final String? icon; // Icon data (could be asset name or emoji)
  final int color; // Store color as an integer (ARGB value)
  final double? budget; // Optional budget limit

  const Category({
    required this.id,
    required this.name,
    required this.type,
    this.icon,
    required this.color,
    this.budget,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'icon': icon,
      'color': color,
      'budget': budget,
    };
  }

  // Create a Category from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      icon: json['icon'],
      color: json['color'],
      budget: (json['budget'] as num?)?.toDouble(), // Ensure budget is double
    );
  }

  @override
  List<Object?> get props => [id, name, type, icon, color, budget];

  // Copy with method for updating properties
  Category copyWith({
    int? id,
    String? name,
    String? type,
    String? icon,
    int? color,
    double? budget,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      budget: budget ?? this.budget,
    );
  }
}
