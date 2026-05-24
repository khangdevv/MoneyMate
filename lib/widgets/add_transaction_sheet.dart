import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  String? selectedCategory;
  DateTime selectedDate = DateTime.now();

  final List<Map<String, dynamic>> expenseCategories = [
    {'name': 'Ăn uống', 'icon': Icons.restaurant_outlined, 'color': const Color(0xFFFF6B6B)},
    {'name': 'Di chuyển', 'icon': Icons.directions_car_outlined, 'color': const Color(0xFFFFBE0B)},
    {'name': 'Mua sắm', 'icon': Icons.shopping_bag_outlined, 'color': const Color(0xFF6C63FF)},
    {'name': 'Giải trí', 'icon': Icons.movie_outlined, 'color': const Color(0xFFE84393)},
    {'name': 'Hóa đơn', 'icon': Icons.receipt_outlined, 'color': const Color(0xFF00B894)},
    {'name': 'Sức khỏe', 'icon': Icons.medical_services_outlined, 'color': const Color(0xFF00CEC9)},
    {'name': 'Giáo dục', 'icon': Icons.school_outlined, 'color': const Color(0xFF0984E3)},
    {'name': 'Khác', 'icon': Icons.more_horiz, 'color': const Color(0xFF636E72)},
  ];

  final List<Map<String, dynamic>> incomeCategories = [
    {'name': 'Lương', 'icon': Icons.account_balance_wallet_outlined, 'color': const Color(0xFF4ECDC4)},
    {'name': 'Thưởng', 'icon': Icons.card_giftcard_outlined, 'color': const Color(0xFFFFBE0B)},
    {'name': 'Đầu tư', 'icon': Icons.trending_up, 'color': const Color(0xFF6C63FF)},
    {'name': 'Freelance', 'icon': Icons.laptop_mac_outlined, 'color': const Color(0xFFE84393)},
    {'name': 'Khác', 'icon': Icons.more_horiz, 'color': const Color(0xFF636E72)},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 20),
          Text('Thêm giao dịch',
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2D3436))),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(14)),
            child: TabBar(
              controller: _tabController,
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
              onTap: (_) => setState(() => selectedCategory = null),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildForm(expenseCategories, isExpense: true),
                _buildForm(incomeCategories, isExpense: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(List<Map<String, dynamic>> categories, {required bool isExpense}) {
    final color = isExpense ? const Color(0xFFFF6B6B) : const Color(0xFF4ECDC4);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20)),
            child: Column(children: [
              Text('Số tiền',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600])),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 36, fontWeight: FontWeight.bold, color: color),
                decoration: InputDecoration(
                  hintText: '0',
                  hintStyle: GoogleFonts.poppins(
                      fontSize: 36, fontWeight: FontWeight.bold, color: Colors.grey[300]),
                  border: InputBorder.none,
                  filled: false,
                  suffixText: '₫',
                  suffixStyle: GoogleFonts.poppins(
                      fontSize: 24, fontWeight: FontWeight.w600, color: color),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 24),
          Text('Danh mục',
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF2D3436))),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: categories.map((cat) {
              final isSelected = selectedCategory == cat['name'];
              final catColor = cat['color'] as Color;
              return GestureDetector(
                onTap: () => setState(() => selectedCategory = cat['name']),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? catColor.withValues(alpha: 0.2)
                        : const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(14),
                    border: isSelected ? Border.all(color: catColor, width: 2) : null,
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(cat['icon'] as IconData, color: catColor, size: 20),
                    const SizedBox(width: 8),
                    Text(cat['name'] as String,
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected ? catColor : Colors.grey[700])),
                  ]),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Text('Ngày',
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF2D3436))),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
                builder: (context, child) => Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(primary: Color(0xFF6C63FF)),
                  ),
                  child: child!,
                ),
              );
              if (date != null) setState(() => selectedDate = date);
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(14)),
              child: Row(children: [
                const Icon(Icons.calendar_today_outlined, color: Colors.grey),
                const SizedBox(width: 12),
                Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                    style: GoogleFonts.poppins(fontSize: 15, color: const Color(0xFF2D3436))),
                const Spacer(),
                Icon(Icons.chevron_right, color: Colors.grey[400]),
              ]),
            ),
          ),
          const SizedBox(height: 24),
          Text('Ghi chú',
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF2D3436))),
          const SizedBox(height: 12),
          TextField(
            controller: _noteController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Thêm ghi chú...',
              hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  padding: const EdgeInsets.symmetric(vertical: 16)),
              child: Text('Lưu giao dịch',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}