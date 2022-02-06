import 'package:bohra_calender/core/colors.dart';
import 'package:bohra_calender/core/constants.dart';
import 'package:bohra_calender/model/calender_item_info.dart';
import 'package:bohra_calender/model/monthly_data.dart';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

class EventsListing extends StatefulWidget {
  final List<MonthlyData> monthItems;

  const EventsListing({required this.monthItems, Key? key}) : super(key: key);

  @override
  _EventsListingState createState() => _EventsListingState();
}

class _EventsListingState extends State<EventsListing> {
  List<EventData> dataToShow = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 365; i++) {
      var normalDate = DateTime.now().add(Duration(days: i));

      var _today = HijriCalendar.fromDate(normalDate);

      var result = widget.monthItems
          .where((e) => e.day == _today.hDay && e.month == _today.hMonth)
          .toList();

      if (result.isNotEmpty) {
        String formattedDate =
            DateFormat('dd MMM,EEEE yyyy').format(normalDate);
        String islamicDay = _today.hDay.toString();
        if (islamicDay.length == 1) {
          islamicDay = '0$islamicDay';
        }

        islamicDay =
            '$islamicDay ${ClassItemInfo.islamicMonthName[_today.hMonth]}, ${_today.hYear}';

        var listName = result.map((e) => e.title).toSet().toList();

        dataToShow.add(EventData(
            normalDate: formattedDate,
            eventName: listName,
            islamicDate: islamicDay));

      }
      //();

    }

    print('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events List'),
      ),
      body: SafeArea(
        child: Container(
          decoration: Constants.backgroundPAttern,
          child: Container(
            color: Constants.backgroundPatternTopColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (_, index) {
                      return const SizedBox(
                        height: 8,
                      );
                    },
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 64,
                                      child: Text(
                                        dataToShow[index].normalDate,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    Expanded(
                                      flex: 36,
                                      child: Text(
                                        dataToShow[index].islamicDate,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: CColors.green_main2,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16.0),
                                  bottomRight: Radius.circular(16.0),
                                ),
                              ),
                              child: Column(
                                children: [
                                  for (String currentName
                                      in dataToShow[index].eventName) ...[
                                    Container(
                                      height: 1,
                                      width: double.infinity,
                                      color: Colors.blueAccent,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(
                                        currentName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                            color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: dataToShow.length,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EventData {
  String normalDate = '';
  List<String> eventName = [];
  String islamicDate = '';

  EventData(
      {required this.normalDate,
      required this.eventName,
      required this.islamicDate});
}
