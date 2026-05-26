import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/category_provider.dart';
import '../providers/transaction_provider.dart';

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
                _SummaryChip(
                  label: 'Thu',
                  amount: txProvider.monthlyIncome(
                    _selectedYear,
                    _selectedMonth,
                  ),
                  color: const Color(0xFF4ECDC4),
                  currencyFormat: currencyFormat,
                ),
                const SizedBox(width: 12),
                _SummaryChip(
                  label: 'Chi',
                  amount: txProvider.monthlyExpense(
                    _selectedYear,
                    _selectedMonth,
                  ),
                  color: const Color(0xFFFF6B6B),
                  currencyFormat: currencyFormat,
                ),
              ],
            ),
          ),
          Expanded(
            child: transactions.isEmpty
                ? _EmptyState(month: _selectedMonth, year: _selectedYear)
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
                        child: _TransactionTile(
                          tx: tx,
                          catEmoji: cat?.emoji ?? '💸',
                          catName: cat?.name ?? 'Khác',
                          catColor: cat?.color ?? '#95A5A6',
                          currencyFormat: currencyFormat,
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

class _SummaryChip extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final NumberFormat currencyFormat;

  const _SummaryChip({
    required this.label,
    required this.amount,
    required this.color,
    required this.currencyFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              currencyFormat.format(amount),
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final dynamic tx;
  final String catEmoji;
  final String catName;
  final String catColor;
  final NumberFormat currencyFormat;

  const _TransactionTile({
    required this.tx,
    required this.catEmoji,
    required this.catName,
    required this.catColor,
    required this.currencyFormat,
  });

  Color _hexToColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _hexToColor(catColor);
    final isIncome = tx.type == 'income';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(catEmoji, style: const TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  catName,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D3436),
                  ),
                ),
                if (tx.note.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    tx.note,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 2),
                Text(
                  DateFormat('d/M/yyyy').format(tx.date),
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.grey[400],
                  ),
                ),
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
                  : const Color(0xFFFF6B6B),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final int month;
  final int year;

  const _EmptyState({required this.month, required this.year});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 60,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'Không có giao dịch',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'tháng $month/$year',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
