import 'package:intl/intl.dart';
import 'dart:math';

extension StringExtension on String {
  formatDateTime(String format) =>
      DateFormat(format).format(DateTime.parse(this).toLocal());

  static String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => allChars.codeUnitAt(Random().nextInt(allChars.length))));
  static  String get allChars {
     return 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
   }


}
