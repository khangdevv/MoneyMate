import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/category.dart';

class CategoryDropdown extends StatelessWidget {
  final List<Category> categories;
  final Category? selected;
  final Color accentColor;
  final ValueChanged<Category?> onChanged;

  const CategoryDropdown({
    super.key,
    required this.categories,
    required this.selected,
    required this.accentColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(14)),
        child: Text('Chưa có danh mục nào',
            style:
                GoogleFonts.poppins(fontSize: 14, color: Colors.grey[400])),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(14),
        border: selected != null
            ? Border.all(color: accentColor, width: 2)
            : null,
      ),
      child: DropdownButton<Category>(
        value: selected,
        isExpanded: true,
        underline: const SizedBox.shrink(),
        menuMaxHeight: 300,
        hint: Text('Chọn danh mục...',
            style:
                GoogleFonts.poppins(fontSize: 14, color: Colors.grey[400])),
        icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey[500]),
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(14),
        items: categories.map((cat) {
          final color = _hexToColor(cat.color);
          return DropdownMenuItem<Category>(
            value: cat,
            child: Row(
              children: [
                _CategoryIcon(emoji: cat.emoji, color: color, size: 36),
                const SizedBox(width: 12),
                Text(cat.name,
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF2D3436))),
              ],
            ),
          );
        }).toList(),
        selectedItemBuilder: (context) => categories.map((cat) {
          final color = _hexToColor(cat.color);
          return Row(
            children: [
              _CategoryIcon(emoji: cat.emoji, color: color, size: 32),
              const SizedBox(width: 10),
              Text(cat.name,
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: accentColor)),
            ],
          );
        }).toList(),
        onChanged: onChanged,
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

class _CategoryIcon extends StatelessWidget {
  final String emoji;
  final Color color;
  final double size;

  const _CategoryIcon(
      {required this.emoji, required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child: Center(
        child: Text(emoji,
            style: TextStyle(fontSize: size * 0.5)),
      ),
    );
  }
}
