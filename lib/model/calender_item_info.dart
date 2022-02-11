import 'package:hijri/digits_converter.dart';
import 'package:hijri/hijri_array.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

import 'monthly_data.dart';

class CalenderMonthItem {
  String previousMonthName = '';
  String nextMonthName = '';

  String monthName = '';

  List<ClassItemInfo> monthItems = [];
}

class ClassItemInfo {
  late String dayNo;
  late String normalDayNo;
  final int monthNo;

  late bool hasDua;
  late String dayString;
  String islamicYear;
  String islamicMonth;

  int washerLimit = 0;

  bool get isWasheqDay {
    int day = int.parse(dayNo);

    if (monthNo == 6 && day == 29) {
      washerLimit = 22;

      return true;
    } else if (monthNo == 7 && day == 26) {
      washerLimit = 22;

      return true;
    } else if (monthNo == 8 && day == 14) {
      washerLimit = 14;

      return true;
    } else if ((monthNo == 9 && day == 16) ||
        (monthNo == 9 && day == 18) ||
        (monthNo == 9 && day == 20) ||
        (monthNo == 9 && day == 22) ||
        (monthNo == 9 && day == 30)) {
      washerLimit = 24;

      return true;
    }
    else if (monthNo == 9 && day == 10) {
      washerLimit = 24;
      return true;
    }
    return false;
  }

  String normalDayFullString = '';

  String get islamicDayFullString {
    return '$dayNo $islamicMonth, $islamicYear';
  }

  late bool isEmpty;
  List<MonthlyData>? data;

  late DateTime firstDate;

  late DateTime normalDate;

  ClassItemInfo(
      {this.dayNo = '',
      this.normalDayNo = '',
      this.hasDua = false,
      this.isEmpty = false,
      required this.islamicYear,
      required this.islamicMonth,
      required this.monthNo});

