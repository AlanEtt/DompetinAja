import 'package:go_router/go_router.dart';
import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/wallets/wallets_page.dart';
import '../../presentation/pages/wallets/add_wallet_page.dart';
import '../../presentation/pages/transactions/transactions_page.dart';
import '../../presentation/pages/transactions/add_transaction_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/wallets',
      name: 'wallets',
      builder: (context, state) => const WalletsPage(),
      routes: [
        GoRoute(
          path: 'add',
          name: 'add-wallet',
          builder: (context, state) => const AddWalletPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/transactions',
      name: 'transactions',
      builder: (context, state) => const TransactionsPage(),
      routes: [
        GoRoute(
          path: 'add',
          name: 'add-transaction',
          builder: (context, state) => const AddTransactionPage(),
        ),
      ],
    ),
  ],
);

