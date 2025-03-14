import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int id;
  final String name;
  final String type; // "income" or "expense"
  final String icon; // Icon data (could be asset name or emoji)

  const Category({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'icon': icon,
    };
  }

  // Create a Category from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      icon: json['icon'],
    );
  }

  @override
  List<Object> get props => [id, name, type, icon];
}
