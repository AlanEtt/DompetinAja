import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../domain/entities/transaction.dart' as domain;

part 'transaction_providers.g.dart';

@riverpod
Future<List<domain.Transaction>> transactions(TransactionsRef ref) async {
  final repository = ref.watch(transactionRepositoryProvider);
  final result = await repository.getAllTransactions();
  return result.fold(
    (error) => throw Exception(error),
    (transactions) => transactions,
  );
}

