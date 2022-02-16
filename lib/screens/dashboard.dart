import 'package:bohra_calender/core/colors.dart';
import 'package:bohra_calender/core/constants.dart';
import 'package:bohra_calender/model/calender_item_info.dart';
import 'package:bohra_calender/model/monthly_data.dart';
import 'package:bohra_calender/model/prayer_time.dart';
import 'package:bohra_calender/screens/personal_event_listing.dart';
import 'package:bohra_calender/services/data_service.dart';
import 'package:bohra_calender/services/location_service.dart';
import 'package:bohra_calender/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'events_list.dart';
import 'extra_name_listing.dart';
import 'package:daylight/daylight.dart';
import 'dart:io' show Platform;

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

//<AppLifecycleReactor>
class _DashboardState extends State<Dashboard> with WidgetsBindingObserver {
  bool showingMore = false;

  bool sihoriNotification = false,
      fajrNotification = false,
      sunriseNotification = false,
      zawaalNotification = false,
      zuhrEndNotification = false,
      asrEndNotification = false,
      magribNotification = false,
      ishaEndNotification = false;

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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
    });

    locationNotFound = false;

    getTimes();

    loadData();
  }

  String get todayNormalDate {
    return DateFormat('EEEE d MMM yyyy').format(DateTime.now());
  }

  double latit = 0.0, long = 0.0;

  List<MonthlyData> monthlyData = [];
  List<MonthlyData> completeMonthData = [];

  void loadData() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool('sihori') != null) {
      sihoriNotification = prefs.getBool('sihori')!;
    } else {
      sihoriNotification = false;
    }

    if (prefs.getBool('fajr') != null) {
      fajrNotification = prefs.getBool('fajr')!;
    } else {
      fajrNotification = false;
    }

    if (prefs.getBool('sunrise') != null) {
      sunriseNotification = prefs.getBool('sunrise')!;
    } else {
      sunriseNotification = false;
    }

    if (prefs.getBool('zawaal') != null) {
      zawaalNotification = prefs.getBool('zawaal')!;
    } else {
      zawaalNotification = false;
    }

    if (prefs.getBool('zuhr_end') != null) {
      zuhrEndNotification = prefs.getBool('zuhr_end')!;
    } else {
      zuhrEndNotification = false;
    }

    if (prefs.getBool('magrib') != null) {
      magribNotification = prefs.getBool('magrib')!;
    } else {
      magribNotification = false;
    }

    if (prefs.getBool('isha_end') != null) {
      ishaEndNotification = prefs.getBool('isha_end')!;
    } else {
      ishaEndNotification = false;
    }

    if (prefs.getBool('asr') != null) {
      asrEndNotification = prefs.getBool('asr')!;
    } else {
      asrEndNotification = false;
    }

    /*








     */
    var monthData =
        await dataService.getEventsWithFiles(accessSavedObject: true);
    completeMonthData = monthData;

    var _today =
        HijriCalendar.fromDate(DateTime.now()); //;.add(Duration(days: 9)));

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
  }

  Widget getTodaysEvent() {
    var _today = HijriCalendar.now();
    if (monthlyData.isEmpty) {
      return Container();
    }
    return Container(
      color: Colors.white.withOpacity(0.5),
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
              Padding(
                padding: i == 0
                    ? const EdgeInsets.all(16.0)
                    : const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  //   height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: CColors.green_main,
                    boxShadow: const [
                      BoxShadow(color: Colors.black, spreadRadius: 3),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.calendar,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Text(
                            '${_today.hDay} ${ClassItemInfo.islamicMonthName[_today.hMonth]}\n${monthlyData[i].title}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
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

    DateTime curentSohoriTime = makeDateFromString(dayString, dateStringFormat);
    //NSDate * curentSohoriTime = [DateFormatter makeDataFromString:dayString withDateFormate:dateStringFormat];

    if (sunsetRise.sunrise!.toLocal().second > 2) {
      curentSohoriTime = curentSohoriTime.add(Duration(minutes: 1));
    }

    String lblSunriseString =
        "${sunsetRise.sunrise!.toLocal().hour}:${sunsetRise.sunrise!.toLocal().minute}";

    lblSunriseString = "$currentDateString $lblSunriseString";

    DateTime lblSunriseTime =
        makeDateFromString(lblSunriseString, dateStringFormat);

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

    DateTime curentSohoriTime = makeDateFromString(dayString, dateStringFormat);
    //NSDate * curentSohoriTime = [DateFormatter makeDataFromString:dayString withDateFormate:dateStringFormat];

    if (sunsetRise.sunrise!.toLocal().second > 2) {
      curentSohoriTime = curentSohoriTime.add(Duration(minutes: 1));
    }

    String lblSunriseString =
        "${sunsetRise.sunrise!.toLocal().hour}:${sunsetRise.sunrise!.toLocal().minute}";

    lblSunriseString = "$currentDateString $lblSunriseString";

    DateTime lblSunriseTime =
        makeDateFromString(lblSunriseString, dateStringFormat);

    curentSohoriTime = lblSunriseTime.subtract(const Duration(minutes: 75));

    String newFajr = getFajrTime(sunsetRise, nightGhari);

    newFajr =
        "$currentDateString $newFajr"; //[NSString stringWithFormat:@"%@ %@",currentDateString,newFajr];
    DateTime newFajrTime = makeDateFromString(newFajr, dateStringFormat);
    String zawalString = getZawaaalTimeWithEDSunriseSet(sunsetRise);

    zawalString = "$currentDateString $zawalString";

    DateTime zawalDate = makeDateFromString(zawalString, dateStringFormat);

    String zoharEndString = getZoharEndTime(sunsetRise, dayGhari);

    zoharEndString =
        "$currentDateString $zoharEndString"; //[NSString stringWithFormat:@"%@ %@",currentDateString,zoharEndString];

    DateTime zoharEndDate =
        makeDateFromString(zoharEndString, dateStringFormat);

    String asrEndString = getAsrEndTime(sunsetRise, dayGhari);
    asrEndString = "$currentDateString $asrEndString";
    DateTime asrEndDate = makeDateFromString(asrEndString,
        dateStringFormat); //[DateFormatter makeDataFromString:asrEndString withDateFormate:dateStringFormat];

    String lblSetString =
        "${sunsetRise.sunset!.toLocal().hour}:${sunsetRise.sunset!.toLocal().minute}";
    lblSetString = "$currentDateString $lblSetString";

    DateTime lblSunsetTime = makeDateFromString(lblSetString, dateStringFormat);

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

  DateTime makeDateFromString(String givenDate, String format) {
    if (format.isEmpty) {
      format = "yyyy-MM-dd HH:mm:ss";
    }

    if (givenDate.isEmpty) {
      return DateTime.now();
    }

    var inputFormat = DateFormat(format);
    return inputFormat.parse(givenDate);
  }

  void setupNot() async {}

  @override
  void initState() {
    super.initState();
    var pTime = PrayTime();
    pTime.calcMethod = PTKCalculationMethod.PTKCalculationMethodJafari;
    pTime.asrJuristic = PTKJuristicMethod.PTKJuristicMethodShafii;
    WidgetsBinding.instance!.addObserver(this);

    getTimes();
    loadData();

    setupNot();
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
      body: Container(
        decoration: Constants.backgroundPAttern,
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
                        color: Colors.white,
                        fontSize: 20,
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
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),
                if (locationNotFound) ...[
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(bottom: 4),
                              child: Text(
                                'Location Not Found',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w700),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'Please enable location service so that app can get proper prayer times for you',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      nextPrayerText,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            if (showingMore) ...[
                              PrayerItem(
                                name: 'Sihori',
                                time: lblSahori,
                                icon: WeatherIcons.horizon,
                                isNotificationOn: sihoriNotification,
                                onTap: () async {
                                  setState(() {
                                    sihoriNotification = !sihoriNotification;
                                  });
                                  final prefs =
                                      await SharedPreferences.getInstance();

                                  if (sihoriNotification) {
                                    prefs.setBool('sihori', true);
                                  } else {
                                    prefs.setBool('sihori', true);
                                  }

                                  setNoticiationsItems();
                                },
                              ),
                              PrayerItem(
                                name: 'Fajr',
                                time: lblFajarTiming,
                                isNotificationOn: fajrNotification,
                                icon: WeatherIcons.horizon_alt,
                                onTap: () {
                                  fajrNotTapped();
                                },
                              ),
                              PrayerItem(
                                name: 'Sunrise',
                                time: lblSunrise,
                                icon: WeatherIcons.sunrise,
                                isNotificationOn: sunriseNotification,
                                onTap: () {
                                  sunriseTapped();
                                },
                              ),
                              PrayerItem(
                                name: 'Zawaal',
                                time: lblZawaal,
                                icon: WeatherIcons.day_sunny,
                                isNotificationOn: zawaalNotification,
                                onTap: () {
                                  zawaalNotTapped();
                                },
                              ),
                              PrayerItem(
                                name: 'Zuhr End',
                                time: lblZoharTiming,
                                icon: WeatherIcons.day_sunny_overcast,
                                isNotificationOn: zuhrEndNotification,
                                onTap: () async {
                                  zohrEndNot();
                                },
                              ),
                              PrayerItem(
                                name: 'Magrib',
                                time: lblMagribTiming,
                                icon: WeatherIcons.sunset,
                                isNotificationOn: magribNotification,
                                onTap: magribNot,
                              ),
                              PrayerItem(
                                name: 'Isha End',
                                time: lblIshaTime,
                                icon: WeatherIcons.day_sunny_overcast,
                                isNotificationOn: ishaEndNotification,
                                onTap: () async {
                                  setState(() {
                                    ishaEndNotification = !ishaEndNotification;
                                  });

                                  final prefs =
                                      await SharedPreferences.getInstance();

                                  if (ishaEndNotification) {
                                    prefs.setBool('isha_end', true);
                                  } else {
                                    prefs.setBool('isha_end', true);
                                  }

                                  setNoticiationsItems();
                                },
                              ),
                            ] else ...[
                              PrayerItem(
                                name: 'Fajr',
                                time: lblFajarTiming,
                                icon: WeatherIcons.horizon_alt,
                                isNotificationOn: ishaEndNotification,
                                onTap: fajrNotTapped,
                              ),
                              PrayerItem(
                                name: 'Sunrise',
                                time: lblSunrise,
                                icon: WeatherIcons.sunrise,
                                isNotificationOn: sunriseNotification,
                                onTap: sunriseTapped,
                              ),
                              PrayerItem(
                                name: 'Zawaal',
                                time: lblZawaal,
                                icon: WeatherIcons.day_sunny,
                                isNotificationOn: zawaalNotification,
                                onTap: zawaalNotTapped,
                              ),
                              PrayerItem(
                                name: 'Zuhr End',
                                time: lblZoharTiming,
                                icon: WeatherIcons.day_sunny_overcast,
                                isNotificationOn: zuhrEndNotification,
                                onTap: zohrEndNot,
                              ),
                              PrayerItem(
                                name: 'Asr End',
                                time: lblMagribTiming,
                                icon: WeatherIcons.sunset,
                                isNotificationOn: asrEndNotification,
                                onTap: asrNotTapped,
                              ),
                            ],
                            IconButton(
                              icon: Icon(showingMore
                                  ? FontAwesomeIcons.angleDown
                                  : FontAwesomeIcons.angleUp), //angleUp
                              iconSize: 24,
                              onPressed: () {
                                setState(() {
                                  showingMore = !showingMore;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],

                if (monthlyData.isEmpty) ...[
                  Container(
                    height: 2,
                  ),
                ] else ...[
                  Container(
                    height: 10,
                  ),
                ],

                getTodaysEvent(),

                const SizedBox(
                  height: 16,
                ),

                //extra-namaz.png
                // events-list.png

                Container(
                  color: Colors.white.withOpacity(0.5),
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: PrayerItems(
                                title: 'Extra Namaz',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ExtraNamazListing(),
                                    ),
                                  );
                                },
                                imageName: 'extra-namaz',
                              ),
                            ),
                            Expanded(
                              child: PrayerItems(
                                title: 'View Event',
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
                                imageName: 'events-list',
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(),
                            ),
                            Expanded(
                              flex: 2,
                              child: PrayerItems(
                                title: 'Personal Events',
                                onTap: () {
                                  //const ();

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PersonalEventListing(),
                                    ),
                                  );
                                },
                                imageName: 'personal-event',
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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

  Future<void> magribNot() async {
    setState(() {
      magribNotification = !magribNotification;
    });

    final prefs = await SharedPreferences.getInstance();

    if (magribNotification) {
      prefs.setBool('magrib', true);
    } else {
      prefs.setBool('magrib', true);
    }
    setNoticiationsItems();
  }

  Future<void> zohrEndNot() async {
    setState(() {
      zuhrEndNotification = !zuhrEndNotification;
    });

    final prefs = await SharedPreferences.getInstance();

    if (zuhrEndNotification) {
      prefs.setBool('zuhr_end', true);
    } else {
      prefs.setBool('zuhr_end', true);
    }

    setNoticiationsItems();
  }

  Future<void> zawaalNotTapped() async {
    setState(() {
      zawaalNotification = !zawaalNotification;
    });

    final prefs = await SharedPreferences.getInstance();

    if (sihoriNotification) {
      prefs.setBool('zawaal', true);
    } else {
      prefs.setBool('zawaal', true);
    }

    setNoticiationsItems();
  }

  Future<void> asrNotTapped() async {
    final prefs = await SharedPreferences.getInstance();

    if (sunriseNotification) {
      prefs.setBool('asr', true);
    } else {
      prefs.setBool('asr', true);
    }

    setState(() {
      sunriseNotification = !sunriseNotification;
    });

    setNoticiationsItems();
  }

  Future<void> sunriseTapped() async {
    final prefs = await SharedPreferences.getInstance();

    if (sunriseNotification) {
      prefs.setBool('sunrise', true);
    } else {
      prefs.setBool('sunrise', true);
    }

    setState(() {
      sunriseNotification = !sunriseNotification;
    });

    setNoticiationsItems();
  }

  Future<void> fajrNotTapped() async {
    setState(() {
      fajrNotification = !fajrNotification;
    });

    final prefs = await SharedPreferences.getInstance();

    if (fajrNotification) {
      prefs.setBool('fajr', true);
    } else {
      prefs.setBool('fajr', true);
    }

    setNoticiationsItems();
  }

  void setNoticiationsItems() async {
    NoticiationApi.cancelAll();

    for (int i = 0; i < 3; i++) {
      var dateObject = DateTime.now().add(Duration(days: i));

      var result = await getNamazTimesWithLatLong(DateTime.now(), latit, long);

      if (sihoriNotification) {
        NoticiationApi.showTimedNotification(
            scheduledDate: DateTime(
              dateObject.year,
              dateObject.month,
              dateObject.day,
              result.first.hour,
              result.first.minute,
            ),
            title: 'Sihori',
            body: 'Sihori time has started');
      }

      if (fajrNotification) {
        NoticiationApi.showTimedNotification(
            scheduledDate: DateTime(dateObject.year, dateObject.month,
                dateObject.day, result[1].hour, result[1].minute),
            title: 'Fajr',
            body: 'Time to pray fajr');
      }

      if (sunriseNotification) {
        NoticiationApi.showTimedNotification(
            scheduledDate: DateTime(dateObject.year, dateObject.month,
                dateObject.day, result[2].hour, result[2].minute),
            title: 'Sunrise',
            body: 'Sunrise time , you cant pray fajr anymore');
      }

      if (zawaalNotification) {
        NoticiationApi.showTimedNotification(
          scheduledDate: DateTime(dateObject.year, dateObject.month,
              dateObject.day, result[3].hour, result[3].minute),
            title: 'Zawaal',
            body: 'Its zawaal time now'

        );
      }

      if (zuhrEndNotification) {
        NoticiationApi.showTimedNotification(
            scheduledDate: DateTime(dateObject.year, dateObject.month,
                dateObject.day, result[4].hour, result[4].minute),
            title: 'Zuhr end',
            body: 'Zuhr time ended'
        );
      }

      if (asrEndNotification) {
        NoticiationApi.showTimedNotification(
            scheduledDate: DateTime(dateObject.year, dateObject.month,
                dateObject.day, result[5].hour, result[5].minute),
            title: 'Asr End',
            body: 'Asr End');
      }

      if (magribNotification) {
        NoticiationApi.showTimedNotification(
            scheduledDate: DateTime(dateObject.year, dateObject.month,
                dateObject.day, result[6].hour, result[6].minute),
            title: 'Magrib',
            body: 'Its magrib time.');
      }

      if (ishaEndNotification) {
        NoticiationApi.showTimedNotification(
            scheduledDate: DateTime(dateObject.year, dateObject.month,
                dateObject.day, result[7].hour, result[7].minute),
            title: 'Isha End',
            body: 'Isha Time has ended');
      }
    }
    /*
    lblSahori = DateFormat('hh:mm a').format(result.first);
    lblFajarTiming = DateFormat('hh:mm a')
        .format(result[1]); //formatter stringFromDate:timings[1]];
    lblSunrise = DateFormat('hh:mm a').format(result[2]);
    lblZawaal = DateFormat('hh:mm a').format(result[3]);
    lblZoharTiming = DateFormat('hh:mm a').format(result[4]);
    lblAsrTiming = DateFormat('hh:mm a').format(result[5]);

    lblIshaTime = DateFormat('hh:mm a').format(result[7]);
     */

    print('');
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
    return Column(
      children: [
        TextButton(
          onPressed: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/images/$imageName.png',
            ),
          ),
        ),
        Text(
          title,
          style: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
        )
      ],
    );
  }
}

class PrayerItem extends StatelessWidget {
  final IconData icon;
  final String time;
  final String name;
  final bool isNotificationOn;

  final VoidCallback onTap;

  const PrayerItem({
    Key? key,
    required this.icon,
    required this.time,
    required this.name,
    required this.onTap,
    this.isNotificationOn = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.green,
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Text(name),
              ),
              //const Icon(Icons.notifications_off_outlined ),
              const SizedBox(
                width: 16,
              ),
              Text(time),
              const SizedBox(
                width: 16,
              ),
              if (isNotificationOn) ...[
                GestureDetector(
                  onTap: onTap,
                  child: const Icon(
                    Icons.notifications_outlined,
                    color: CColors.green_main,
                  ),
                ),
              ] else ...[
                GestureDetector(
                  onTap: onTap,
                  child: const Icon(
                    Icons.notifications_off_outlined,
                    color: CColors.green_main,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(
            height: 1,
          ),
          const Divider(
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
