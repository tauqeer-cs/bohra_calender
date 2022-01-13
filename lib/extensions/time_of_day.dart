import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  DateTime toDate() {
    final date = DateTime.now();
    return DateTime(date.year, date.month, date.day, this.hour, this.minute);
  }
}
