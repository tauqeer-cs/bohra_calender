import 'dart:ffi';

import 'package:bohra_calender/core/colors.dart';
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
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      body: Container(
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
                style: TextStyle(
                    color: Constants.inkBlack,
                    fontWeight: FontWeight.w600,
                    fontSize: 22),
              ),
            ),
            const SizedBox(
              height: 16,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(
                                    -3, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              if (calenderItem.isWasheqDay &&
                                  calenderItem.dayNo == '30' &&
                                  calenderItem.monthNo == 9 && 1 == 2) ...[
                                const SizedBox(
                                  height: 16,
                                ),
                                WasheqButton(
                                  title: 'Washeq Counter 10 Rakat',
                                  onTap: () {
                                    var files = calenderItem.data!
                                        .firstWhere(
                                            (e) => e.title.contains('Washeq'))
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
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                WasheqButton(
                                  title: 'Washeq Counter 24 Rakat',
                                  onTap: () {
                                    var files = calenderItem.data!
                                        .firstWhere(
                                            (e) => e.title.contains('Washeq'))
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
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                              ] else if (calenderItem.isWasheqDay) ...[


                                if(1 == 2) ... [
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  WasheqButton(
                                    onTap: () {
                                      var files = calenderItem.data!
                                          .firstWhere((e) =>
                                      e.title.contains(
                                          possibleWasheq.first) ||
                                          e.title.contains(
                                              possibleWasheq.last) ||
                                          e.title
                                              .contains(possibleWasheq[1]) ||
                                          e.title
                                              .contains(possibleWasheq[2]) ||
                                          e.title
                                              .contains(possibleWasheq[3]) ||
                                          e.title
                                              .contains(possibleWasheq[4]) ||
                                          e.title
                                              .contains(possibleWasheq[5]) ||
                                          e.title
                                              .contains(possibleWasheq[6]) ||
                                          e.title
                                              .contains(possibleWasheq[7]) ||
                                          e.title
                                              .contains(possibleWasheq[8]) ||
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
                                  ),
                                ],

                                const SizedBox(
                                  height: 8,
                                ),
                              ],
                              for (int i = 0;
                                  i < calenderItem.data!.length;
                                  i++) ...[

                                if (calenderItem.data![i].title
                                    .contains(possibleWasheq.first) ||
                                    calenderItem.data![i].title
                                        .contains(possibleWasheq.last) ||
                                    calenderItem.data![i].title.contains(possibleWasheq[1]) ||
                                    calenderItem.data![i].title.contains(possibleWasheq[2]) ||
                                    calenderItem.data![i].title.contains(possibleWasheq[3]) ||
                                    calenderItem.data![i].title.contains(possibleWasheq[4]) ||
                                    calenderItem.data![i].title.contains(possibleWasheq[5]) ||
                                    calenderItem.data![i].title.contains(possibleWasheq[6]) ||
                                    calenderItem.data![i].title.contains(possibleWasheq[7]) ||
                                    calenderItem.data![i].title.contains(possibleWasheq[8]) ||
                                    calenderItem.data![i].title.contains(possibleWasheq[9]))
                                  ...[
                                    if(2 == 3) ... [
                                      WasheqButton(
                                        onTap: () {
                                          var files = calenderItem.data!
                                              .firstWhere((e) =>
                                          e.title.contains(
                                              possibleWasheq.first) ||
                                              e.title.contains(
                                                  possibleWasheq.last) ||
                                              e.title
                                                  .contains(possibleWasheq[1]) ||
                                              e.title
                                                  .contains(possibleWasheq[2]) ||
                                              e.title
                                                  .contains(possibleWasheq[3]) ||
                                              e.title
                                                  .contains(possibleWasheq[4]) ||
                                              e.title
                                                  .contains(possibleWasheq[5]) ||
                                              e.title
                                                  .contains(possibleWasheq[6]) ||
                                              e.title
                                                  .contains(possibleWasheq[7]) ||
                                              e.title
                                                  .contains(possibleWasheq[8]) ||
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
                                      ),
                                    ],

                                  ] else ... [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2, vertical: 8),
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          calenderItem.data![i].title,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Constants.inkBlack,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if ((i + 1) != calenderItem.data!.length) ...[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Divider(
                                        color: Constants.ickGray,
                                        height: 4,
                                      ),
                                    ),
                                  ],

                                ],



                              ],
                              const SizedBox(
                                height: 8,
                              ),
                            ],
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(
                                    -3, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 16,
                              ),
                              for (MonthlyData current
                                  in calenderItem.data!) ...[
                                if (current.title
                                        .contains(possibleWasheq.first) ||
                                    current.title
                                        .contains(possibleWasheq.last) ||
                                    current.title.contains(possibleWasheq[1]) ||
                                    current.title.contains(possibleWasheq[2]) ||
                                    current.title.contains(possibleWasheq[3]) ||
                                    current.title.contains(possibleWasheq[4]) ||
                                    current.title.contains(possibleWasheq[5]) ||
                                    current.title.contains(possibleWasheq[6]) ||
                                    current.title.contains(possibleWasheq[7]) ||
                                    current.title.contains(possibleWasheq[8]) ||
                                    current.title.contains(possibleWasheq[9]))
                                  ...[
                                    if (calenderItem.isWasheqDay &&
                                        calenderItem.dayNo == '30' &&
                                        calenderItem.monthNo == 9) ...[


                                          if('5Salam/10 Rakats Washeqcounter' == current.title) ... [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 8),
                                              child: WasheqButton(
                                                title: 'Washeq Counter 10 Rakat',
                                                onTap: () {
                                                  var files = calenderItem.data!
                                                      .firstWhere(
                                                          (e) => e.title == '5Salam/10 Rakats Washeqcounter')
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
                                              ),
                                            ),
                                          ] else if('12Salam/24 Rakats Washeqcounter' == current.title) ... [

                                            const SizedBox(height: 8,),
                                            WasheqButton(
                                              title: 'Washeq Counter 24 Rakat',
                                              onTap: () {
                                                var files = calenderItem.data!
                                                    .firstWhere(
                                                        (e) => e.title == '12Salam/24 Rakats Washeqcounter')
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
                                            ),

                                          ],

                                    ] else ... [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        child: WasheqButton(
                                          onTap: () {
                                            var files = calenderItem.data!
                                                .firstWhere((e) =>
                                            e.title.contains(
                                                possibleWasheq.first) ||
                                                e.title.contains(
                                                    possibleWasheq.last) ||
                                                e.title
                                                    .contains(possibleWasheq[1]) ||
                                                e.title
                                                    .contains(possibleWasheq[2]) ||
                                                e.title
                                                    .contains(possibleWasheq[3]) ||
                                                e.title
                                                    .contains(possibleWasheq[4]) ||
                                                e.title
                                                    .contains(possibleWasheq[5]) ||
                                                e.title
                                                    .contains(possibleWasheq[6]) ||
                                                e.title
                                                    .contains(possibleWasheq[7]) ||
                                                e.title
                                                    .contains(possibleWasheq[8]) ||
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
                                        ),
                                      ),
                                    ],

                                  ]
                                else ...[
                                  for (Files currentFile in current.files) ...[
                                    FileItem(
                                      verticalGap:
                                          calenderItem.isWasheqDay ? 4 : 8,
                                      name: currentFile.title,
                                      onTap: () {},
                                      hasPDF: currentFile.pdfUr.isNotEmpty,
                                      hasAudio: currentFile.audioUrl.isNotEmpty,
                                      fileItem: currentFile,
                                    ),
                                  ],
                                ],
                              ],
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  GestureDetector(
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

                  if(calenderItem.monthNo == 7) ... [
                    const SizedBox(
                      height: 8,
                    ),

                    GestureDetector(
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
                          color: CColors.green_buttons,
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
                            'Tasbee',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ],

                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
          ],
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

  final bool shouldContinueAudio;

  final bool isNabiNaNaam;

  final MonthlyData? data;


  final double verticalGap;

  final Files fileItem;

  final bool noGap;

  final bool otherColor;

  final bool isDisabled;
  final bool pop;

  final int currentIndex;

  final List<Files>? files;
  const FileItem({
    Key? key,
    this.data,
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
    this.isNabiNaNaam = false,
    this.shouldContinueAudio = false,
    this.files,
    this.currentIndex = 0
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalGap),
      child: GestureDetector(
        onTap: () {
          if(isNabiNaNaam){

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FileViewer(
                  fileItem: fileItem,
                  nabiNaNaam: true,
                ),
              ),
            );


            return;

          }
          if (isDisabled) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FileViewer(
                  fileItem: fileItem,
                ),
              ),
            );

            return;
          }
          if (hasAudio && !hasPDF) {

            if(files != null) {
              showModalBottomSheet(
                isScrollControlled: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                context: context,

                builder: (BuildContext context) {
                  return MiniPlayerView(
                    fileItem: fileItem,
                    fileItems: files,
                    itemIndex: currentIndex,

                  );
                },
              );

            }
            else {
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
            }

            return;
          }

          if(fileItem.title == '1-Alhamdo-Laukshemo Sura' && fileItem.fileName == 'F7bkYQydAC-AL-Hamd-to La uqsimo.pdf') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FileViewer(
                  fileItem: fileItem,
                  data: data,
                  isAlhamdo: true,
                ),
              ),
            );
          }
          else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FileViewer(
                  fileItem: fileItem,
                ),
              ),
            );
          }

        },
        child: Row(
          children: [
            SizedBox(
              width: noGap ? 2 : 16,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isNabiNaNaam ? CColors.light_green : Constants.backgroundPatternTopColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(
                          -3, 3), // changes position of shadow
                    ),
                  ],
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
                        children: const [
                          Image(
                            image: AssetImage("assets/icons/music.png"),
                            height: 12,
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Image(
                            image: AssetImage("assets/icons/pdf.png",
                            ),
                            height: 12,
                          ),
                        ],
                      ),
                    ] else if (hasPDF) ...[

                      const Image(
                        image: AssetImage("assets/icons/pdf.png"),
                        height: 24,
                      ),

                    ] else if (hasAudio) ...[
                      const Image(
                        image: AssetImage("assets/icons/music.png"),
                        height: 24,
                      ),
                    ],
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color:
                                  isDisabled ? Colors.grey : Constants.inkBlack,
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
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

class WasheqButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const WasheqButton(
      {Key? key, this.title = 'Washeq Counter', required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: const BoxDecoration(
            color: CColors.green_buttons,
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
