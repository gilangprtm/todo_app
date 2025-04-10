import 'package:flutter/services.dart';

import 'mahas_format.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    double value = MahasFormat.currencyToDouble(newValue.text);
    String newText = MahasFormat.toCurrency(value);
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  static FilteringTextInputFormatter allow = FilteringTextInputFormatter.allow(
    RegExp(r'^(\d+)|(,)?\.?\d{0,10}'),
  );
}
