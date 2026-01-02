import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import '../../core/database/app_database.dart' as drift;
import '../../domain/entities/transaction.dart' as domain;
import '../../domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final drift.AppDatabase _database;

  TransactionRepositoryImpl(this._database);

  @override
  Future<Either<String, List<domain.Transaction>>> getAllTransactions() async {
    try {
      final transactions = await (_database.select(_database.transactions)
            ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]))
          .get();
      return Right(transactions.map((t) => _toEntity(t)).toList());
    } catch (e) {
      return Left('Error getting transactions: $e');
    }
  }

  @override
  Future<Either<String, List<domain.Transaction>>> getTransactionsByWallet(int walletId) async {
    try {
      final transactions = await (_database.select(_database.transactions)
            ..where((tbl) => tbl.walletId.equals(walletId))
            ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]))
          .get();
      return Right(transactions.map((t) => _toEntity(t)).toList());
    } catch (e) {
      return Left('Error getting transactions by wallet: $e');
    }
  }

  @override
  Future<Either<String, List<domain.Transaction>>> getTransactionsByCategory(int categoryId) async {
    try {
      final transactions = await (_database.select(_database.transactions)
            ..where((tbl) => tbl.categoryId.equals(categoryId))
            ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]))
          .get();
      return Right(transactions.map((t) => _toEntity(t)).toList());
    } catch (e) {
      return Left('Error getting transactions by category: $e');
    }
  }

  @override
  Future<Either<String, List<domain.Transaction>>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final transactions = await (_database.select(_database.transactions)
            ..where((tbl) => tbl.transactionDate.isBetweenValues(startDate, endDate))
            ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]))
          .get();
      return Right(transactions.map((t) => _toEntity(t)).toList());
    } catch (e) {
      return Left('Error getting transactions by date range: $e');
    }
  }

  @override
  Future<Either<String, domain.Transaction?>> getTransactionById(int id) async {
    try {
      final transaction = await (_database.select(_database.transactions)
            ..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull();
      return Right(transaction != null ? _toEntity(transaction) : null);
    } catch (e) {
      return Left('Error getting transaction: $e');
    }
  }

  @override
  Future<Either<String, domain.Transaction>> createTransaction(domain.Transaction transaction) async {
    try {
      final companion = drift.TransactionsCompanion(
        walletId: Value(transaction.walletId),
        categoryId: Value(transaction.categoryId),
        amount: Value(transaction.amount),
        description: Value(transaction.description),
        transactionDate: Value(transaction.transactionDate),
      );
      final id = await _database.into(_database.transactions).insert(companion);
      return Right(transaction.copyWith(id: id));
    } catch (e) {
      return Left('Error creating transaction: $e');
    }
  }

  @override
  Future<Either<String, domain.Transaction>> updateTransaction(domain.Transaction transaction) async {
    try {
      final companion = drift.TransactionsCompanion(
        id: Value(transaction.id),
        walletId: Value(transaction.walletId),
        categoryId: Value(transaction.categoryId),
        amount: Value(transaction.amount),
        description: Value(transaction.description),
        transactionDate: Value(transaction.transactionDate),
      );
      await (_database.update(_database.transactions)
            ..where((tbl) => tbl.id.equals(transaction.id)))
          .write(companion);
      return Right(transaction);
    } catch (e) {
      return Left('Error updating transaction: $e');
    }
  }

  @override
  Future<Either<String, void>> deleteTransaction(int id) async {
    try {
      await (_database.delete(_database.transactions)
            ..where((tbl) => tbl.id.equals(id)))
          .go();
      return const Right(null);
    } catch (e) {
      return Left('Error deleting transaction: $e');
    }
  }

  domain.Transaction _toEntity(drift.Transaction data) {
    return domain.Transaction(
      id: data.id,
      walletId: data.walletId,
      categoryId: data.categoryId,
      amount: data.amount,
      description: data.description,
      transactionDate: data.transactionDate,
    );
  }
}

