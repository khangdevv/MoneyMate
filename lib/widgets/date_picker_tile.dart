import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DatePickerTile extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onChanged;

  const DatePickerTile(
      {super.key, required this.selectedDate, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          builder: (ctx, child) => Theme(
            data: Theme.of(ctx).copyWith(
              colorScheme:
                  const ColorScheme.light(primary: Color(0xFF6C63FF)),
            ),
            child: child!,
          ),
        );
        if (date != null) onChanged(date);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(14)),
        child: Row(children: [
          const Icon(Icons.calendar_today_outlined,
              color: Colors.grey, size: 20),
          const SizedBox(width: 12),
          Text(DateFormat('d/M/yyyy').format(selectedDate),
              style: GoogleFonts.poppins(
                  fontSize: 15, color: const Color(0xFF2D3436))),
          const Spacer(),
          Icon(Icons.chevron_right, color: Colors.grey[400]),
        ]),
      ),
    );
  }
}
