import 'package:fpdart/fpdart.dart';
import '../entities/transaction.dart' as domain;

abstract class TransactionRepository {
  /// Get all transactions
  Future<Either<String, List<domain.Transaction>>> getAllTransactions();

  /// Get transactions by wallet ID
  Future<Either<String, List<domain.Transaction>>> getTransactionsByWallet(int walletId);

  /// Get transactions by category ID
  Future<Either<String, List<domain.Transaction>>> getTransactionsByCategory(int categoryId);

  /// Get transactions by date range
  Future<Either<String, List<domain.Transaction>>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  /// Get transaction by ID
  Future<Either<String, domain.Transaction?>> getTransactionById(int id);

  /// Create new transaction
  Future<Either<String, domain.Transaction>> createTransaction(domain.Transaction transaction);

  /// Update transaction
  Future<Either<String, domain.Transaction>> updateTransaction(domain.Transaction transaction);

  /// Delete transaction
  Future<Either<String, void>> deleteTransaction(int id);
}

