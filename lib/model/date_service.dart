import 'package:intl/intl.dart';

class DateClass {
  static DateTime makeDateFromString(String givenDate, String format) {
    if (format.isEmpty) {
      format = "yyyy-MM-dd HH:mm:ss";
    }

    if (givenDate.isEmpty) {
      return DateTime.now();
    }

    var inputFormat = DateFormat(format);
    return inputFormat.parse(givenDate);
  }
}