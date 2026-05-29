import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/category_provider.dart';
import '../providers/transaction_provider.dart';
import '../providers/budget_provider.dart';
import '../widgets/add_transaction_sheet.dart';
import '../widgets/balance_item.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showAddTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddTransactionSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final displayName = user?.displayName ?? 'Bạn';
    final now = DateTime.now();
    final txProvider = context.watch<TransactionProvider>();
    final catMap = context.watch<CategoryProvider>().categoryMap;
    final bgProvider = context.watch<BudgetProvider>();
    final currencyFormat =NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    final income = txProvider.monthlyIncome(now.year, now.month);
    final expense = txProvider.monthlyExpense(now.year, now.month);
    final balance = income - expense;
    final recentTxs = txProvider.transactions.take(10).toList();
    final budget = bgProvider.budgetLimit(now.year, now.month);
    final isOverBudget = budget > 0 && expense > budget;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTransaction(context),
        backgroundColor: const Color(0xFF6C63FF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          displayName.isNotEmpty
                              ? displayName[0].toUpperCase()
                              : '👤',
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF6C63FF)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Xin chào! 👋',
                              style: GoogleFonts.poppins(
                                  fontSize: 13, color: Colors.grey[600])),
                          Text(displayName,
                              style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2D3436))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            !isOverBudget ?
            // Balance Card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C63FF),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6C63FF).withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text('Số dư tháng ${now.month}/${now.year}',
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.8))),
                      const SizedBox(height: 8),
                      Text(currencyFormat.format(balance),
                          style: GoogleFonts.poppins(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: BalanceItem(
                              icon: Icons.arrow_upward_rounded,
                              label: 'Thu nhập',
                              amount: currencyFormat.format(income),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                          Expanded(
                            child: BalanceItem(
                              icon: Icons.arrow_downward_rounded,
                              label: 'Chi tiêu',
                              amount: currencyFormat.format(expense),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
            : SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 243, 108, 84),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 255, 122, 99).withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text('Số dư tháng ${now.month}/${now.year}',
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.8))),
                      const SizedBox(height: 8),
                      Text(currencyFormat.format(balance),
                          style: GoogleFonts.poppins(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: BalanceItem(
                              icon: Icons.arrow_upward_rounded,
                              label: 'Thu nhập',
                              amount: currencyFormat.format(income),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                          Expanded(
                            child: BalanceItem(
                              icon: Icons.arrow_downward_rounded,
                              label: 'Chi tiêu',
                              amount: currencyFormat.format(expense),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Recent transactions header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Giao dịch gần đây',
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2D3436))),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const HistoryScreen()),
                      ),
                      child: Text('Xem tất cả',
                          style: GoogleFonts.poppins(
                              color: const Color(0xFF6C63FF),
                              fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
            ),

            // Transaction list
            recentTxs.isEmpty
                ? SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.receipt_long_outlined,
                                size: 48, color: Colors.grey.shade300),
                            const SizedBox(height: 12),
                            Text('Chưa có giao dịch nào',
                                style: GoogleFonts.poppins(
                                    color: Colors.grey.shade400,
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(height: 4),
                            Text('Nhấn + để thêm giao dịch đầu tiên',
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey.shade400)),
                          ],
                        ),
                      ),
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final tx = recentTxs[index];
                          final cat = catMap[tx.catId];
                          final isIncome = tx.type == 'income';
                          final catColor = _hexToColor(cat?.color ?? '#95A5A6');

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2))
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: catColor.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(cat?.emoji ?? '💸',
                                        style:
                                            const TextStyle(fontSize: 22)),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(cat?.name ?? 'Khác',
                                          style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  const Color(0xFF2D3436))),
                                      if (tx.note.isNotEmpty) ...[
                                        const SizedBox(height: 2),
                                        Text(tx.note,
                                            style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: Colors.grey[500]),
                                            maxLines: 1,
                                            overflow:
                                                TextOverflow.ellipsis),
                                      ],
                                    ],
                                  ),
                                ),
                                Text(
                                  '${isIncome ? '+' : '-'}${currencyFormat.format(tx.amount)}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: isIncome
                                          ? const Color(0xFF4ECDC4)
                                          : const Color(0xFFFF6B6B)),
                                ),
                              ],
                            ),
                          );
                        },
                        childCount: recentTxs.length,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Color _hexToColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return Colors.grey;
    }
  }
}
