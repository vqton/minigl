import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DataClassName('Transaction')
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get category => text()();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  TextColumn get type => text()(); // "income" or "expense"
}

@DataClassName('Budget')
class Budgets extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  TextColumn get category => text()();
}

@DataClassName('Category')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  TextColumn get type => text()(); // "income" or "expense"
  TextColumn get icon => text().nullable()();
}

@DriftDatabase(tables: [Transactions, Budgets, Categories])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      await _insertDefaultCategories();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Handle schema upgrades
    },
    beforeOpen: (details) async {
      if (details.wasCreated) {
        await _insertDefaultCategories();
      }
    },
  );

  Future<void> _insertDefaultCategories() async {
    const defaultCategories = [
      // **Income Categories**
      {'name': 'Salary', 'type': 'income', 'icon': '💰'},
      {'name': 'Business', 'type': 'income', 'icon': '🏢'},
      {'name': 'Investment', 'type': 'income', 'icon': '📈'},
      {'name': 'Freelance', 'type': 'income', 'icon': '🖥️'},
      {'name': 'Rental Income', 'type': 'income', 'icon': '🏠'},
      {'name': 'Side Hustle', 'type': 'income', 'icon': '⚡'},
      {'name': 'Bonuses', 'type': 'income', 'icon': '🎁'},
      {'name': 'Pension', 'type': 'income', 'icon': '🏦'},
      {'name': 'Grants', 'type': 'income', 'icon': '🎓'},
      {'name': 'Gifts Received', 'type': 'income', 'icon': '🎀'},

      // **Expense Categories**
      {'name': 'Food & Dining', 'type': 'expense', 'icon': '🍽️'},
      {'name': 'Groceries', 'type': 'expense', 'icon': '🛒'},
      {'name': 'Transport', 'type': 'expense', 'icon': '🚗'},
      {'name': 'Fuel', 'type': 'expense', 'icon': '⛽'},
      {'name': 'Public Transport', 'type': 'expense', 'icon': '🚋'},
      {'name': 'Entertainment', 'type': 'expense', 'icon': '🎮'},
      {'name': 'Movies & Streaming', 'type': 'expense', 'icon': '📽️'},
      {'name': 'Healthcare', 'type': 'expense', 'icon': '🏥'},
      {'name': 'Insurance', 'type': 'expense', 'icon': '🛡️'},
      {'name': 'Education', 'type': 'expense', 'icon': '📚'},
      {'name': 'Childcare', 'type': 'expense', 'icon': '👶'},
      {'name': 'Debt Payments', 'type': 'expense', 'icon': '💳'},
      {'name': 'Loans', 'type': 'expense', 'icon': '🏦'},
      {'name': 'Savings & Investments', 'type': 'expense', 'icon': '💹'},
      {'name': 'Taxes', 'type': 'expense', 'icon': '💸'},
      {'name': 'Charity & Donations', 'type': 'expense', 'icon': '❤️'},
      {'name': 'Travel', 'type': 'expense', 'icon': '✈️'},
      {'name': 'Vacations', 'type': 'expense', 'icon': '🏖️'},
      {'name': 'Shopping', 'type': 'expense', 'icon': '🛍️'},
      {'name': 'Clothing', 'type': 'expense', 'icon': '👗'},
      {'name': 'Home Maintenance', 'type': 'expense', 'icon': '🏠'},
      {'name': 'Rent', 'type': 'expense', 'icon': '🏡'},
      {'name': 'Utilities', 'type': 'expense', 'icon': '💡'},
      {'name': 'Phone & Internet', 'type': 'expense', 'icon': '📞'},
      {'name': 'Subscriptions', 'type': 'expense', 'icon': '📜'},
      {'name': 'Gym & Fitness', 'type': 'expense', 'icon': '🏋️'},
      {'name': 'Gifts & Celebrations', 'type': 'expense', 'icon': '🎉'},
      {'name': 'Pets', 'type': 'expense', 'icon': '🐶'},
      {'name': 'Personal Care', 'type': 'expense', 'icon': '🧖'},
    ];

    // for (var category in defaultCategories) {
    //   await into(categories).insertOnConflictUpdate(
    //     CategoriesCompanion(
    //       name: Value(category['name'] as String),
    //       type: Value(category['type'] as String),
    //       icon: Value(category['icon'] as String),
    //     ),
    //   );
    // }
    for (var category in defaultCategories) {
      final exists =
          await (select(categories)..where(
            (c) => c.name.equals(category['name'] as String),
          )).getSingleOrNull();

      if (exists == null) {
        await into(categories).insert(
          CategoriesCompanion.insert(
            name: category['name']!,
            type: category['type']!,
            icon: category['icon'] ?? '🚀',
          ),
        );
      }
    }
  }

  Future<List<Transaction>> getAllTransactions() => select(transactions).get();
  Future<int> insertTransaction(TransactionsCompanion transaction) =>
      into(transactions).insert(transaction);
  Future<int> deleteTransaction(int id) =>
      (delete(transactions)..where((t) => t.id.equals(id))).go();

  Future<List<Budget>> getAllBudgets() => select(budgets).get();
  Future<int> insertBudget(BudgetsCompanion budget) =>
      into(budgets).insert(budget);

  Future<List<Category>> getAllCategories() => select(categories).get();
  Future<int> insertCategory(CategoriesCompanion category) =>
      into(categories).insert(category);
  Future<int> deleteCategory(int categoryId) async {
    return (delete(categories)..where((c) => c.id.equals(categoryId))).go();
  }

  Future<int> updateCategory(CategoriesCompanion category) {
    return (update(categories)
      ..where((c) => c.id.equals(category.id.value))).write(category);
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.sqlite'));
    return NativeDatabase(file);
  });
}
