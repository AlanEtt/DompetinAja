import 'package:fpdart/fpdart.dart';
import '../entities/category.dart' as domain;

abstract class CategoryRepository {
  /// Get all categories
  Future<Either<String, List<domain.Category>>> getAllCategories();

  /// Get categories by type
  Future<Either<String, List<domain.Category>>> getCategoriesByType(domain.CategoryType type);

  /// Get category by ID
  Future<Either<String, domain.Category?>> getCategoryById(int id);

  /// Create new category
  Future<Either<String, domain.Category>> createCategory(domain.Category category);

  /// Update category
  Future<Either<String, domain.Category>> updateCategory(domain.Category category);

  /// Delete category (only if no transactions use it)
  Future<Either<String, void>> deleteCategory(int id);
}

