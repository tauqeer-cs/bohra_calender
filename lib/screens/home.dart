import 'package:bohra_calender/core/colors.dart';
import 'package:bohra_calender/core/constants.dart';
import 'package:bohra_calender/model/calender_item_info.dart';
import 'package:bohra_calender/model/monthly_data.dart';
import 'package:bohra_calender/services/data_service.dart';
import 'package:flutter/material.dart';
import 'day_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalenderHomeScreen extends StatefulWidget {
  final List<MonthlyData> completeMonthData;

  const CalenderHomeScreen({Key? key, required this.completeMonthData})
      : super(key: key);

  @override
  _CalenderHomeScreenState createState() => _CalenderHomeScreenState();
}

class _CalenderHomeScreenState extends State<CalenderHomeScreen> {
  int monthIndex = 0;

  CalenderMonthItem? calenderInfoItem;

  List<ClassItemInfo> calssItemInfo = [];

  bool isLoading = true;
  List<MonthlyData> monthData = [];

  void loadData() async {
    monthData = widget.completeMonthData;

    calenderInfoItem = ClassItemInfo.makeCurrentMonthObject(monthData);
    setState(() {
      isLoading = false;
    });

    if (calenderInfoItem != null) {
      setState(() {
        calssItemInfo = calenderInfoItem!.monthItems;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    loadData();
  }

  bool alreadyStarted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: SafeArea(
        child: Container(
          color: Constants.backgroundPatternTopColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      Transform(
                        transform: Matrix4.translationValues(0, 4.0, 0.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            calenderInfoItem != null
                                ? calenderInfoItem!.monthName
                                : '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              if(monthIndex < -11){

                                return;
                              }
                              monthIndex = monthIndex - 1;

                              if (monthIndex == 0) {
                                calenderInfoItem =
                                    ClassItemInfo.makeCurrentMonthObject(
                                        monthData);

                                if (calenderInfoItem != null) {
                                  setState(() {
                                    calssItemInfo =
                                        calenderInfoItem!.monthItems;
                                  });
                                }
                              } else if (monthIndex > 0) {
                                if (calenderInfoItem != null) {
                                  calenderInfoItem =
                                      ClassItemInfo.makeMonthData(
                                          monthIndex, monthData);

                                  setState(() {
                                    calssItemInfo =
                                        calenderInfoItem!.monthItems;
                                  });
                                }
                              } else {

                                if (calenderInfoItem != null) {

                                  if (calenderInfoItem != null) {
                                    calenderInfoItem =
                                        ClassItemInfo.makeMonthData(
                                            monthIndex, monthData);

                                    setState(() {
                                      calssItemInfo =
                                          calenderInfoItem!.monthItems;
                                    });
                                  }

                                }
                              }
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 28,
                              color: Constants.inkBlack,
                            ),
                          ),
                          Text(
                            calenderInfoItem != null
                                ? calenderInfoItem!.previousMonthName
                                : '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Text(
                            calenderInfoItem != null
                                ? calenderInfoItem!.nextMonthName
                                : '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              monthIndex = monthIndex + 1;

                              if (monthIndex == 0) {
                                calenderInfoItem =
                                    ClassItemInfo.makeCurrentMonthObject(
                                        monthData);

                                if (calenderInfoItem != null) {
                                  setState(() {
                                    calssItemInfo =
                                        calenderInfoItem!.monthItems;
                                  });
                                }
                              } else {
                                if (calenderInfoItem != null) {
                                  calenderInfoItem =
                                      ClassItemInfo.makeMonthData(
                                          monthIndex, monthData);

                                  setState(() {
                                    calssItemInfo =
                                        calenderInfoItem!.monthItems;
                                  });
                                }
                              }
                            },
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Constants.inkBlack,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: MakeRoundedBoxForCalender(
                                text: 'Mon',
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),
                            Expanded(
                              flex: 6,
                              child: MakeRoundedBoxForCalender(
                                text: 'Tue',
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),
                            Expanded(
                              flex: 6,
                              child: MakeRoundedBoxForCalender(
                                text: 'Wed',
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),
                            Expanded(
                              flex: 6,
                              child: MakeRoundedBoxForCalender(
                                text: 'Thu',
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),
                            Expanded(
                              flex: 6,
                              child: MakeRoundedBoxForCalender(
                                text: 'Fri',
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),
                            Expanded(
                              flex: 6,
                              child: MakeRoundedBoxForCalender(
                                darkGreen: true,
                                text: 'Sat',
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),
                            Expanded(
                              flex: 6,
                              child: MakeRoundedBoxForCalender(
                                darkGreen: true,
                                text: 'Sun',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      if (calssItemInfo.isNotEmpty) ...[
                        for (int i = 0; i < calssItemInfo.length; i += 7) ...[
                          SizedBox(
                            height: 54,
                            child: Row(
                              children: [
                                if (calssItemInfo[i + 0].isEmpty) ...[
                                  Expanded(
                                    flex: 6,
                                    child: Container(),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ] else ...[
                                  Expanded(
                                    flex: 6,
                                    child: MakeRoundedBoxForCalender(
                                      calenderItem: calssItemInfo[i + 0],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ],
                                if (calssItemInfo[i + 1].isEmpty) ...[
                                  Expanded(
                                    flex: 6,
                                    child: Container(),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ] else ...[
                                  Expanded(
                                    flex: 6,
                                    child: MakeRoundedBoxForCalender(
                                      calenderItem: calssItemInfo[i + 1],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ],
                                if (calssItemInfo[i + 2].isEmpty) ...[
                                  Expanded(
                                    flex: 6,
                                    child: Container(),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ] else ...[
                                  Expanded(
                                    flex: 6,
                                    child: MakeRoundedBoxForCalender(
                                      calenderItem: calssItemInfo[i + 2],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ],
                                if (calssItemInfo[i + 3].isEmpty) ...[
                                  Expanded(
                                    flex: 6,
                                    child: Container(),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ] else ...[
                                  Expanded(
                                    flex: 6,
                                    child: MakeRoundedBoxForCalender(
                                      calenderItem: calssItemInfo[i + 3],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ],
                                if (calssItemInfo[i + 4].isEmpty) ...[
                                  Expanded(
                                    flex: 6,
                                    child: Container(),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ] else ...[
                                  Expanded(
                                    flex: 6,
                                    child: MakeRoundedBoxForCalender(
                                      calenderItem: calssItemInfo[i + 4],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ],
                                if (calssItemInfo[i + 5].isEmpty) ...[
                                  Expanded(
                                    flex: 6,
                                    child: Container(),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ] else ...[
                                  Expanded(
                                    flex: 6,
                                    child: MakeRoundedBoxForCalender(
                                      calenderItem: calssItemInfo[i + 5],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ],
                                if (calssItemInfo[i + 6].isEmpty) ...[
                                  Expanded(
                                    flex: 6,
                                    child: Container(),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ] else ...[
                                  Expanded(
                                    flex: 6,
                                    child: MakeRoundedBoxForCalender(
                                      calenderItem: calssItemInfo[i + 6],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
                      ],
                      if (calssItemInfo.last.monthNo == 9) ...[
                        Expanded(
                          child: Container(),
                        ),
                        buildNabiNaNaam(),
                        const SizedBox(
                          height: 16,
                          child: Text(
                            'Click on a Hijri Date to get details of the day',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ] else ...[
                        Expanded(
                          child: Container(),
                        ),
                        const Text(
                          'Click on a Hijri Date to get details of the day',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget buildNabiNaNaam() {
    return FileItem(
      name: 'Nabi na Naam',
      onTap: () {},
      fileItem: Files(),
      hasPDF: true,
      hasAudio: true,
      isNabiNaNaam: true,
    );
  }
}

class DateItem extends StatelessWidget {
  ClassItemInfo? calenderItem;

  DateItem({Key? key, this.calenderItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 6,
        ),
        Text(
          calenderItem!.dayNo,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.green.shade900,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        Expanded(
          child: Container(),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 2),
          child: Text(
            calenderItem!.normalDayNo,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.green.shade900,
              fontWeight: FontWeight.w400,
              fontSize: calenderItem!.normalDayNo.length == 2 ? 13 : 10,
            ),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
      ],
    );
  }
}

class MakeRoundedBoxForCalender extends StatelessWidget {
  bool darkGreen;
  String text;

  ClassItemInfo? calenderItem;

  MakeRoundedBoxForCalender(
      {Key? key, this.darkGreen = false, this.text = '', this.calenderItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //calenderItem
        if (calenderItem != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DayDetail(
                calenderItem: calenderItem!,
              ),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: color(),
          border: Border.all(
            color: colorColor(),
            width: borderWidth(),
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: calenderItem != null
            ? DateItem(
                calenderItem: calenderItem,
              )
            : Align(
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
      ),
    );
  }

  double borderWidth() {
    if (calenderItem != null) {
      if (calenderItem!.normalDayNo == 'Today') {
        return 2;
      } else if (calenderItem!.dayString == 'Sun' ||
          calenderItem!.dayString == 'Sat') {
        return 1.5;
      }
    }
    return 1;
  }

  Color colorColor() {
    if (calenderItem != null) {
      if (calenderItem!.normalDayNo == 'Today') {
        return Colors.grey.shade700;
      } else if (calenderItem!.dayString == 'Sun' ||
          calenderItem!.dayString == 'Sat') {
        return Colors.green.shade900;
      }
    }
    return Colors.grey.shade700;
  }

  Color color() {
    if (calenderItem != null) {
      if (calenderItem!.data != null) {
        if (calenderItem!.data!.first.color_tag.isNotEmpty) {
          return calenderItem!.data!.first.backgroundColor;
        }
      }
      return Colors.white;
    } else if (darkGreen) {
      return CColors.green_main3;
    }

    return CColors.day_green;
  }
}
