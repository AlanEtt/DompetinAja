import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/database/app_database.dart' as drift;
import 'package:app/data/repositories/wallet_repository_impl.dart';
import 'package:app/domain/entities/wallet.dart' as domain;

void main() {
  late drift.AppDatabase database;
  late WalletRepositoryImpl repository;

  setUp(() async {
    database = drift.AppDatabase.test();
    repository = WalletRepositoryImpl(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('WalletRepository', () {
    test('should create a wallet', () async {
      // Arrange
      final wallet = domain.Wallet(
        id: 0,
        name: 'Test Wallet',
        initialBalance: 100000,
      );

      // Act
      final result = await repository.createWallet(wallet);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (error) => fail('Should not return error: $error'),
        (createdWallet) {
          expect(createdWallet.id, greaterThan(0));
          expect(createdWallet.name, 'Test Wallet');
          expect(createdWallet.initialBalance, 100000);
        },
      );
    });

    test('should get all wallets', () async {
      // Arrange
      final wallet1 = domain.Wallet(id: 0, name: 'Wallet 1', initialBalance: 100000);
      final wallet2 = domain.Wallet(id: 0, name: 'Wallet 2', initialBalance: 200000);
      await repository.createWallet(wallet1);
      await repository.createWallet(wallet2);

      // Act
      final result = await repository.getAllWallets();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (error) => fail('Should not return error: $error'),
        (wallets) {
          expect(wallets.length, greaterThanOrEqualTo(2));
        },
      );
    });

    test('should get wallet by id', () async {
      // Arrange
      final wallet = domain.Wallet(id: 0, name: 'Test Wallet', initialBalance: 100000);
      final createResult = await repository.createWallet(wallet);
      final createdWallet = createResult.fold(
        (error) => throw Exception(error),
        (w) => w,
      );

      // Act
      final result = await repository.getWalletById(createdWallet.id);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (error) => fail('Should not return error: $error'),
        (foundWallet) {
          expect(foundWallet, isNotNull);
          expect(foundWallet!.id, createdWallet.id);
          expect(foundWallet.name, 'Test Wallet');
        },
      );
    });

    test('should update wallet', () async {
      // Arrange
      final wallet = domain.Wallet(id: 0, name: 'Old Name', initialBalance: 100000);
      final createResult = await repository.createWallet(wallet);
      final createdWallet = createResult.fold(
        (error) => throw Exception(error),
        (w) => w,
      );
      final updatedWallet = createdWallet.copyWith(name: 'New Name');

      // Act
      final result = await repository.updateWallet(updatedWallet);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (error) => fail('Should not return error: $error'),
        (wallet) {
          expect(wallet.name, 'New Name');
        },
      );
    });

    test('should delete wallet', () async {
      // Arrange
      final wallet = domain.Wallet(id: 0, name: 'Test Wallet', initialBalance: 100000);
      final createResult = await repository.createWallet(wallet);
      final createdWallet = createResult.fold(
        (error) => throw Exception(error),
        (w) => w,
      );

      // Act
      final result = await repository.deleteWallet(createdWallet.id);

      // Assert
      expect(result.isRight(), true);
      
      // Verify wallet is deleted
      final getResult = await repository.getWalletById(createdWallet.id);
      getResult.fold(
        (error) => fail('Should not return error: $error'),
        (foundWallet) {
          expect(foundWallet, isNull);
        },
      );
    });
  });
}

