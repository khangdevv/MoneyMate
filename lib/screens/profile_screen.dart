import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'category_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final displayName = user?.displayName ?? 'Người dùng';
    final email = user?.email ?? '';
    final initial =
        displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Tài khoản',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D3436))),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C63FF).withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(initial,
                        style: GoogleFonts.poppins(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF6C63FF))),
                  ),
                ),
                const SizedBox(height: 14),
                Text(displayName,
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2D3436))),
                const SizedBox(height: 4),
                Text(email,
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: Colors.grey[500])),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _tile(
            icon: Icons.category_rounded,
            color: const Color(0xFF6C63FF),
            title: 'Danh mục',
            subtitle: 'Quản lý danh mục chi tiêu & thu nhập',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CategoryScreen()),
            ),
          ),
          const SizedBox(height: 10),
          _tile(
            icon: Icons.currency_exchange_rounded,
            color: const Color(0xFF6AB1FF),
            title: 'Tiền tệ',
            subtitle: 'VND — Việt Nam Đồng',
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => context.read<AuthProvider>().logout(),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.redAccent,
                side: const BorderSide(color: Colors.redAccent),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              icon: const Icon(Icons.logout_rounded),
              label: Text('Đăng xuất',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile(
      {required IconData icon,
      required Color color,
      required String title,
      required String subtitle,
      VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF2D3436))),
              Text(subtitle,
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: Colors.grey[500])),
            ],
          ),
        ],
      ),
    ),
    );
  }
}