import 'package:bohra_calender/core/colors.dart';
import 'package:bohra_calender/core/constants.dart';
import 'package:bohra_calender/model/calender_item_info.dart';
import 'package:bohra_calender/model/date_service.dart';
import 'package:bohra_calender/model/monthly_data.dart';
import 'package:bohra_calender/screens/personal_event_listing.dart';
import 'package:bohra_calender/screens/prayer_times_view.dart';
import 'package:bohra_calender/screens/qibla.dart';
import 'package:bohra_calender/screens/tasbeeh.dart';
import 'package:bohra_calender/services/data_service.dart';
import 'package:bohra_calender/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:url_launcher/url_launcher.dart';
import 'bihori_namaz.dart';
import 'day_detail.dart';
import 'events_list.dart';
import 'extra_name_listing.dart';
import 'package:daylight/daylight.dart';

import 'home.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

//<AppLifecycleReactor>
class _DashboardState extends State<Dashboard> with WidgetsBindingObserver {
  List<MonthlyData>? otherData;

  bool gettingLocation = true;

  bool locationNotFound = false;

  String get todayIslamicDate {

    _today ??= HijriCalendar.fromDate(
        DateTime.now().add(
          Duration(days: addExtraDaysToCheck),
        ),
      );


    return _today!.hDay.toString() +
        ' ' +
        ClassItemInfo.islamicMonthName[_today!.hMonth] +
        ' ' +
        _today!.hYear.toString();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
    });

    locationNotFound = false;

   // getTimes();

   // loadData();
  }


  String get todayNormalDate {
    return DateFormat('EEEE d MMM yyyy').format(DateTime.now());
  }

  double latit = 0.0, long = 0.0;

  List<MonthlyData> monthlyData = [];
  List<MonthlyData> completeMonthData = [];

  int addExtraDaysToCheck = 0;

  HijriCalendar? _today;

  void loadData() async {
    final prefs = await SharedPreferences.getInstance();

    /*








     */
    var monthData =
        await dataService.getEventsWithFiles(accessSavedObject: false);
    completeMonthData = monthData;

      _today = HijriCalendar.fromDate(
      DateTime.now().add(
        Duration(days: addExtraDaysToCheck),
      ),
    );

    var response = monthData
        .where((e) => e.month == _today!.hMonth && e.day == _today!.hDay)
        .toList();

    if (response.isNotEmpty) {
      setState(() {
        monthlyData = response;
      });
    } else {
      setState(() {
        monthlyData = [];
      });
    }

    otherData = await dataService.getExtraData();
  }

  Widget getTodaysEvent() {
    _today ??= HijriCalendar.fromDate(
        DateTime.now().add(
          Duration(days: addExtraDaysToCheck),
        ),
      );


    if (monthlyData.isEmpty) {
      return Container(
        color: Colors.white,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Container(
                  //   height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Constants.backgroundPatternTopColor,
                    boxShadow: [
                      BoxShadow(color: Constants.borderGray, spreadRadius: 2),
                    ],
                  ),

                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Icon(
                            FontAwesomeIcons.calendar,
                            color: Constants.inkBlack,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'No Event Today',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Constants.inkBlack,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              "Today's Events",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            for (int i = 0; i < monthlyData.length; i++) ...[

              if(!monthlyData[i].title.contains('***')) ... [
                GestureDetector(
                  onTap: () {
                    try {
                      var response =
                      ClassItemInfo.makeCurrentMonthObject(completeMonthData)
                          .monthItems
                          .firstWhere((e) =>
                      e.monthNo == _today!.hMonth &&
                          e.dayNo == _today!.hDay.toString());

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DayDetail(
                            calenderItem: response,
                          ),
                        ),
                      );
                    } catch (e) {
                      print('');
                    }
                  },
                  child: Padding(
                    padding: i == 0
                        ? const EdgeInsets.all(16.0)
                        : const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Container(
                      //   height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Constants.backgroundPatternTopColor,
                        boxShadow: [
                          BoxShadow(color: Constants.borderGray, spreadRadius: 2),
                        ],
                      ),

                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Icon(
                                FontAwesomeIcons.calendar,
                                color: Constants.inkBlack,
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '${_today!.hDay} ${ClassItemInfo.islamicMonthName[_today!.hMonth]}',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Constants.inkBlack,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    monthlyData[i].title,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Constants.ickGray,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],

            ]
          ],
        ),
      ),
    );
  }





  void setupNot() async {}

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addObserver(this);

