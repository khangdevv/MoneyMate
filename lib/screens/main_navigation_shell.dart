import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/category_provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/add_transaction_sheet.dart';
import 'home_screen.dart';
import 'category_screen.dart';
import 'profile_screen.dart';
import 'history_screen.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    final uid = context.read<AuthProvider>().user!.uid;
    context.read<CategoryProvider>().init(uid);
    context.read<TransactionProvider>().init(uid);
  }

  void _showAddTransaction() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddTransactionSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    const screens = <Widget>[
      HomeScreen(),
      CategoryScreen(),
      HistoryScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
      floatingActionButton: (_currentIndex == 3 || _currentIndex == 2)
          ? null
          : FloatingActionButton(
              onPressed: _showAddTransaction,
              backgroundColor: const Color(0xFF6C63FF),
              child: const Icon(Icons.add, color: Colors.white),
            ),
    );
  }
}
