// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_transaction_page.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$walletsForTransactionHash() =>
    r'70d700e14f7521b9a713e7bbec6d2fa6fd45eaea';

/// See also [walletsForTransaction].
@ProviderFor(walletsForTransaction)
final walletsForTransactionProvider =
    AutoDisposeFutureProvider<List<domain.Wallet>>.internal(
  walletsForTransaction,
  name: r'walletsForTransactionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$walletsForTransactionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WalletsForTransactionRef
    = AutoDisposeFutureProviderRef<List<domain.Wallet>>;
String _$categoriesForTransactionHash() =>
    r'67f605acbc7ff71c5997430b5dbe7edca419ddd3';

/// See also [categoriesForTransaction].
@ProviderFor(categoriesForTransaction)
final categoriesForTransactionProvider =
    AutoDisposeFutureProvider<List<domain.Category>>.internal(
  categoriesForTransaction,
  name: r'categoriesForTransactionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$categoriesForTransactionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CategoriesForTransactionRef
    = AutoDisposeFutureProviderRef<List<domain.Category>>;
String _$addTransactionHash() => r'f238f5b114c306b39f53f39281ed6a62c2e651be';

/// See also [AddTransaction].
@ProviderFor(AddTransaction)
final addTransactionProvider =
    AutoDisposeAsyncNotifierProvider<AddTransaction, void>.internal(
  AddTransaction.new,
  name: r'addTransactionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$addTransactionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AddTransaction = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
