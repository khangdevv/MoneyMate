import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Báo cáo',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D3436))),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.assessment_outlined,
                size: 72, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text('Sắp ra mắt ở Giai đoạn 5',
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey)),
            const SizedBox(height: 8),
            Text('Thống kê thu chi theo tháng',
                style: GoogleFonts.poppins(
                    fontSize: 13, color: Colors.grey.shade400)),
          ],
        ),
      ),
    );
  }
}