import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import '../../core/database/app_database.dart' as drift;
import '../../domain/entities/category.dart' as domain;
import '../../domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final drift.AppDatabase _database;

  CategoryRepositoryImpl(this._database);

  @override
  Future<Either<String, List<domain.Category>>> getAllCategories() async {
    try {
      final categories = await _database.select(_database.categories).get();
      return Right(categories.map((c) => _toEntity(c)).toList());
    } catch (e) {
      return Left('Error getting categories: $e');
    }
  }

  @override
  Future<Either<String, List<domain.Category>>> getCategoriesByType(domain.CategoryType type) async {
    try {
      final typeValue = type == domain.CategoryType.expense ? 0 : 1;
      final categories = await (_database.select(_database.categories)
            ..where((tbl) => tbl.type.equals(typeValue)))
          .get();
      return Right(categories.map((c) => _toEntity(c)).toList());
    } catch (e) {
      return Left('Error getting categories by type: $e');
    }
  }

  @override
  Future<Either<String, domain.Category?>> getCategoryById(int id) async {
    try {
      final category = await (_database.select(_database.categories)
            ..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull();
      return Right(category != null ? _toEntity(category) : null);
    } catch (e) {
      return Left('Error getting category: $e');
    }
  }

  @override
  Future<Either<String, domain.Category>> createCategory(domain.Category category) async {
    try {
      final companion = drift.CategoriesCompanion(
        name: Value(category.name),
        type: Value(category.type == domain.CategoryType.expense ? 0 : 1),
        iconCodePoint: Value(category.iconCodePoint),
      );
      final id = await _database.into(_database.categories).insert(companion);
      return Right(category.copyWith(id: id));
    } catch (e) {
      return Left('Error creating category: $e');
    }
  }

  @override
  Future<Either<String, domain.Category>> updateCategory(domain.Category category) async {
    try {
      final companion = drift.CategoriesCompanion(
        id: Value(category.id),
        name: Value(category.name),
        type: Value(category.type == domain.CategoryType.expense ? 0 : 1),
        iconCodePoint: Value(category.iconCodePoint),
      );
      await (_database.update(_database.categories)
            ..where((tbl) => tbl.id.equals(category.id)))
          .write(companion);
      return Right(category);
    } catch (e) {
      return Left('Error updating category: $e');
    }
  }

  @override
  Future<Either<String, void>> deleteCategory(int id) async {
    try {
      // Check if category is used in transactions
      final transactions = await (_database.select(_database.transactions)
            ..where((tbl) => tbl.categoryId.equals(id)))
          .get();
      
      if (transactions.isNotEmpty) {
        return const Left('Cannot delete category: it is used in transactions');
      }

      await (_database.delete(_database.categories)
            ..where((tbl) => tbl.id.equals(id)))
          .go();
      return const Right(null);
    } catch (e) {
      return Left('Error deleting category: $e');
    }
  }

  domain.Category _toEntity(drift.Category data) {
    return domain.Category(
      id: data.id,
      name: data.name,
      type: data.type == 0 ? domain.CategoryType.expense : domain.CategoryType.income,
      iconCodePoint: data.iconCodePoint,
    );
  }
}

