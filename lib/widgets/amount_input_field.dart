import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/thousands_formatter.dart';

class AmountInputField extends StatelessWidget {
  final TextEditingController controller;
  final Color color;

  const AmountInputField(
      {super.key, required this.controller, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Text('Số tiền',
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600])),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              ThousandsSeparatorFormatter(),
            ],
            style: GoogleFonts.poppins(
                fontSize: 36, fontWeight: FontWeight.bold, color: color),
            decoration: InputDecoration(
              hintText: '0',
              hintStyle: GoogleFonts.poppins(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[300]),
              border: InputBorder.none,
              filled: false,
              contentPadding: EdgeInsets.zero,
              suffixText: '₫',
              suffixStyle: GoogleFonts.poppins(
                  fontSize: 22, fontWeight: FontWeight.w600, color: color),
            ),
          ),
        ],
      ),
    );
  }
}
