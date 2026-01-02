import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required int id,
    required int walletId,
    required int categoryId,
    required int amount,
    String? description,
    required DateTime transactionDate,
  }) = _Transaction;
}

