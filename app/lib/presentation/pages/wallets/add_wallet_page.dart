import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/repository_providers.dart';
import '../../../../domain/entities/wallet.dart' as domain;

part 'add_wallet_page.g.dart';

@riverpod
class AddWallet extends _$AddWallet {
  @override
  FutureOr<void> build() {}

  Future<void> addWallet({
    required String name,
    required int initialBalance,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(walletRepositoryProvider);
      final wallet = domain.Wallet(
        id: 0,
        name: name,
        initialBalance: initialBalance,
      );
      final result = await repository.createWallet(wallet);
      return result.fold(
        (error) => throw Exception(error),
        (wallet) => wallet,
      );
    });
  }
}

class AddWalletPage extends ConsumerStatefulWidget {
  const AddWalletPage({super.key});

  @override
  ConsumerState<AddWalletPage> createState() => _AddWalletPageState();
}

class _AddWalletPageState extends ConsumerState<AddWalletPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final balance = int.tryParse(_balanceController.text) ?? 0;
      await ref.read(addWalletProvider.notifier).addWallet(
            name: _nameController.text,
            initialBalance: balance,
          );

      if (mounted) {
        final state = ref.read(addWalletProvider);
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
    final addWalletState = ref.watch(addWalletProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Dompet'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Dompet',
                hintText: 'Contoh: Bank BCA',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama dompet harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _balanceController,
              decoration: const InputDecoration(
                labelText: 'Saldo Awal',
                hintText: '0',
                border: OutlineInputBorder(),
                prefixText: 'Rp ',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Saldo awal harus diisi';
                }
                if (int.tryParse(value) == null) {
                  return 'Saldo harus berupa angka';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: addWalletState.isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: addWalletState.isLoading
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