  static CalenderMonthItem makeMonthData(
      int monthDifference, List<MonthlyData> monthData) {
    CalenderMonthItem calenderMonthItem = CalenderMonthItem();

    List<ClassItemInfo> calenderDays = [];

    var _today = HijriCalendar.now();
    int difference = 0;

    var _today1 = _today;

    DateTime objectToUse;

    if (monthDifference > 1) {
      difference = (_today.lengthOfMonth - _today.hDay) + 1;
      for (int i = 2; i <= monthDifference; i++) {
        objectToUse = DateTime.now().add(Duration(days: difference));
        var _today = HijriCalendar.fromDate(objectToUse);
        difference = difference + _today.lengthOfMonth;
      }
    } else if (monthDifference < 0) {
      difference = _today.hDay - 1;
      objectToUse = DateTime.now().add(Duration(days: difference * -1));

      difference = difference * -1;

      _today = HijriCalendar.fromDate(objectToUse);

      for (int i = -2; i >= monthDifference; i--) {
        objectToUse = DateTime.now().add(Duration(days: difference));
        _today = HijriCalendar.fromDate(objectToUse);
        _today1 =
            HijriCalendar.fromDate(objectToUse.add(const Duration(days: -1)));

        if (_today.lengthOfMonth < _today1.lengthOfMonth) {
          //  difference = difference + 1;

        }
        difference = difference - _today.lengthOfMonth;
      }
      if (monthDifference <= -2) {
        difference = difference - _today.lengthOfMonth + 1;
      } else {
        _today =
            HijriCalendar.fromDate(objectToUse.add(const Duration(days: -1)));

        difference = difference - _today.lengthOfMonth;
      }
    } else {
      difference = (_today.lengthOfMonth - _today.hDay) + 1;
    }

    objectToUse = DateTime.now().add(Duration(days: difference));

    int emptyToAddInEnd = 0;

    _today = HijriCalendar.fromDate(objectToUse);

    calenderMonthItem.monthName = islamicMonthName[_today.hMonth];

    monthData = monthData.where((e) => e.month == _today.hMonth).toList();
    String islamicMonth = ClassItemInfo.islamicMonthName[_today.hMonth];
    String islamicYear = _today.hYear.toString();

    for (int i = 1; i <= _today.lengthOfMonth; i++) {
      ClassItemInfo calenderObject = ClassItemInfo(
          islamicMonth: islamicMonth,
          islamicYear: islamicYear,
          monthNo: _today.hMonth);

      if (i == 1) {
        emptyToAddInEnd = objectToUse.weekday - 1;
      }

      calenderObject.normalDayNo = objectToUse.day.toString();
      calenderObject.dayString = listDayString[objectToUse.weekday];

      if (calenderObject.normalDayNo == '1') {
        calenderObject.dayNo =
            HijriCalendar.fromDate(objectToUse).hDay.toString();
        calenderObject.normalDayNo =
            monthsNameEnglishShort[objectToUse.month] + ' 1';
        calenderObject.firstDate = objectToUse;
      } else {
        calenderObject.dayNo = i.toString();
      }

      objectToUse = objectToUse.add(const Duration(days: 1));

      if (calenderObject.dayNo == '1') {
        calenderObject.firstDate = objectToUse;

        objectToUse.add(const Duration(days: -1)).month;

        calenderMonthItem.previousMonthName = previousMonthName(objectToUse);
      }
      if (monthData
          .where((e) => e.day.toString() == calenderObject.dayNo)
          .toList()
          .isNotEmpty) {
        //calenderObject.data = monthData.where((e) => e.day.toString() == calenderObject.dayNo).first;

        calenderObject.data = monthData
            .where((e) => e.day.toString() == calenderObject.dayNo)
            .toList();
        /*
        if (calenderObject.data != null) {
          for (MonthlyData currentData in calenderObject.data!) {
            if (currentData.files.isNotEmpty) {

              for (Files file in currentData.files) {

                var firstWhere =
                    currentData.files.where((e) => file.title == e.title && (e.id != file.id)).toList();

                if(firstWhere.isNotEmpty) {

                  if (firstWhere[0].pdfUr.isEmpty &&
                      firstWhere[0].audioUrl.isNotEmpty &&
                      file.pdfUr.isNotEmpty) {
                    file.audioUrl = firstWhere[0].fileUrl;
                    firstWhere[0].fileToRemove = true;

                  } else if (firstWhere[0].audioUrl.isEmpty &&
                      firstWhere[0].pdfUr.isNotEmpty &&
                      file.audioUrl.isNotEmpty) {
                    file.pdfUr = firstWhere[0].fileUrl;
                    firstWhere[0].fileToRemove = true;
                  }

                }

              }

              //currentData.files = currentData.files.where((e) => e.fileToRemove == false).toList();

              print('');

            }
          }
        }
         */
      }

      _today1 = HijriCalendar.fromDate(objectToUse);

      String formattedDate = DateFormat('dd MMM, yyyy')
          .format(objectToUse.add(const Duration(days: -1)));

      calenderObject.normalDayFullString = formattedDate;

      calenderObject.normalDate = objectToUse;

      calenderDays.add(calenderObject);
    }

    calenderMonthItem.nextMonthName = nextMonthName(objectToUse);

    for (int i = 0; i < emptyToAddInEnd; i++) {
      calenderDays.insert(
          0,
          ClassItemInfo(
              isEmpty: true,
              islamicMonth: islamicMonth,
              islamicYear: islamicYear,
              monthNo: _today.hMonth));
    }
    int check = calenderDays.length % 7;
    for (int i = 0; i < 7 - check; i++) {
      calenderDays.add(ClassItemInfo(
          isEmpty: true,
          islamicMonth: islamicMonth,
          islamicYear: islamicYear,
          monthNo: _today.hMonth));
    }
    calenderMonthItem.monthItems = calenderDays;

    return calenderMonthItem;
  }

  static String nextMonthName(DateTime objectToUse) {
    DateTime dateObject = objectToUse.add(const Duration(days: 1));
    return monthsNameEnglishShort[dateObject.month] +
        ' ' +
        dateObject.year.toString().substring(2);
  }

  static String previousMonthName(DateTime objectToUse) {
    DateTime dateObject = objectToUse.add(const Duration(days: -1));

    return monthsNameEnglishShort[dateObject.month] +
        ' ' +
        dateObject.year.toString().substring(2);
  }

