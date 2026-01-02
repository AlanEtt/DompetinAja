import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';

enum CategoryType {
  expense,
  income,
}

@freezed
class Category with _$Category {
  const factory Category({
    required int id,
    required String name,
    required CategoryType type,
    int? iconCodePoint,
  }) = _Category;
}

