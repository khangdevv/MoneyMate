import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../models/transaction.dart';
import '../providers/auth_provider.dart';
import '../providers/category_provider.dart';
import '../providers/transaction_provider.dart';
import 'amount_input_field.dart';
import 'category_dropdown.dart';
import 'date_picker_tile.dart';

class AddTransactionSheet extends StatefulWidget {
  const AddTransactionSheet({super.key});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  Category? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;

  String get _currentType =>
      _tabController.index == 0 ? 'expense' : 'income';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _selectedCategory = null);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_selectedCategory == null) {
      _showSnack('Vui lòng chọn danh mục');
      return;
    }
    final amount =
        double.tryParse(_amountController.text.replaceAll('.', '')) ?? 0;
    if (amount <= 0) {
      _showSnack('Số tiền phải lớn hơn 0');
      return;
    }

    setState(() => _isSaving = true);
    try {
      final uid = context.read<AuthProvider>().user!.uid;
      final tx = Transaction(
        id: '',
        type: _currentType,
        amount: amount,
        catId: _selectedCategory!.id,
        note: _noteController.text.trim(),
        date: _selectedDate,
        createdAt: DateTime.now(),
      );
      await context.read<TransactionProvider>().add(uid, tx);
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) _showSnack('Lỗi khi lưu giao dịch, thử lại!');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: GoogleFonts.poppins()),
      backgroundColor: Colors.redAccent,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.82,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 16),
            Text('Thêm giao dịch',
                style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D3436))),
            const SizedBox(height: 16),
            _TypeTabBar(controller: _tabController),
            const SizedBox(height: 20),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_buildForm('expense'), _buildForm('income')],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(String type) {
    final isExpense = type == 'expense';
    final color = isExpense ? const Color(0xFFFF6B6B) : const Color(0xFF4ECDC4);
    final isActiveTab = isExpense == (_tabController.index == 0);
    final categories = context
        .watch<CategoryProvider>()
        .categories
        .where((c) => c.type == type)
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AmountInputField(controller: _amountController, color: color),
          const SizedBox(height: 24),
          _label('Danh mục'),
          const SizedBox(height: 10),
          CategoryDropdown(
            categories: categories,
            selected: isActiveTab ? _selectedCategory : null,
            accentColor: color,
            onChanged: (cat) => setState(() => _selectedCategory = cat),
          ),
          const SizedBox(height: 24),
          _label('Ngày'),
          const SizedBox(height: 10),
          DatePickerTile(
            selectedDate: _selectedDate,
            onChanged: (date) => setState(() => _selectedDate = date),
          ),
          const SizedBox(height: 24),
          _label('Ghi chú'),
          const SizedBox(height: 10),
          TextField(
            controller: _noteController,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Thêm ghi chú (tùy chọn)...',
              hintStyle: GoogleFonts.poppins(
                  fontSize: 14, color: Colors.grey[400]),
            ),
          ),
          const SizedBox(height: 32),
          _SaveButton(color: color, isSaving: _isSaving, onSave: _save),
        ],
      ),
    );
  }

  Widget _label(String text) => Text(text,
      style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF2D3436)));
}

// Private widgets tightly coupled với sheet 
class _TypeTabBar extends StatelessWidget {
  final TabController controller;
  const _TypeTabBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(14)),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2))
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: const Color(0xFF2D3436),
        unselectedLabelColor: Colors.grey[500],
        labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        tabs: const [Tab(text: 'Chi tiêu'), Tab(text: 'Thu nhập')],
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  final Color color;
  final bool isSaving;
  final VoidCallback onSave;
  const _SaveButton(
      {required this.color, required this.isSaving, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isSaving ? null : onSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          disabledBackgroundColor: color.withValues(alpha: 0.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: isSaving
            ? const SizedBox(
                width: 22, height: 22,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white))
            : Text('Lưu giao dịch',
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
      ),
    );
  }
}
