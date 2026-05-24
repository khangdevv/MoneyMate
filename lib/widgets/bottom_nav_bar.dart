import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onAddTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: _buildNavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: 'Trang chủ',
                  index: 0,
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  icon: Icons.category_outlined,
                  activeIcon: Icons.category_rounded,
                  label: 'Danh mục',
                  index: 1,
                ),
              ),
              if (currentIndex == 0) _buildAddButton(),
              Expanded(
                child: _buildNavItem(
                  icon: Icons.assessment_outlined,
                  activeIcon: Icons.assessment_rounded,
                  label: 'Báo cáo',
                  index: 2,
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person_rounded,
                  label: 'Tài khoản',
                  index: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF6C63FF).withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? const Color(0xFF6C63FF) : Colors.grey[500],
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? const Color(0xFF6C63FF) : Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: InkWell(
        onTap: onAddTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF6C63FF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