  static CalenderMonthItem previousMonth(ClassItemInfo previousMonday) {
    CalenderMonthItem calenderMonthItem = CalenderMonthItem();

    List<ClassItemInfo> calenderDays = [];
    var _today = HijriCalendar.now();

    DateTime objectToUse =
        previousMonday.firstDate.add(const Duration(days: -1));
    int emptyToAddInEnd = 0;

    _today = HijriCalendar.fromDate(objectToUse);

    objectToUse =
        previousMonday.firstDate.add(Duration(days: _today.lengthOfMonth * -1));

    _today = HijriCalendar.fromDate(objectToUse);

    calenderMonthItem.monthName = islamicMonthName[_today.hMonth];
    String islamicMonth = ClassItemInfo.islamicMonthName[_today.hMonth];
    String islamicYear = _today.hYear.toString();

    for (int i = 1; i <= _today.lengthOfMonth; i++) {
      ClassItemInfo calenderObject = ClassItemInfo(
          islamicMonth: islamicMonth,
          islamicYear: islamicYear,
          monthNo: _today.hMonth);

      if (i == 1) {
        emptyToAddInEnd = objectToUse.weekday - 1;
      }

      calenderObject.normalDayNo = objectToUse.day.toString();
      calenderObject.dayString = listDayString[objectToUse.weekday];
      if (calenderObject.normalDayNo == '1') {
        calenderObject.dayNo =
            HijriCalendar.fromDate(objectToUse).hDay.toString();
        calenderObject.normalDayNo =
            monthsNameEnglishShort[objectToUse.month] + ' 1';
      } else {
        calenderObject.dayNo = i.toString();
      }

      //        calenderObject.firstDate = objectToUse;

      calenderObject.dayNo =
          HijriCalendar.fromDate(objectToUse).hDay.toString();

      if (calenderObject.dayNo == '1') {
        calenderObject.firstDate = objectToUse;
        //calenderMonthItem.previousMonthName = previousMonthName(objectToUse);
        calenderMonthItem.previousMonthName = previousMonthName(objectToUse);
      }

      objectToUse = objectToUse.add(const Duration(days: 1));

      calenderDays.add(calenderObject);
    }

    calenderMonthItem.nextMonthName = nextMonthName(objectToUse);

    for (int i = 0; i < emptyToAddInEnd; i++) {
      calenderDays.insert(
          0,
          ClassItemInfo(
              isEmpty: true,
              islamicMonth: islamicMonth,
              islamicYear: islamicYear,
              monthNo: _today.hMonth));
    }
    int check = calenderDays.length % 7;
    for (int i = 0; i < 7 - check; i++) {
      calenderDays.add(ClassItemInfo(
          isEmpty: true,
          islamicYear: islamicMonth,
          islamicMonth: islamicYear,
          monthNo: _today.hMonth));
    }
    calenderMonthItem.monthItems = calenderDays;

    return calenderMonthItem;
  }

