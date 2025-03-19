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

@DataClassName('Budget') // ✅ Drift will generate the Budget model
class Budgets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()(); // ✅ Ensure name exists
  TextColumn get category => text()();
  RealColumn get amount => real()();
  RealColumn get spent => real().withDefault(const Constant(0.0))();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  IntColumn get recurrence => integer()();
}

@DataClassName('Category')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  TextColumn get type => text()(); // "income" or "expense"
  TextColumn get icon => text().nullable()();
  IntColumn get color => integer().withDefault(const Constant(0xFFFFFFFF))();
}

@DriftDatabase(tables: [Transactions, Budgets, Categories])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await _insertDefaultCategories();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 3) {
            await m.addColumn(categories, categories.color);
          }
          if (from < 4) {
            await m.addColumn(budgets, budgets.spent);
          }
        },
      );

  Future<void> _insertDefaultCategories() async {
    const defaultCategories = [
      {'name': 'Salary', 'type': 'income', 'icon': '💰', 'color': '#4CAF50'},
      {'name': 'Business', 'type': 'income', 'icon': '🏢', 'color': '#388E3C'},
      {'name': 'Investment', 'type': 'income', 'icon': '📈', 'color': '#2E7D32'},
      {'name': 'Freelance', 'type': 'income', 'icon': '🖥️', 'color': '#1B5E20'},
      {'name': 'Gifts', 'type': 'income', 'icon': '🎁', 'color': '#FFC107'},
      {'name': 'Food & Dining', 'type': 'expense', 'icon': '🍽️', 'color': '#E57373'},
      {'name': 'Transport', 'type': 'expense', 'icon': '🚗', 'color': '#D32F2F'},
      {'name': 'Healthcare', 'type': 'expense', 'icon': '🏥', 'color': '#2196F3'},
      {'name': 'Rent', 'type': 'expense', 'icon': '🏡', 'color': '#BDBDBD'},
      {'name': 'Shopping', 'type': 'expense', 'icon': '🛍️', 'color': '#795548'},
      {'name': 'Travel', 'type': 'expense', 'icon': '✈️', 'color': '#03A9F4'},
    ];

    for (var category in defaultCategories) {
      final exists = await (select(categories)..where((c) => c.name.equals(category['name'] as String)))
          .getSingleOrNull();
      if (exists == null) {
        await into(categories).insert(
          CategoriesCompanion.insert(
            name: category['name']!,
            type: category['type']!,
            icon: Value(category['icon'] ?? '🚀'),
            color: Value(int.tryParse(category['color']!.replaceFirst('#', '0xFF')) ?? 0xFFFFFFFF),
          ),
        );
      }
    }
  }

  // ✅ Transaction Queries
  Future<List<Transaction>> getAllTransactions() => select(transactions).get();
  Future<int> insertTransaction(TransactionsCompanion transaction) => into(transactions).insert(transaction);
  Future<int> deleteTransaction(int id) => (delete(transactions)..where((t) => t.id.equals(id))).go();

  // ✅ Budget Queries (Now using Drift-generated Budget)
  Future<List<Budget>> getAllBudgets() => select(budgets).get();
  Future<int> insertBudget(BudgetsCompanion budget) => into(budgets).insert(budget);
  Future<int> updateBudgetSpent(int budgetId, double spent) {
    return (update(budgets)..where((b) => b.id.equals(budgetId)))
        .write(BudgetsCompanion(spent: Value(spent)));
  }

  Future<int> deleteBudget(int id) => (delete(budgets)..where((tbl) => tbl.id.equals(id))).go();

  // ✅ Category Queries
  Future<List<Category>> getAllCategories() => select(categories).get();
  Future<int> insertCategory(CategoriesCompanion category) => into(categories).insert(category);
  Future<int> deleteCategory(int categoryId) => (delete(categories)..where((c) => c.id.equals(categoryId))).go();
  Future<int> updateCategory(CategoriesCompanion category) {
    return (update(categories)..where((c) => c.id.equals(category.id.value))).write(category);
  }

  clearCategories() {}
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.sqlite'));
    return NativeDatabase(file);
  });
}


