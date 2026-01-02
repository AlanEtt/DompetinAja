import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class Wallets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get initialBalance => integer().named('initial_balance')();
  IntColumn get iconCodePoint => integer().nullable().named('icon_code_point')();
}

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get type => integer()(); // 0: expense, 1: income
  IntColumn get iconCodePoint => integer().nullable().named('icon_code_point')();
}

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get walletId =>
      integer().references(Wallets, #id, onDelete: KeyAction.cascade)();
  IntColumn get categoryId =>
      integer().references(Categories, #id, onDelete: KeyAction.noAction)();
  IntColumn get amount => integer()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get transactionDate => dateTime().named('transaction_date')();
}

class Budgets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryId =>
      integer().references(Categories, #id, onDelete: KeyAction.cascade)();
  IntColumn get amount => integer()();
  IntColumn get periodMonth => integer().named('period_month')();
  IntColumn get periodYear => integer().named('period_year')();

  @override
  List<String> get customConstraints =>
      ['UNIQUE (category_id, period_month, period_year)'];
}

class Debts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get personName => text().named('person_name')();
  IntColumn get amount => integer()();
  IntColumn get type => integer()(); // 0: my debt, 1: my credit
  DateTimeColumn get dueDate => dateTime().nullable().named('due_date')();
  BoolColumn get isSettled =>
      boolean().named('is_settled').withDefault(const Constant(false))();
  TextColumn get description => text().nullable()();
}

class RecurringTransactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get walletId =>
      integer().references(Wallets, #id, onDelete: KeyAction.cascade)();
  IntColumn get categoryId =>
      integer().references(Categories, #id, onDelete: KeyAction.noAction)();
  IntColumn get amount => integer()();
  TextColumn get description => text().nullable()();
  TextColumn get frequency => text()(); // "daily", "weekly", "monthly"
  DateTimeColumn get startDate => dateTime().named('start_date')();
  DateTimeColumn get nextOccurrenceDate =>
      dateTime().named('next_occurrence_date')();
}

@DriftDatabase(
  tables: [
    Wallets,
    Categories,
    Transactions,
    Budgets,
    Debts,
    RecurringTransactions,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase._(QueryExecutor executor) : super(executor);

  factory AppDatabase() => AppDatabase._(_openConnection());

  /// Factory for testing with in-memory database
  factory AppDatabase.test() {
    return AppDatabase._(LazyDatabase(() async {
      return NativeDatabase.memory();
    }));
  }

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'dompetinaja.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

