import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet.freezed.dart';

@freezed
class Wallet with _$Wallet {
  const factory Wallet({
    required int id,
    required String name,
    required int initialBalance,
    int? iconCodePoint,
  }) = _Wallet;
}