  static CalenderMonthItem makeCurrentMonthObject(List<MonthlyData> monthData) {
    CalenderMonthItem calenderMonthItem = CalenderMonthItem();

    var _today = HijriCalendar.now();

    List<ClassItemInfo> calenderDays = [];

    DateTime objectToUse = DateTime.now().add(Duration(days: _today.hDay * -1));

    int emptyToAddInEnd = 0;

    monthData = monthData.where((e) => e.month == _today.hMonth).toList();

    calenderMonthItem.monthName = islamicMonthName[_today.hMonth];

    String islamicMonth = ClassItemInfo.islamicMonthName[_today.hMonth];
    String islamicYear = _today.hYear.toString();

    for (int i = 1; i <= _today.lengthOfMonth; i++) {
      ClassItemInfo calenderObject = ClassItemInfo(
          islamicYear: islamicYear,
          islamicMonth: islamicMonth,
          monthNo: _today.hMonth);

      objectToUse = objectToUse.add(const Duration(days: 1));

      if (i == 1) {
        emptyToAddInEnd = objectToUse.weekday - 1;
      }

      if (_today.hDay == i) {
        calenderObject.normalDayNo = 'Today';
        calenderObject.dayNo = _today.hDay.toString();
        calenderObject.dayString = listDayString[objectToUse.weekday];
        if (_today.hDay == 1) {
          calenderObject.firstDate = objectToUse;
        }

        //normalDayNo
      } else {
        calenderObject.normalDayNo = objectToUse.day.toString();
        calenderObject.dayString = listDayString[objectToUse.weekday];
        if (calenderObject.normalDayNo == '1') {
          calenderObject.dayNo =
              HijriCalendar.fromDate(objectToUse).hDay.toString();
          calenderObject.normalDayNo =
              monthsNameEnglishShort[objectToUse.month] + ' 1';
          calenderObject.firstDate = objectToUse;
        } else {
          calenderObject.dayNo = i.toString();
        }
      }

      if (calenderObject.dayNo == '1') {
        calenderObject.firstDate = objectToUse;
        calenderMonthItem.previousMonthName = previousMonthName(objectToUse);
      }

      if (monthData
          .where((e) => e.day.toString() == calenderObject.dayNo)
          .toList()
          .isNotEmpty) {
        //calenderObject.data = monthData.where((e) => e.day.toString() == calenderObject.dayNo).first;

        calenderObject.data = monthData
            .where((e) => e.day.toString() == calenderObject.dayNo)
            .toList();
        /*
        if (calenderObject.data != null) {
          for (MonthlyData currentData in calenderObject.data!) {
            if (currentData.files.isNotEmpty) {

              for (Files file in currentData.files) {

                var firstWhere =
                    currentData.files.where((e) => file.title == e.title && (e.id != file.id)).toList();

                if(firstWhere.isNotEmpty) {

                  if (firstWhere[0].pdfUr.isEmpty &&
                      firstWhere[0].audioUrl.isNotEmpty &&
                      file.pdfUr.isNotEmpty) {
                    file.audioUrl = firstWhere[0].fileUrl;
                    firstWhere[0].fileToRemove = true;

                  } else if (firstWhere[0].audioUrl.isEmpty &&
                      firstWhere[0].pdfUr.isNotEmpty &&
                      file.audioUrl.isNotEmpty) {
                    file.pdfUr = firstWhere[0].fileUrl;
                    firstWhere[0].fileToRemove = true;
                  }

                }

              }

              //currentData.files = currentData.files.where((e) => e.fileToRemove == false).toList();

              print('');

            }
          }
        }
         */
      }

      String formattedDate = DateFormat('dd MMM, yyyy').format(objectToUse);

      calenderObject.normalDayFullString = formattedDate;

      calenderObject.normalDate = objectToUse;

      calenderDays.add(calenderObject);
    }
    calenderMonthItem.nextMonthName = nextMonthName(objectToUse);

    for (int i = 0; i < emptyToAddInEnd; i++) {
      calenderDays.insert(
          0,
          ClassItemInfo(
              isEmpty: true,
              islamicMonth: '',
              islamicYear: '',
              monthNo: _today.hMonth));
    }

    int check = calenderDays.length % 7;

    for (int i = 0; i < 7 - check; i++) {
      calenderDays.add(ClassItemInfo(
          isEmpty: true,
          islamicYear: '',
          islamicMonth: '',
          monthNo: _today.hMonth));
    }

    calenderMonthItem.monthItems = calenderDays;
    return calenderMonthItem;
  }

  static List<String> get listDayString {
    return ['', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  }

  static List<String> get monthsNameEnglishShort {
    return [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
  }

  static List<String> get fullMonthNameEnglish {
    return [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
  }

  static List<String> islamicMonthName = [
    '',
    'Moharramul Haram',
    'Safarul Muzaffar',
    'Rabiul Awwal',
    'Rabiul Akhar',
    'Jamadal Ula',
    'Jamadal Ukhra',
    'Rajabul Asab',
    'Shabanul Karim',
    'Ramazanul Moazzam',
    'Shawwalul Mukarram',
    'Zilqadatil Haram',
    'Zilhijjatil Haram',
  ];
}

//
