import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final displayName = user?.displayName ?? 'Bạn';
    final currencyFormat =
        NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
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
                      Text('Số dư hiện tại',
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              color:
                                  Colors.white.withValues(alpha: 0.8))),
                      const SizedBox(height: 8),
                      Text(currencyFormat.format(0),
                          style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: _buildBalanceItem(
                              icon: Icons.arrow_upward_rounded,
                              label: 'Thu nhập',
                              amount: currencyFormat.format(0),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                          Expanded(
                            child: _buildBalanceItem(
                              icon: Icons.arrow_downward_rounded,
                              label: 'Chi tiêu',
                              amount: currencyFormat.format(0),
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
                      onPressed: () {},
                      child: Text('Xem tất cả',
                          style: GoogleFonts.poppins(
                              color: const Color(0xFF6C63FF),
                              fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
            ),

            // Empty state placeholder (Phase 3 sẽ kết nối dữ liệu thật)
            SliverToBoxAdapter(
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
            ),
          ],
        ),
      ),
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
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.8))),
            Text(amount,
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ],
        ),
      ],
    );
  }
}