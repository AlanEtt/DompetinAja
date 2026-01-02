import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/repository_providers.dart';
import '../../../../domain/entities/transaction.dart' as domain;
import '../../../../domain/entities/wallet.dart' as domain;
import '../../../../domain/entities/category.dart' as domain;

part 'add_transaction_page.g.dart';

@riverpod
Future<List<domain.Wallet>> walletsForTransaction(WalletsForTransactionRef ref) async {
  final repository = ref.watch(walletRepositoryProvider);
  final result = await repository.getAllWallets();
  return result.fold(
    (error) => throw Exception(error),
    (wallets) => wallets,
  );
}

@riverpod
Future<List<domain.Category>> categoriesForTransaction(CategoriesForTransactionRef ref) async {
  final repository = ref.watch(categoryRepositoryProvider);
  final result = await repository.getAllCategories();
  return result.fold(
    (error) => throw Exception(error),
    (categories) => categories,
  );
}

@riverpod
class AddTransaction extends _$AddTransaction {
  @override
  FutureOr<void> build() {}

  Future<void> addTransaction({
    required int walletId,
    required int categoryId,
    required int amount,
    String? description,
    required DateTime transactionDate,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(transactionRepositoryProvider);
      final transaction = domain.Transaction(
        id: 0,
        walletId: walletId,
        categoryId: categoryId,
        amount: amount,
        description: description,
        transactionDate: transactionDate,
      );
      final result = await repository.createTransaction(transaction);
      return result.fold(
        (error) => throw Exception(error),
        (transaction) => transaction,
      );
    });
  }
}

class AddTransactionPage extends ConsumerStatefulWidget {
  const AddTransactionPage({super.key});

  @override
  ConsumerState<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends ConsumerState<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  int? _selectedWalletId;
  int? _selectedCategoryId;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedWalletId == null || _selectedCategoryId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih dompet dan kategori')),
        );
        return;
      }

      final amount = int.tryParse(_amountController.text) ?? 0;
      await ref.read(addTransactionProvider.notifier).addTransaction(
            walletId: _selectedWalletId!,
            categoryId: _selectedCategoryId!,
            amount: amount,
            description: _descriptionController.text.isEmpty
                ? null
                : _descriptionController.text,
            transactionDate: _selectedDate,
          );

      if (mounted) {
        final state = ref.read(addTransactionProvider);
        if (state.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.error}')),
          );
        } else {
          context.pop();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final walletsAsync = ref.watch(walletsForTransactionProvider);
    final categoriesAsync = ref.watch(categoriesForTransactionProvider);
    final addTransactionState = ref.watch(addTransactionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Transaksi'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            walletsAsync.when(
              data: (wallets) => DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Dompet',
                  border: OutlineInputBorder(),
                ),
                value: _selectedWalletId,
                items: wallets.map((wallet) {
                  return DropdownMenuItem<int>(
                    value: wallet.id,
                    child: Text(wallet.name),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedWalletId = value),
                validator: (value) =>
                    value == null ? 'Pilih dompet' : null,
              ),
              loading: () => const LinearProgressIndicator(),
              error: (error, stack) => Text('Error: $error'),
            ),
            const SizedBox(height: 16),
            categoriesAsync.when(
              data: (categories) => DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                value: _selectedCategoryId,
                items: categories.map((category) {
                  return DropdownMenuItem<int>(
                    value: category.id,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedCategoryId = value),
                validator: (value) =>
                    value == null ? 'Pilih kategori' : null,
              ),
              loading: () => const LinearProgressIndicator(),
              error: (error, stack) => Text('Error: $error'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Jumlah',
                hintText: '0',
                border: OutlineInputBorder(),
                prefixText: 'Rp ',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Jumlah harus diisi';
                }
                if (int.tryParse(value) == null) {
                  return 'Jumlah harus berupa angka';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Deskripsi (Opsional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _selectDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Tanggal',
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: addTransactionState.isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: addTransactionState.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
