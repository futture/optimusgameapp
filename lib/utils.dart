import 'package:intl/intl.dart';

class CurrencyUtil {
  static String formatKwanza(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'pt_AO',
      symbol: 'Kz',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }
}
