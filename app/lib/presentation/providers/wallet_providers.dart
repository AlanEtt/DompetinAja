import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../domain/entities/wallet.dart' as domain;

part 'wallet_providers.g.dart';

@riverpod
Future<List<domain.Wallet>> wallets(WalletsRef ref) async {
  final repository = ref.watch(walletRepositoryProvider);
  final result = await repository.getAllWallets();
  return result.fold(
    (error) => throw Exception(error),
    (wallets) => wallets,
  );
}

