import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  DateTime toDateOnly() {
    return DateTime(this.year, this.month, this.day);
  }

  String format(
    String format, {
    required String locale,
  }) {
    return DateFormat(format, locale).format(this);
  }
}
