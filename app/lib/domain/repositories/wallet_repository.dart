import 'package:fpdart/fpdart.dart';
import '../entities/wallet.dart' as domain;

abstract class WalletRepository {
  /// Get all wallets
  Future<Either<String, List<domain.Wallet>>> getAllWallets();

  /// Get wallet by ID
  Future<Either<String, domain.Wallet?>> getWalletById(int id);

  /// Create new wallet
  Future<Either<String, domain.Wallet>> createWallet(domain.Wallet wallet);

  /// Update wallet
  Future<Either<String, domain.Wallet>> updateWallet(domain.Wallet wallet);

  /// Delete wallet
  Future<Either<String, void>> deleteWallet(int id);
}

