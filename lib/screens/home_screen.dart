import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/add_transaction_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final displayName = user?.displayName ?? 'Bạn';
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    final List<Map<String, dynamic>> transactions = [
      {
        'title': 'Trà sữa',
        'category': 'Ăn uống',
        'amount': -45000,
        'icon': Icons.local_cafe_outlined,
        'color': const Color(0xFFFF6B6B),
        'time': 'Hôm nay, 14:30',
      },
      {
        'title': 'Lương tháng 5',
        'category': 'Thu nhập',
        'amount': 15000000,
        'icon': Icons.account_balance_wallet_outlined,
        'color': const Color(0xFF4ECDC4),
        'time': 'Hôm nay, 09:00',
      },
      {
        'title': 'Grab đi làm',
        'category': 'Di chuyển',
        'amount': -32000,
        'icon': Icons.directions_car_outlined,
        'color': const Color(0xFFFFBE0B),
        'time': 'Hôm qua, 08:15',
      },
      {
        'title': 'Netflix',
        'category': 'Giải trí',
        'amount': -180000,
        'icon': Icons.movie_outlined,
        'color': const Color(0xFFE84393),
        'time': 'Hôm qua, 00:00',
      },
      {
        'title': 'Siêu thị',
        'category': 'Mua sắm',
        'amount': -520000,
        'icon': Icons.shopping_bag_outlined,
        'color': const Color(0xFF6C63FF),
        'time': '20/05, 18:45',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
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
                        displayName.isNotEmpty ? displayName[0].toUpperCase() : '👤',
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
                  IconButton(
                    onPressed: () => context.read<AuthProvider>().logout(),
                    icon: Icon(Icons.logout_rounded, color: Colors.grey[700], size: 24),
                    tooltip: 'Đăng xuất',
                  ),
                ],
              ),
            ),

            // Balance Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Text('Số dư hiện tại',
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.8))),
                    const SizedBox(height: 8),
                    Text('12.450.000₫',
                        style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _buildBalanceItem(
                            icon: Icons.arrow_downward_rounded,
                            label: 'Thu nhập',
                            amount: '+15.000.000₫',
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                        Expanded(
                          child: _buildBalanceItem(
                            icon: Icons.arrow_upward_rounded,
                            label: 'Chi tiêu',
                            amount: '-2.550.000₫',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Transactions header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Giao dịch gần đây',
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D3436))),
                  TextButton(
                    onPressed: () {},
                    child: Text('Xem tất cả',
                        style: GoogleFonts.poppins(
                            color: const Color(0xFF6C63FF), fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),

            // Transaction list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: transactions.length,
                itemBuilder: (context, index) =>
                    _buildTransactionItem(transactions[index], currencyFormat),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTransaction(context),
        backgroundColor: const Color(0xFF6C63FF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBalanceItem({
    required IconData icon,
    required String label,
    required String amount,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 12, color: Colors.white.withValues(alpha: 0.8))),
            Text(amount,
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
          ],
        ),
      ],
    );
  }

  Widget _buildTransactionItem(
      Map<String, dynamic> tx, NumberFormat currencyFormat) {
    final isIncome = (tx['amount'] as int) > 0;
    final color = tx['color'] as Color;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(tx['icon'] as IconData, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx['title'] as String,
                    style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF2D3436))),
                const SizedBox(height: 2),
                Text(tx['time'] as String,
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isIncome ? '+' : ''}${currencyFormat.format(tx['amount'])}',
                style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isIncome ? const Color(0xFF4ECDC4) : const Color(0xFFFF6B6B)),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(tx['category'] as String,
                    style: GoogleFonts.poppins(
                        fontSize: 10, color: color, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddTransactionSheet(),
    );
  }
}