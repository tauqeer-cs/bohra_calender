import 'dart:ffi';

import 'package:bohra_calender/core/constants.dart';
import 'package:bohra_calender/model/calender_item_info.dart';
import 'package:bohra_calender/model/monthly_data.dart';
import 'package:bohra_calender/screens/tasbeeh_view.dart';
import 'package:bohra_calender/screens/washeq_counter.dart';
import 'package:flutter/material.dart';
import 'counter_screen.dart';
import 'file_viewer.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'mini_player_view.dart';

class DayDetail extends StatelessWidget {
  final ClassItemInfo calenderItem;
  final List<String> possibleWasheq = [
    '11-Salam/22',
    '7-Salam/14',
    '12Salam/24',
    '12-Salam/24',
    '10Salam/20',
    '10-Salam/20',
    '5Salam/10',
    '5-Salam/10',
    '12Salam/24',
    '12-Salam/24',
    '12 Salam/24'
  ];

  //  ClassItemInfo? calenderItem;
  DayDetail({Key? key, required this.calenderItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          calenderItem.normalDayFullString,
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      body: Container(
        decoration: Constants.backgroundPAttern,
        child: Container(
          color: Constants.backgroundPatternTopColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 12,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  calenderItem.islamicDayFullString,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 22),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (calenderItem.data == null) ...[
                        const NoHijriEvent(),
                      ] else ...[
                        const SizedBox(
                          height: 12,
                        ),
                        for (MonthlyData currentMonth in calenderItem.data!)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  currentMonth.title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                      ],
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(
                          color: Colors.white,
                        ),
                      ),
                      if (calenderItem.data != null) ...[
                        for (MonthlyData current in calenderItem.data!) ...[
                          /*
                                                var files = calenderItem.data!
                          .firstWhere((e) =>


                          .files;
                          * */
                          if (current.title.contains(possibleWasheq.first) ||
                              current.title.contains(possibleWasheq.last) ||
                              current.title.contains(possibleWasheq[1]) ||
                              current.title.contains(possibleWasheq[2]) ||
                              current.title.contains(possibleWasheq[3]) ||
                              current.title.contains(possibleWasheq[4]) ||
                              current.title.contains(possibleWasheq[5]) ||
                              current.title.contains(possibleWasheq[6]) ||
                              current.title.contains(possibleWasheq[7]) ||
                              current.title.contains(possibleWasheq[8]) ||
                              current.title.contains(possibleWasheq[9])
                          )
                            ...[]
                          else ...[
                            for (Files currentFile in current.files) ...[
                              FileItem(
                                verticalGap: calenderItem.isWasheqDay ? 4 : 8,
                                name: currentFile.title,
                                onTap: () {},
                                hasPDF: currentFile.pdfUr.isNotEmpty,
                                hasAudio: currentFile.audioUrl.isNotEmpty,
                                fileItem: currentFile,
                              ),
                            ],
                          ],
                        ],
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              if (calenderItem.isWasheqDay &&
                  calenderItem.dayNo == '30' &&
                  calenderItem.monthNo == 9) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GestureDetector(
                    onTap: () {
                      var files = calenderItem.data!
                          .firstWhere((e) => e.title.contains('Washeq'))
                          .files;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WasheqCounterView(
                            calenderItem: calenderItem,
                            isRamadanLast: true,
                            files: files,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Washeq Counter 10 Rakat',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GestureDetector(
                    onTap: () {
                      var files = calenderItem.data!
                          .firstWhere((e) => e.title.contains('Washeq'))
                          .files;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WasheqCounterView(
                            calenderItem: calenderItem,
                            files: files,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Washeq Counter 24 Rakat',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
              ] else if (calenderItem.isWasheqDay) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GestureDetector(
                    onTap: () {
                      var files = calenderItem.data!
                          .firstWhere((e) =>
                              e.title.contains(possibleWasheq.first) ||
                              e.title.contains(possibleWasheq.last) ||
                              e.title.contains(possibleWasheq[1]) ||
                              e.title.contains(possibleWasheq[2]) ||
                              e.title.contains(possibleWasheq[3]) ||
                              e.title.contains(possibleWasheq[4]) ||
                              e.title.contains(possibleWasheq[5]) ||
                              e.title.contains(possibleWasheq[6]) ||
                              e.title.contains(possibleWasheq[7]) ||
                              e.title.contains(possibleWasheq[8]) ||
                              e.title.contains(possibleWasheq[9]))
                          .files;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WasheqCounterView(
                            calenderItem: calenderItem,
                            files: files,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Washeq Counter',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          String eventName = '';

                          if (calenderItem.data == null) {
                            return;
                          }
                          for (var currentItem in calenderItem.data!) {
                            if (eventName.isEmpty) {
                              eventName = currentItem.title;
                            } else {
                              eventName = eventName + ' ' + currentItem.title;
                            }
                          }

                          final Event event = Event(
                            title: eventName,
                            startDate: calenderItem.normalDate,
                            endDate: calenderItem.normalDate
                                .add(const Duration(days: 1, hours: 1)),
                            iosParams: const IOSParams(
                              reminder: Duration(days: 1, hours: -2),
                            ),
                            androidParams: const AndroidParams(
                              emailInvites: [], // on Android, you can add invite emails to your event.
                            ),
                          );

                          bool check = await Add2Calendar.addEvent2Cal(event);
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.brown,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Sync',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TasbeehView(),
                            ),
                          );
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Tasbeeh',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FileItem extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  final bool hasAudio;
  final bool hasPDF;

  final double verticalGap;

  final Files fileItem;

  final bool noGap;

  final bool otherColor;

  final bool isDisabled;
  final bool pop;

  const FileItem({
    Key? key,
    required this.name,
    this.pop = false,
    required this.onTap,
    this.isDisabled = false,
    required this.hasAudio,
    required this.hasPDF,
    required this.fileItem,
    this.verticalGap = 8,
    this.noGap = false,
    this.otherColor = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalGap),
      child: GestureDetector(
        onTap: () {
          if (this.isDisabled) {
            return;
          }
          if (hasAudio && !hasPDF) {
            showModalBottomSheet(
              isScrollControlled: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              context: context,
              builder: (BuildContext context) {
                return MiniPlayerView(
                  fileItem: fileItem,
                );
              },
            );
            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FileViewer(
                fileItem: fileItem,
              ),
            ),
          );
        },
        child: Row(
          children: [
            SizedBox(
              width: noGap ? 2 : 16,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: otherColor ? Colors.blueAccent : Colors.blueGrey,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 4,
                    ),
                    if (hasPDF && hasAudio) ...[
                      Column(
                        children: [
                          Icon(
                            Icons.book,
                            color: hasAudio ? Colors.white : Colors.transparent,
                            size: 15,
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Icon(
                            Icons.audiotrack,
                            color: hasAudio ? Colors.white : Colors.transparent,
                            size: 15,
                          ),
                        ],
                      ),
                    ] else if (hasPDF) ...[
                      const Icon(
                        Icons.book,
                        color: Colors.white,
                      ),
                    ] else if (hasAudio) ...[
                      const Icon(
                        Icons.audiotrack,
                        color: Colors.white,
                      ),
                    ],
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: isDisabled ? Colors.grey : Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 20),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.book,
                      color: Colors.transparent,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: noGap ? 2 : 16,
            ),
          ],
        ),
      ),
    );
  }
}

class NoHijriEvent extends StatelessWidget {
  const NoHijriEvent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: const Align(
          alignment: Alignment.center,
          child: Text(
            'No Hijri Event',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
