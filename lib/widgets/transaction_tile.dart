import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import 'app_card.dart';
import 'category_icon_badge.dart';

class TransactionTile extends StatelessWidget {
  final Transaction tx;
  final String categoryName;
  final String categoryEmoji;
  final String categoryColor;
  final NumberFormat currencyFormat;
  final bool showDate;

  const TransactionTile({
    super.key,
    required this.tx,
    required this.categoryName,
    required this.categoryEmoji,
    required this.categoryColor,
    required this.currencyFormat,
    this.showDate = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = _hexToColor(categoryColor);
    final isIncome = tx.type == 'income';

    return AppCard(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CategoryIconBadge(emoji: categoryEmoji, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  categoryName,
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
                if (showDate) ...[
                  const SizedBox(height: 2),
                  Text(
                    DateFormat('d/M/yyyy').format(tx.date),
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
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

  Color _hexToColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return Colors.grey;
    }
  }
}
