import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ThousandsSeparatorFormatter extends TextInputFormatter {
  final _formatter = NumberFormat.decimalPattern('vi_VN');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;
    final digits = newValue.text.replaceAll('.', '').replaceAll(',', '');
    final number = int.tryParse(digits);
    if (number == null) return oldValue;
    final formatted = _formatter.format(number);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
