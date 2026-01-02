import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/wallet_repository_impl.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/repositories/transaction_repository.dart';
import 'database_provider.dart';

part 'repository_providers.g.dart';

@riverpod
WalletRepository walletRepository(WalletRepositoryRef ref) {
  final database = ref.watch(appDatabaseProvider);
  return WalletRepositoryImpl(database);
}

@riverpod
CategoryRepository categoryRepository(CategoryRepositoryRef ref) {
  final database = ref.watch(appDatabaseProvider);
  return CategoryRepositoryImpl(database);
}

@riverpod
TransactionRepository transactionRepository(TransactionRepositoryRef ref) {
  final database = ref.watch(appDatabaseProvider);
  return TransactionRepositoryImpl(database);
}