//    getTimes();
    loadData();
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String lblSahori = "",
      lblFajarTiming = "",
      lblSunrise = "",
      lblZawaal = '',
      lblZoharTiming = '',
      lblAsrTiming = '',
      lblMagribTiming = '',
      lblIshaTime = '';

  AppLifecycleState? _notification;


  bool checkIsNextPrayer(DateTime datetime) {
    if (datetime.hour == DateTime.now().hour) {
      if (datetime.minute > DateTime.now().minute) {
        return true;
      }
    }

    if (datetime.hour > DateTime.now().hour) {
      return true;
    }

    return false;
  }

  String nextPrayerText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            'assets/images/bismillah-black.png',
            height: 44,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Constants.backgroundPatternTopColor,
          child: SingleChildScrollView(
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
                    todayIslamicDate,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 19,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    todayNormalDate,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  color: Colors.transparent,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        buildRow(
                          context,
                          PrayerItems(
                            title: 'View Calendar',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CalenderHomeScreen(
                                    completeMonthData: completeMonthData,
                                  ),
                                ),
                              );

                              //ExtraNamazListing
                            },
                            imageName: 'calender_home',
                          ),
                          PrayerItems(
                            title: 'View Events',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EventsListing(
                                    monthItems: completeMonthData,
                                  ),
                                ),
                              );
                            },
                            imageName: 'personal_event',
                          ),
                          buildPersonalEventItem(context),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        buildRow(
                          context,
                          PrayerItems(
                            title: 'Pray Bihori Namaz',
                            onTap: () {
                              var bihoriNamaz = otherData!
                                  .firstWhere((e) => e.title == 'Bihori Namaz');

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BihoriNamazView(
                                    data: bihoriNamaz,
                                  ),
                                ),
                              );
                            },
                            imageName: 'bihori_icon',
                          ),
                          PrayerItems(
                            title: 'Pray Extra Namaz',
                            onTap: () {
                              if (otherData != null) {
                                var otherToSend = otherData!.firstWhere(
                                    (e) => e.title == 'Other Namaz');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ExtraNamazListing(
                                      isOther: true,
                                      monthlyData: otherToSend,
                                    ),
                                  ),
                                );
                              }
                            },
                            imageName: 'recite_duas',
                          ),
                          PrayerItems(
                            title: 'Recite Duas',
                            onTap: () {
                              if (otherData != null) {
                                var otherToSend = otherData!
                                    .where((e) =>
                                        e.title != 'Other Namaz' &&
                                        e.title != 'Bihori Namaz')
                                    .toList();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ExtraNamazListing(
                                      isDuas: true,
                                      monthlyListData: otherToSend,
                                    ),
                                  ),
                                );
                              }
                            },
                            imageName: 'other_namaz',
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        buildRow(
                          context,
                          buildPersonalEventItem(context, tasbeeh: true),
                          buildNamazTimingItem(context),
                          buildQiblaCompassitem(context),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(
                    color: Colors.blueGrey,
                  ),
                ),
                /*Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextButton(
                    onPressed: (){


                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PrayersTimeView(),
                        ),
                      );


                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: CColors.green_main,
                        boxShadow: [
                          BoxShadow(color: Constants.borderGray, spreadRadius: 2),
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Check Namaz Timings',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(
                    color: Colors.blueGrey,
                  ),
                ),

                */
                getTodaysEvent(),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(
                    color: Colors.blueGrey,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    TextButton(
                      onPressed: () async =>
                          await launch("https://wa.me/+447795215010?text=Hi"),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  const [

                          Text(
                            'Contact Us',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Image(
                            image: AssetImage(
                              'assets/icons/whatsApp.png',
                            ),
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PrayerItems buildNamazTimingItem(BuildContext context) {
    return PrayerItems(
      title: 'Check Namaz Time',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PrayersTimeView(),
          ),
        );
      },
      imageName: 'namaz_timings',
    );
  }

  PrayerItems buildQiblaCompassitem(BuildContext context) {
    return PrayerItems(
      title: 'Find Qibla',
      onTap: () {
        //const ();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Qibla(),
          ),
        );
      },
      imageName: 'qibla_compass',
    );
  }

  PrayerItems buildPersonalEventItem(BuildContext context,
      {bool tasbeeh = false}) {
    if (tasbeeh) {
      return PrayerItems(
        title: 'Do Tasbeeh',
        onTap: () {
          //const ();

          //..TasbeehView
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Tasbeeh(),
            ),
          );
        },
        imageName: 'tasbeeh',
      );
    }
    return PrayerItems(
      title: 'Add Personal Events',
      onTap: () {
        //const ();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PersonalEventListing(),
          ),
        );
      },
      imageName: 'event_icon',
    );
  }

  Row buildRowWithTwo(
      BuildContext context, PrayerItems item1, PrayerItems item2) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 75,
          child: Container(),
        ),
        Expanded(
          flex: 90,
          child: item1,
        ),
        Expanded(
          flex: 20,
          child: Container(),
        ),
        Expanded(
          flex: 90,
          child: item2,
        ),
        Expanded(
          flex: 75,
          child: Container(),
        ),
      ],
    );
  }

  Row buildRow(BuildContext context, PrayerItems item1, PrayerItems item2,
      PrayerItems item3) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Container(),
        ),
        Expanded(
          flex: 9,
          child: item1,
        ),
        Expanded(
          flex: 2,
          child: Container(),
        ),
        Expanded(
          flex: 9,
          child: item2,
        ),
        Expanded(
          flex: 2,
          child: Container(),
        ),
        Expanded(
          flex: 9,
          child: item3,
        ),
        Expanded(
          flex: 2,
          child: Container(),
        ),
      ],
    );
  }


}

class PrayerItems extends StatelessWidget {
  final String imageName;
  final String title;
  final VoidCallback onTap;

  const PrayerItems({
    Key? key,
    required this.imageName,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
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
                  offset: const Offset(-3, 3), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: onTap,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/icons/$imageName.png',
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.black,
                    height: 1.2, // the height between text, default is null
                    fontSize: 14,
                    fontWeight: FontWeight.w700),
              ),
            ),
          )
        ],
      ),
    );
  }
}
