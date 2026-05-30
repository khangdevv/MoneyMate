import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneymate/models/budget.dart';
import 'package:moneymate/providers/auth_provider.dart';
import 'package:moneymate/providers/budget_provider.dart';
import 'package:provider/provider.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _showBudgetDialog({Budget? budget}) {
    final now = DateTime.now();
    final isEditing = budget != null;
    _amountController.text = budget?.limitAmount.toStringAsFixed(0) ?? '';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          isEditing ? 'Sửa ngân sách' : 'Thêm ngân sách',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Số tiền',
            hintText: 'Ví dụ: 5000000',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              final limitAmount = _parseAmount(_amountController.text);
              if (limitAmount == null || limitAmount <= 0) return;

              final uid = context.read<AuthProvider>().user!.uid;
              final provider = context.read<BudgetProvider>();
              final budgetId =
                  '${now.year}_${now.month.toString().padLeft(2, '0')}';

              if (isEditing) {
                await provider.updateBudget(
                  uid,
                  now.year,
                  now.month,
                  limitAmount,
                  now,
                  budgetId,
                );
              } else {
                await provider.createBudget(
                  uid,
                  now.year,
                  now.month,
                  limitAmount,
                  now,
                );
              }

              if (!mounted) return;
              Navigator.of(context).pop();
            },
            child: Text(isEditing ? 'Lưu' : 'Thêm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final uid = context.read<AuthProvider>().user!.uid;
    final budget = _currentBudget(context.watch<BudgetProvider>().budgets, now);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Ngân sách', style: GoogleFonts.poppins()),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2D3436),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBudgetDialog(budget: budget),
        backgroundColor: const Color(0xFF6C63FF),
        child: Icon(budget == null ? Icons.add : Icons.edit),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: budget == null
            ? Center(
                child: Text(
                  'Chưa có ngân sách tháng ${now.month}/${now.year}',
                  style: GoogleFonts.poppins(color: Colors.grey[700]),
                ),
              )
            : Card(
                child: ListTile(
                  title: Text(
                    'Ngân sách tháng ${budget.month}/${budget.year}',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    '${budget.limitAmount.toStringAsFixed(0)} đ',
                    style: GoogleFonts.poppins(fontSize: 18),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => context
                            .read<BudgetProvider>()
                            .removeBudget(uid, budget.id),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Budget? _currentBudget(List<Budget> budgets, DateTime date) {
    final id = '${date.year}_${date.month.toString().padLeft(2, '0')}';
    for (final budget in budgets) {
      if (budget.id == id) return budget;
    }
    return null;
  }

  double? _parseAmount(String value) {
    return double.tryParse(value.replaceAll(RegExp(r'[^\d]'), ''));
  }
}
