import 'package:objectbox/objectbox.dart';

@Entity()
class Category {
  @Id()
  int id; // ObjectBox requires @Id() annotation for primary keys

  String name;
  String type; // "income" or "expense"
  String? icon; // Nullable string for asset name or emoji
  int color; // Stored as an ARGB integer
  double? budget; // Optional budget limit

  Category({
    this.id = 0, // Default to 0; ObjectBox auto-generates IDs
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
      id: json['id'] ?? 0, // Default to 0 for ObjectBox auto-ID
      name: json['name'],
      type: json['type'],
      icon: json['icon'],
      color: json['color'],
      budget: (json['budget'] as num?)?.toDouble(),
    );
  }

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
