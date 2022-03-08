import 'package:bohra_calender/core/colors.dart';
import 'package:bohra_calender/core/constants.dart';
import 'package:bohra_calender/model/calender_item_info.dart';
import 'package:bohra_calender/model/date_service.dart';
import 'package:bohra_calender/model/monthly_data.dart';
import 'package:bohra_calender/screens/personal_event_listing.dart';
import 'package:bohra_calender/screens/prayer_times_view.dart';
import 'package:bohra_calender/screens/qibla.dart';
import 'package:bohra_calender/screens/tasbeeh.dart';
import 'package:bohra_calender/screens/tasbeeh_view.dart';
import 'package:bohra_calender/services/data_service.dart';
import 'package:bohra_calender/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
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
    var _today = HijriCalendar.now();
    return _today.hDay.toString() +
        ' ' +
        _today.longMonthName +
        ' ' +
        _today.hYear.toString();
  }

  /*
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
    });

    locationNotFound = false;

   // getTimes();

   // loadData();
  }
*/

  String get todayNormalDate {
    return DateFormat('EEEE d MMM yyyy').format(DateTime.now());
  }

  double latit = 0.0, long = 0.0;

  List<MonthlyData> monthlyData = [];
  List<MonthlyData> completeMonthData = [];

  int addExtraDaysToCheck = 0;

  void loadData() async {
    final prefs = await SharedPreferences.getInstance();

    /*








     */
    var monthData =
        await dataService.getEventsWithFiles(accessSavedObject: false);
    completeMonthData = monthData;

    var _today = HijriCalendar.fromDate(
      DateTime.now().add(
        Duration(days: addExtraDaysToCheck),
      ),
    ); //;.add(Duration(days: 9)));

    var response = monthData
        .where((e) => e.month == _today.hMonth && e.day == _today.hDay)
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
    var _today = HijriCalendar.fromDate(
      DateTime.now().add(
        Duration(days: addExtraDaysToCheck),
      ),
    );

    if (monthlyData.isEmpty) {
      return Container();
    }
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              'Todays Events',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            for (int i = 0; i < monthlyData.length; i++) ...[
              GestureDetector(
                onTap: (){

                  try {
                    var response  = ClassItemInfo.makeCurrentMonthObject(completeMonthData).monthItems.firstWhere((e) => e.monthNo == _today.hMonth && e.dayNo == _today.hDay.toString());

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DayDetail(
                          calenderItem: response,
                        ),
                      ),
                    );
                  }
                  catch(e){

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
                                  '${_today.hDay} ${ClassItemInfo.islamicMonthName[_today.hMonth]}',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Constants.inkBlack,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4,),
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
            ]
          ],
        ),
      ),
    );
  }

  Future<DateTime> getNextDaySihoriTime(
      DateTime date, double lat, double longitude) async {
    String dateStringFormat = "MM dd yyyy HH:mm";

    latit = lat;
    longitude = longitude;

    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();

    var berlin = DaylightLocation(lat, longitude);
    final berlinCalculator = DaylightCalculator(berlin);

    DaylightResult sunsetRise =
        berlinCalculator.calculateForDay(DateTime.now(), Zenith.official);
    final secondsBetweenDuration =
        sunsetRise.sunset!.difference(sunsetRise.sunrise!.toLocal());

    var secondsBetween = secondsBetweenDuration.inSeconds / 12.0;

    double dayGhari = secondsBetween;
    double nightGhari = (120.0 * 60) - dayGhari;

    if (nightGhari < 0) {
      nightGhari = nightGhari * -1;
    }

    var sohoriTimeString =
        "${sunsetRise.sunrise!.toLocal().hour}:${sunsetRise.sunrise!.toLocal().minute}";

    String currentDateString = "${date.month} ${date.day} ${date.year}";

    String dayString = "$currentDateString $sohoriTimeString";

    DateTime curentSohoriTime =
        DateClass.makeDateFromString(dayString, dateStringFormat);
    //NSDate * curentSohoriTime = [DateFormatter makeDataFromString:dayString withDateFormate:dateStringFormat];

    if (sunsetRise.sunrise!.toLocal().second > 2) {
      curentSohoriTime = curentSohoriTime.add(Duration(minutes: 1));
    }

    String lblSunriseString =
        "${sunsetRise.sunrise!.toLocal().hour}:${sunsetRise.sunrise!.toLocal().minute}";

    lblSunriseString = "$currentDateString $lblSunriseString";

    DateTime lblSunriseTime =
        DateClass.makeDateFromString(lblSunriseString, dateStringFormat);

    /*
    I have to check this logic later
    if (sunsetRise.sunrise!.second > 2) {
      curentSohoriTime = curentSohoriTime.add(Duration(minutes: 1));
    }*/

    curentSohoriTime = lblSunriseTime.subtract(const Duration(minutes: 75));

    return curentSohoriTime;
  }

  Future<List<DateTime>> getNamazTimesWithLatLong(
      DateTime date, double lat, double longitude) async {
    String dateStringFormat = "MM dd yyyy HH:mm";

    latit = lat;
    longitude = longitude;

    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();

    var berlin = DaylightLocation(lat, longitude);
    final berlinCalculator = DaylightCalculator(berlin);

    DaylightResult sunsetRise =
        berlinCalculator.calculateForDay(DateTime.now(), Zenith.official);
    final secondsBetweenDuration =
        sunsetRise.sunset!.difference(sunsetRise.sunrise!.toLocal());

    var secondsBetween = secondsBetweenDuration.inSeconds / 12.0;

    double dayGhari = secondsBetween;
    double nightGhari = (120.0 * 60) - dayGhari;

    if (nightGhari < 0) {
      nightGhari = nightGhari * -1;
    }

    var sohoriTimeString =
        "${sunsetRise.sunrise!.toLocal().hour}:${sunsetRise.sunrise!.toLocal().minute}";

    String currentDateString = "${date.month} ${date.day} ${date.year}";

    String dayString = "$currentDateString $sohoriTimeString";

    DateTime curentSohoriTime =
        DateClass.makeDateFromString(dayString, dateStringFormat);
    //NSDate * curentSohoriTime = [DateFormatter makeDataFromString:dayString withDateFormate:dateStringFormat];

    if (sunsetRise.sunrise!.toLocal().second > 2) {
      curentSohoriTime = curentSohoriTime.add(Duration(minutes: 1));
    }

    String lblSunriseString =
        "${sunsetRise.sunrise!.toLocal().hour}:${sunsetRise.sunrise!.toLocal().minute}";

    lblSunriseString = "$currentDateString $lblSunriseString";

    DateTime lblSunriseTime =
        DateClass.makeDateFromString(lblSunriseString, dateStringFormat);

    curentSohoriTime = lblSunriseTime.subtract(const Duration(minutes: 75));

    String newFajr = getFajrTime(sunsetRise, nightGhari);

    newFajr =
        "$currentDateString $newFajr"; //[NSString stringWithFormat:@"%@ %@",currentDateString,newFajr];
    DateTime newFajrTime =
        DateClass.makeDateFromString(newFajr, dateStringFormat);
    String zawalString = getZawaaalTimeWithEDSunriseSet(sunsetRise);

    zawalString = "$currentDateString $zawalString";

    DateTime zawalDate =
        DateClass.makeDateFromString(zawalString, dateStringFormat);

    String zoharEndString = getZoharEndTime(sunsetRise, dayGhari);

    zoharEndString =
        "$currentDateString $zoharEndString"; //[NSString stringWithFormat:@"%@ %@",currentDateString,zoharEndString];

    DateTime zoharEndDate =
        DateClass.makeDateFromString(zoharEndString, dateStringFormat);

    String asrEndString = getAsrEndTime(sunsetRise, dayGhari);
    asrEndString = "$currentDateString $asrEndString";
    DateTime asrEndDate = DateClass.makeDateFromString(asrEndString,
        dateStringFormat); //[DateFormatter makeDataFromString:asrEndString withDateFormate:dateStringFormat];

    String lblSetString =
        "${sunsetRise.sunset!.toLocal().hour}:${sunsetRise.sunset!.toLocal().minute}";
    lblSetString = "$currentDateString $lblSetString";

    DateTime lblSunsetTime =
        DateClass.makeDateFromString(lblSetString, dateStringFormat);

    if (sunsetRise.sunset!.toLocal().second > 1) {
      lblSunsetTime = lblSunsetTime.add(Duration(minutes: 1));
    }

    DateTime ishaEnd = zawalDate.add(Duration(hours: 12));

    return [
      curentSohoriTime,
      newFajrTime,
      lblSunriseTime,
      zawalDate,
      zoharEndDate,
      asrEndDate,
      lblSunsetTime,
      ishaEnd
    ];
  }

  String getAsrEndTime(DaylightResult sunsetRiseT, double dayGhari) {
    double ZoharEndValue = getZawaaalValue(sunsetRiseT) + (dayGhari * 4);
    int zoharHours = (ZoharEndValue / 60.0).floor();
    zoharHours = (zoharHours / 60.0).floor();
    int minutes = getMinutesFromTime(ZoharEndValue);
    int hours = (ZoharEndValue / 60).floor();
    hours = (hours / 60).floor();
    double seconds = ZoharEndValue - (hours * 60 * 60);
    seconds = seconds - (minutes * 60);
    return "$zoharHours:$minutes";
  }

  String getZoharEndTime(DaylightResult sunsetRiseT, double dayGhari) {
    double ZoharEndValue = getZawaaalValue(sunsetRiseT) + (dayGhari * 2);

    int zoharHours = (ZoharEndValue / 60.0).floor();
    zoharHours = (zoharHours / 60.0).floor();

    int minutes = getMinutesFromTime(ZoharEndValue);

    int hours = (ZoharEndValue / 60).floor();
    hours = (hours / 60).floor();

    double seconds = ZoharEndValue - (hours * 60 * 60);

    seconds = seconds - (minutes * 60);

    return "$zoharHours:$minutes"; //[NSString stringWithFormat:@"%d:%d",zoharHours,minutes];
  }

  double getZawaaalValue(DaylightResult sunsetRiseT) {
    double sunsetValues = sunsetRiseT.sunset!.toLocal().hour * 60 * 60 +
        sunsetRiseT.sunset!.toLocal().minute * 60 +
        sunsetRiseT.sunset!.toLocal().second.toDouble();
    double sunriseValues = sunsetRiseT.sunrise!.toLocal().hour * 60 * 60 +
        sunsetRiseT.sunrise!.toLocal().minute * 60 +
        sunsetRiseT.sunrise!.toLocal().second.toDouble();
    return sunriseValues + ((sunsetValues - sunriseValues) / 2.0);
  }

  String getZawaaalTimeWithEDSunriseSet(DaylightResult sunsetRiseT) {
    double sunsetValues = sunsetRiseT.sunset!.toLocal().hour * 60 * 60 +
        sunsetRiseT.sunset!.toLocal().minute * 60 +
        sunsetRiseT.sunset!.toLocal().second.toDouble();

    double sunriseValues = sunsetRiseT.sunrise!.toLocal().hour * 60 * 60 +
        sunsetRiseT.sunrise!.toLocal().minute * 60 +
        sunsetRiseT.sunrise!.toLocal().second.toDouble();

    double zawaal = sunriseValues + ((sunsetValues - sunriseValues) / 2);

    int hours = (zawaal / 60).floor();
    hours = (hours / 60).floor();

    double seconds = zawaal - (hours * 60 * 60);
    int minutes = getMinutesFromTime(zawaal);

    seconds = seconds - (minutes * 60);

    return "$hours:$minutes"; //[NSString stringWithFormat:@"%d:%@",hours,[NSString stringWithFormat:@"%d",minutes]];
  }

  String getFajrTime(DaylightResult sunsetRiseT, double nightGhari) {
    double sunriseValues = sunsetRiseT.sunrise!.toLocal().hour * 60.0 * 60.0 +
        sunsetRiseT.sunrise!.toLocal().minute * 60.0 +
        sunsetRiseT.sunrise!.toLocal().second;
    double ZoharEndValue = sunriseValues - nightGhari;
    int zoharHours = (ZoharEndValue / 60.0).floor();
    zoharHours = (zoharHours / 60.0).floor();

    /*
        double sunriseValues = sunsetRise.localSunrise.hour * 60 * 60 + sunsetRise.localSunrise.minute * 60 + sunsetRise.localSunrise.second;
    double ZoharEndValue = sunriseValues - nightGhari ;
    int zoharHours = ZoharEndValue/60.0;
    zoharHours = zoharHours/ 60.0;
    * */
    return "$zoharHours:${getMinutesFromTime(ZoharEndValue)}";
  }

  int getMinutesFromTime(double zawaal) {
    double minutes = zawaal / 60.0;
    double hoursToShow = minutes / 60.0;
    double floatMinute = 60.0 * (hoursToShow - (hoursToShow).floorToDouble());

    int newMinute = (floatMinute).floor();

    return newMinute;
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


  Future<void> setTimes(List<DateTime> result) async {
    lblSahori = DateFormat('hh:mm a').format(result.first);
    lblFajarTiming = DateFormat('hh:mm a')
        .format(result[1]); //formatter stringFromDate:timings[1]];
    lblSunrise = DateFormat('hh:mm a').format(result[2]);
    lblZawaal = DateFormat('hh:mm a').format(result[3]);
    lblZoharTiming = DateFormat('hh:mm a').format(result[4]);
    lblAsrTiming = DateFormat('hh:mm a').format(result[5]);

    lblIshaTime = DateFormat('hh:mm a').format(result[7]);

    if (checkIsNextPrayer(result[0])) {
      nextPrayerText =
          'Sihori Time is at ${DateFormat('hh:mm a').format(result.first)}';
    } else if (checkIsNextPrayer(result[1])) {
      nextPrayerText =
          'Fajr Time is at ${DateFormat('hh:mm a').format(result[1])}';
    } else if (checkIsNextPrayer(result[2])) {
      nextPrayerText =
          'Sunrise Time is at ${DateFormat('hh:mm a').format(result[2])}';
    } else if (checkIsNextPrayer(result[3])) {
      nextPrayerText =
          'Zawaal Time is at ${DateFormat('hh:mm a').format(result[3])}';
    } else if (checkIsNextPrayer(result[4])) {
      nextPrayerText =
          'Zawaal End is at ${DateFormat('hh:mm a').format(result[4])}';
    } else if (checkIsNextPrayer(result[5])) {
      nextPrayerText =
          'Asr End is at ${DateFormat('hh:mm a').format(result[5])}';
    } else if (checkIsNextPrayer(result[6])) {
      nextPrayerText =
          'Magrib is at ${DateFormat('hh:mm a').format(result[6])}';
    } else if (checkIsNextPrayer(result[7])) {
      nextPrayerText =
          'Isha End is at ${DateFormat('hh:mm a').format(result[7])}';
    } else {
      var dateObj = await getNextDaySihoriTime(
          DateTime.now().add(Duration(days: 1)), latit, long);

      nextPrayerText =
          'Sihori Time is at ${DateFormat('hh:mm a').format(dateObj)}';

      // curentSohoriTime();

    }

    setState(() {
      lblMagribTiming = DateFormat('hh:mm a').format(result[6]);
    });
  }

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
        title: Image.asset(
          'assets/images/bismillah.png',
          height: 44,
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
                            imageName: 'event_icon',
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

                                var bihoriNamaz = otherData!.firstWhere((e) => e.title == 'Bihori Namaz');


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

                                if(otherData != null) {

                                  var otherToSend = otherData!.firstWhere((e) => e.title == 'Other Namaz');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>  ExtraNamazListing(isOther: true,monthlyData: otherToSend,),
                                    ),
                                  );
                                }


                              },
                              imageName: 'other_namaz',
                            ),                            PrayerItems(
                          title: 'Recite Duas',
                          onTap: () {


                            if(otherData != null) {

                              var otherToSend = otherData!.where((e) => e.title != 'Other Namaz' && e.title != 'Bihori Namaz').toList();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>  ExtraNamazListing(isDuas: true,monthlyListData: otherToSend,),
                                ),
                              );
                            }


                          },
                          imageName: 'recite_duas',
                        ),
                            ),
                        const SizedBox(
                          height: 16,
                        ),
                        buildRow(
                          context,
                          buildPersonalEventItem(context,tasbeeh: true),
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
                const SizedBox(
                  height: 8,
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

  PrayerItems buildPersonalEventItem(BuildContext context, {bool tasbeeh = false}) {
    if(tasbeeh) {
      return PrayerItems(
        title: 'Do Tasbeeh',
        onTap: () {
          //const ();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  const Tasbeeh(),
            ),
          );
        },
        imageName: 'tasbeeh',
      );
    }
    //tasbeeh.png
    return PrayerItems(
      title: '+ Personal Events',
      onTap: () {
        //const ();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PersonalEventListing(),
          ),
        );
      },
      imageName: 'personal_event',
    );
  }

  Row buildRowWithTwo(BuildContext context , PrayerItems item1 , PrayerItems item2){
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


  /*
    void getTimes() async {
    List<String>? resultLocation = await locationService.getLocationMapData();

    final prefs = await SharedPreferences.getInstance();

    if (resultLocation == null) {
      locationNotFound = true;

      lblSahori = '-';
      lblFajarTiming = '-';
      lblSunrise = '-';
      lblZawaal = '-';
      lblZoharTiming = '-';
      lblAsrTiming = "-";
      lblMagribTiming = "-";
      lblIshaTime = "-";

      if (prefs.getDouble('lat') != null) {

        double lT = 0.0, lG = 0.0;
        latit = lT;

        long = lG;

        locationNotFound = false;

        var result = await getNamazTimesWithLatLong(DateTime.now(), lT, lG);
        await setTimes(result);
      }
      return;
    }

    latit = double.parse(resultLocation.first);

    long = double.parse(resultLocation[1]);

    prefs.setDouble('lat', double.parse(resultLocation.first));
    prefs.setDouble('long', double.parse(resultLocation[1]));

    var result = await getNamazTimesWithLatLong(DateTime.now(),
        double.parse(resultLocation.first), double.parse(resultLocation[1]));
    await setTimes(result);

    print('Done');
  }

   */
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
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            ),
          )
        ],
      ),
    );
  }
}


