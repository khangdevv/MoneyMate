import 'package:flutter/material.dart';
import 'package:moneymate/providers/budget_provider.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/category_provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/bottom_nav_bar.dart';
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
    context.read<BudgetProvider>().init(uid);
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
    );
  }
}
