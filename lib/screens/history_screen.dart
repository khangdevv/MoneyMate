import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/category_provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/summary_chip.dart';
import '../widgets/transaction_tile.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late int _selectedMonth;
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = now.month;
    _selectedYear = now.year;
  }

  @override
  Widget build(BuildContext context) {
    final txProvider = context.watch<TransactionProvider>();
    final catMap = context.watch<CategoryProvider>().categoryMap;
    final transactions = txProvider.byMonth(_selectedYear, _selectedMonth);
    final uid = context.read<AuthProvider>().user!.uid;
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Lịch sử',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3436),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _MonthDropdown(
              month: _selectedMonth,
              year: _selectedYear,
              onChanged: (m, y) => setState(() {
                _selectedMonth = m;
                _selectedYear = y;
              }),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Expanded(
                  child: SummaryChip(
                    label: 'Thu',
                    amount: txProvider.monthlyIncome(
                      _selectedYear,
                      _selectedMonth,
                    ),
                    color: const Color(0xFF4ECDC4),
                    currencyFormat: currencyFormat,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SummaryChip(
                    label: 'Chi',
                    amount: txProvider.monthlyExpense(
                      _selectedYear,
                      _selectedMonth,
                    ),
                    color: const Color(0xFFFF6B6B),
                    currencyFormat: currencyFormat,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: transactions.isEmpty
                ? Center(
                    child: EmptyState(
                      icon: Icons.receipt_long_outlined,
                      title: 'Không có giao dịch',
                      subtitle: 'tháng $_selectedMonth/$_selectedYear',
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final tx = transactions[index];
                      final cat = catMap[tx.catId];
                      return Dismissible(
                        key: Key(tx.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.delete_outline,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        confirmDismiss: (_) => showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text(
                              'Xóa giao dịch',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            content: Text(
                              'Bạn có chắc muốn xóa?',
                              style: GoogleFonts.poppins(),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: Text(
                                  'Hủy',
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: Text(
                                  'Xóa',
                                  style: GoogleFonts.poppins(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onDismissed: (_) async {
                          await context.read<TransactionProvider>().remove(
                                uid,
                                tx.id,
                              );
                        },
                        child: TransactionTile(
                          tx: tx,
                          categoryEmoji: cat?.emoji ?? '💸',
                          categoryName: cat?.name ?? 'Khác',
                          categoryColor: cat?.color ?? '#95A5A6',
                          currencyFormat: currencyFormat,
                          showDate: true,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _MonthDropdown extends StatelessWidget {
  final int month;
  final int year;
  final void Function(int month, int year) onChanged;

  const _MonthDropdown({
    required this.month,
    required this.year,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final options = List.generate(12, (i) => DateTime(now.year, now.month - i));
    final selected = DateTime(year, month);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF6C63FF).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<DateTime>(
        value: options.firstWhere(
          (o) => o.month == selected.month && o.year == selected.year,
          orElse: () => options.first,
        ),
        underline: const SizedBox.shrink(),
        isDense: true,
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          size: 20,
          color: Color(0xFF6C63FF),
        ),
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF6C63FF),
        ),
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(12),
        items: options.map((d) {
          return DropdownMenuItem(
            value: d,
            child: Text(
              DateFormat('MM/yyyy').format(d),
              style: GoogleFonts.poppins(fontSize: 14),
            ),
          );
        }).toList(),
        onChanged: (d) {
          if (d != null) onChanged(d.month, d.year);
        },
      ),
    );
  }
}
