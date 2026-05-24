import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../providers/auth_provider.dart';
import '../providers/category_provider.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _nameController = TextEditingController();
  String _selectedEmoji = '🍔';
  String _selectedColor = '#FF6B6B';
  String _selectedType = 'expense';

  static const _emojiList = [
    '🍔', '🚗', '🛍️', '💡', '💰', '🎮', '☕', '🏥',
    '✈️', '🍿', '📚', '🎁', '🎵', '🐶', '🏋️', '💻',
  ];
  static const _colorList = [
    '#FF6B6B', '#4ECDC4', '#FFD93D', '#6AB1FF',
    '#4CAF50', '#9B59B6', '#E67E22', '#95A5A6',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _showAddDialog() {
    _nameController.clear();
    _selectedEmoji = '🍔';
    _selectedColor = '#FF6B6B';
    _selectedType = 'expense';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Thêm danh mục',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Tên danh mục',
                    labelStyle: GoogleFonts.poppins(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ['expense', 'income'].map((type) {
                    final isSelected = _selectedType == type;
                    return GestureDetector(
                      onTap: () => setDialogState(() => _selectedType = type),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (type == 'expense'
                                  ? const Color(0xFFFF6B6B)
                                  : const Color(0xFF4CAF50))
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          type == 'expense' ? 'Chi tiêu' : 'Thu nhập',
                          style: GoogleFonts.poppins(
                            color: isSelected ? Colors.white : Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Text('Chọn Emoji',
                    style: GoogleFonts.poppins(
                        fontSize: 13, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _emojiList.map((emoji) {
                    final isSelected = _selectedEmoji == emoji;
                    return GestureDetector(
                      onTap: () =>
                          setDialogState(() => _selectedEmoji = emoji),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF6C63FF).withValues(alpha: 0.15)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected
                              ? Border.all(
                                  color: const Color(0xFF6C63FF), width: 1.5)
                              : null,
                        ),
                        child: Text(emoji,
                            style: const TextStyle(fontSize: 20)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Text('Chọn màu sắc',
                    style: GoogleFonts.poppins(
                        fontSize: 13, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _colorList.map((hex) {
                    final color =
                        Color(int.parse(hex.replaceFirst('#', '0xFF')));
                    final isSelected = _selectedColor == hex;
                    return GestureDetector(
                      onTap: () =>
                          setDialogState(() => _selectedColor = hex),
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: Colors.black45, width: 2.5)
                              : null,
                        ),
                        child: isSelected
                            ? const Icon(Icons.check,
                                color: Colors.white, size: 18)
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Hủy',
                  style: GoogleFonts.poppins(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                final name = _nameController.text.trim();
                if (name.isEmpty) return;
                final uid = context.read<AuthProvider>().user!.uid;
                final catProvider = context.read<CategoryProvider>();
                await catProvider.createCategory(
                    uid, name, _selectedEmoji, _selectedColor, _selectedType);
                if (mounted) Navigator.pop(ctx);
              },
              child: Text('Thêm',
                  style: GoogleFonts.poppins(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<CategoryProvider>().categories;
    final uid = context.read<AuthProvider>().user!.uid;
    final expense = categories.where((c) => c.type == 'expense').toList();
    final income = categories.where((c) => c.type == 'income').toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Danh mục',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D3436))),
        actions: [
          IconButton(
            onPressed: _showAddDialog,
            icon: const Icon(Icons.add, color: Color(0xFF6C63FF)),
          ),
        ],
      ),
      body: categories.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(
                      color: Color(0xFF6C63FF)),
                  const SizedBox(height: 12),
                  Text('Đang tải danh mục...',
                      style: GoogleFonts.poppins(color: Colors.grey)),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (expense.isNotEmpty) ...[
                  _sectionHeader('Chi tiêu', Icons.arrow_upward_rounded,
                      const Color(0xFFFF6B6B)),
                  const SizedBox(height: 8),
                  ...expense.map((cat) => _categoryTile(cat, uid)),
                  const SizedBox(height: 16),
                ],
                if (income.isNotEmpty) ...[
                  _sectionHeader('Thu nhập', Icons.arrow_downward_rounded,
                      const Color(0xFF4CAF50)),
                  const SizedBox(height: 8),
                  ...income.map((cat) => _categoryTile(cat, uid)),
                ],
              ],
            ),
    );
  }

  Widget _sectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 6),
        Text(title,
            style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D3436))),
      ],
    );
  }

  Widget _categoryTile(Category cat, String uid) {
    final color = Color(int.parse(cat.color.replaceFirst('#', '0xFF')));
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
              child: Text(cat.emoji,
                  style: const TextStyle(fontSize: 22))),
        ),
        title: Text(cat.name,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: const Color(0xFF2D3436))),
        trailing: cat.isDefault
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Mặc định',
                    style: GoogleFonts.poppins(
                        fontSize: 11, color: Colors.grey[600])),
              )
            : IconButton(
                icon: const Icon(Icons.delete_outline,
                    color: Colors.redAccent, size: 22),
                onPressed: () =>
                    context.read<CategoryProvider>().removeCategory(uid, cat.id),
              ),
      ),
    );
  }
}
