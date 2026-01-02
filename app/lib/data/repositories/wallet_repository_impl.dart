import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import '../../core/database/app_database.dart' as drift;
import '../../domain/entities/wallet.dart' as domain;
import '../../domain/repositories/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  final drift.AppDatabase _database;

  WalletRepositoryImpl(this._database);

  @override
  Future<Either<String, List<domain.Wallet>>> getAllWallets() async {
    try {
      final wallets = await _database.select(_database.wallets).get();
      return Right(wallets.map((w) => _toEntity(w)).toList());
    } catch (e) {
      return Left('Error getting wallets: $e');
    }
  }

  @override
  Future<Either<String, domain.Wallet?>> getWalletById(int id) async {
    try {
      final wallet = await (_database.select(_database.wallets)
            ..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull();
      return Right(wallet != null ? _toEntity(wallet) : null);
    } catch (e) {
      return Left('Error getting wallet: $e');
    }
  }

  @override
  Future<Either<String, domain.Wallet>> createWallet(domain.Wallet wallet) async {
    try {
      final companion = drift.WalletsCompanion(
        name: Value(wallet.name),
        initialBalance: Value(wallet.initialBalance),
        iconCodePoint: Value(wallet.iconCodePoint),
      );
      final id = await _database.into(_database.wallets).insert(companion);
      return Right(wallet.copyWith(id: id));
    } catch (e) {
      return Left('Error creating wallet: $e');
    }
  }

  @override
  Future<Either<String, domain.Wallet>> updateWallet(domain.Wallet wallet) async {
    try {
      final companion = drift.WalletsCompanion(
        id: Value(wallet.id),
        name: Value(wallet.name),
        initialBalance: Value(wallet.initialBalance),
        iconCodePoint: Value(wallet.iconCodePoint),
      );
      await (_database.update(_database.wallets)
            ..where((tbl) => tbl.id.equals(wallet.id)))
          .write(companion);
      return Right(wallet);
    } catch (e) {
      return Left('Error updating wallet: $e');
    }
  }

  @override
  Future<Either<String, void>> deleteWallet(int id) async {
    try {
      await (_database.delete(_database.wallets)
            ..where((tbl) => tbl.id.equals(id)))
          .go();
      return const Right(null);
    } catch (e) {
      return Left('Error deleting wallet: $e');
    }
  }

  domain.Wallet _toEntity(drift.Wallet data) {
    return domain.Wallet(
      id: data.id,
      name: data.name,
      initialBalance: data.initialBalance,
      iconCodePoint: data.iconCodePoint,
    );
  }
}

