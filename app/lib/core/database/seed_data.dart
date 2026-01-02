import '../database/app_database.dart' as drift;
import '../../domain/entities/category.dart' as domain;
import '../../data/repositories/category_repository_impl.dart';
import '../../data/repositories/wallet_repository_impl.dart';
import '../../domain/entities/wallet.dart' as domain;

/// Seed default categories and wallets for first-time setup
Future<void> seedDefaultData(drift.AppDatabase database) async {
  final categoryRepo = CategoryRepositoryImpl(database);
  final walletRepo = WalletRepositoryImpl(database);

  // Check if categories already exist
  final existingCategories = await categoryRepo.getAllCategories();
  final categories = existingCategories.fold((l) => <domain.Category>[], (r) => r);
  if (categories.isEmpty) {
    // Seed default categories
    final defaultCategories = [
      // Income categories
      domain.Category(id: 0, name: 'Gaji', type: domain.CategoryType.income),
      domain.Category(id: 0, name: 'Freelance', type: domain.CategoryType.income),
      domain.Category(id: 0, name: 'Bonus', type: domain.CategoryType.income),
      
      // Expense categories
      domain.Category(id: 0, name: 'Makanan', type: domain.CategoryType.expense),
      domain.Category(id: 0, name: 'Transportasi', type: domain.CategoryType.expense),
      domain.Category(id: 0, name: 'Belanja', type: domain.CategoryType.expense),
      domain.Category(id: 0, name: 'Hiburan', type: domain.CategoryType.expense),
      domain.Category(id: 0, name: 'Tagihan', type: domain.CategoryType.expense),
      domain.Category(id: 0, name: 'Kesehatan', type: domain.CategoryType.expense),
    ];

    for (final category in defaultCategories) {
      await categoryRepo.createCategory(category);
    }
  }

  // Check if wallets already exist
  final existingWallets = await walletRepo.getAllWallets();
  final wallets = existingWallets.fold((l) => <domain.Wallet>[], (r) => r);
  if (wallets.isEmpty) {
    // Seed default wallet (optional)
    final defaultWallet = domain.Wallet(
      id: 0,
      name: 'Dompet Utama',
      initialBalance: 0,
    );
    await walletRepo.createWallet(defaultWallet);
  }
}

