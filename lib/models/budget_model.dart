import 'package:objectbox/objectbox.dart';

enum BudgetRecurrence { daily, weekly, monthly, yearly }

@Entity()
class Budget {
  @Id()
  int id = 0;

  String name;
  double amount;
  String category;
  double spent;

  @Property(type: PropertyType.int)
  int recurrenceIndex;

  @Property(type: PropertyType.date)
  DateTime startDate;

  @Property(type: PropertyType.date)
  DateTime endDate;

  Budget({
    this.id = 0,
    required this.name,
    required this.amount,
    required this.category,
    required this.spent,
    required this.recurrenceIndex, // Change from recurrence to recurrenceIndex
    required this.startDate,
    required this.endDate,
  });

  BudgetRecurrence get recurrence => BudgetRecurrence.values[recurrenceIndex];

  set recurrence(BudgetRecurrence value) => recurrenceIndex = value.index;
}