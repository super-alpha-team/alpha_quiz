import 'package:intl/intl.dart';

class NumberUtils {
  NumberUtils._();

  static String toMark(dynamic mark) {
    if (mark == null) {
      return '';
    }
    final formatter = NumberFormat("##0", null);
    formatter.minimumFractionDigits = 0;
    formatter.maximumFractionDigits = 2;
    return formatter.format(mark);
  }
}
