import 'package:objectbox/objectbox.dart';

@Entity()
class Transaction {
  @Id()
  int id = 0;

  String category;
  double amount;

  @Property(type: PropertyType.date) // ✅ Explicitly define DateTime storage
  DateTime date;

  String type; // "income" or "expense"

  Transaction({
    this.id = 0,
    required this.category,
    required this.amount,
    required this.date,
    required this.type,
  });
}
