import 'package:bohra_calender/core/colors.dart';
import 'package:bohra_calender/core/constants.dart';
import 'package:bohra_calender/model/date_service.dart';
import 'package:bohra_calender/services/location_service.dart';
import 'package:bohra_calender/services/notification_service.dart';
import 'package:daylight/daylight.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_icons/weather_icons.dart';

import 'dashboard.dart';

class PrayersTimeView extends StatefulWidget {
  const PrayersTimeView({Key? key}) : super(key: key);

  @override
  _PrayersTimeViewState createState() => _PrayersTimeViewState();
}

class _PrayersTimeViewState extends State<PrayersTimeView> {
  String lblSahori = '',
      lblFajarTiming = '',
      lblSunrise = '',
      lblZawaal = '',
      lblZoharTiming = '';

  String lblMagribTiming = '', lblIshaTime = '';

  bool sihoriNotification = false;

  bool showingMore = false;

  void getInitialState() async {
    final prefs = await SharedPreferences.getInstance();
    sihoriNotification = prefs.getBool('sihori') ?? false;
    fajrNotification =  prefs.getBool('fajr') ?? false;
    sunriseNotification = prefs.getBool('sunrise') ?? false;
    zawaalNotification = prefs.getBool('zawaal') ?? false;
    zuhrEndNotification = prefs.getBool('zuhr_end') ?? false;
    asrEndNotification = prefs.getBool('asr') ?? false;
    magribNotification = prefs.getBool('magrib') ?? false;
    ishaEndNotification = prefs.getBool('isha_end') ?? false;




  }
  @override
  void initState() {
    super.initState();

    getInitialState();

    getTimes();
  }

  bool locationNotFound = false;
  String lblAsrTiming = '';
  bool noLocationPermissionDisabled = false;

  void getTimes() async {
    List<String>? resultLocation =
        await locationService.getLocationMapData(givePermission: () {
      setState(() {
        noLocationPermissionDisabled = true;
      });
    });

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

    noLocationPermissionDisabled = false;

    latit = double.parse(resultLocation.first);

    long = double.parse(resultLocation[1]);

    prefs.setDouble('lat', double.parse(resultLocation.first));
    prefs.setDouble('long', double.parse(resultLocation[1]));

    var result = await getNamazTimesWithLatLong(DateTime.now(),
        double.parse(resultLocation.first), double.parse(resultLocation[1]));
    await setTimes(result);

    print('Done');
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

  double latit = 0.0, long = 0.0;

  int getMinutesFromTime(double zawaal) {
    double minutes = zawaal / 60.0;
    double hoursToShow = minutes / 60.0;
    double floatMinute = 60.0 * (hoursToShow - (hoursToShow).floorToDouble());

    int newMinute = (floatMinute).floor();

    return newMinute;
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

  double getZawaaalValue(DaylightResult sunsetRiseT) {
    double sunsetValues = sunsetRiseT.sunset!.toLocal().hour * 60 * 60 +
        sunsetRiseT.sunset!.toLocal().minute * 60 +
        sunsetRiseT.sunset!.toLocal().second.toDouble();
    double sunriseValues = sunsetRiseT.sunrise!.toLocal().hour * 60 * 60 +
        sunsetRiseT.sunrise!.toLocal().minute * 60 +
        sunsetRiseT.sunrise!.toLocal().second.toDouble();
    return sunriseValues + ((sunsetValues - sunriseValues) / 2.0);
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
      lblSunsetTime = lblSunsetTime.add(const Duration(minutes: 1));
    }

    DateTime ishaEnd = zawalDate.add(const Duration(hours: 12));

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

  bool magribNotification = false, ishaEndNotification = false;

  bool fajrNotification = false,
      zawaalNotification = false,
      sunriseNotification = false,
      zuhrEndNotification = false,
      asrEndNotification = false;

  void setNoticiationsItems() async {
    NoticiationApi.cancelAll();

    for (int i = 0; i < 5; i++) {
      var dateObject = DateTime.now().add(Duration(days: i));

      var result = await getNamazTimesWithLatLong(dateObject, latit, long);

      if (sihoriNotification) {
        var difference = result[0].compareTo(DateTime.now());

        if(difference > 0) {
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

      }

      if (fajrNotification) {
        //result[1]

        var difference = result[1].compareTo(DateTime.now());

        if(difference > 0){
          NoticiationApi.showTimedNotification(
              scheduledDate: DateTime(dateObject.year, dateObject.month,
                  dateObject.day, result[1].hour, result[1].minute),
              title: 'Fajr',
              body: 'Time to pray fajr');
        }

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
            body: 'Its zawaal time now');
      }

      if (zuhrEndNotification) {
        NoticiationApi.showTimedNotification(
            scheduledDate: DateTime(dateObject.year, dateObject.month,
                dateObject.day, result[4].hour, result[4].minute),
            title: 'Zuhr end',
            body: 'Zuhr time ended');
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
        var difference = result[7].compareTo(DateTime.now());


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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Namaz Times'),
      ),
      body: SafeArea(
        child: Container(
          color: Constants.backgroundPatternTopColor,
          child: Column(
            children: [
              SizedBox(height: 40,),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        PrayerItem(
                          name: 'Sihori',
                          time: lblSahori,
                          icon: 'sihoro',
                          isNotificationOn: sihoriNotification,
                          onTap: () async {
                            setState(() {
                              sihoriNotification = !sihoriNotification;
                            });
                            final prefs = await SharedPreferences.getInstance();

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
                          icon: 'fajr',
                          onTap: () {
                            fajrNotTapped();
                          },
                        ),
                        PrayerItem(
                          name: 'Sunrise',
                          time: lblSunrise,
                          icon: 'sunrise',
                          isNotificationOn: sunriseNotification,
                          onTap: () {
                            sunriseTapped();
                          },
                        ),
                        PrayerItem(
                          name: 'Zawaal',
                          time: lblZawaal,
                          icon: 'zawaal',
                          isNotificationOn: zawaalNotification,
                          onTap: () {
                            zawaalNotTapped();
                          },
                        ),
                        PrayerItem(
                            name: 'Zuhr End',
                            time: lblZoharTiming,
                            icon: 'zuhr_end',
                            isNotificationOn: zuhrEndNotification,
                            onTap: asrNotTapped),
                        PrayerItem(
                          name: 'Asr End',
                          time: lblMagribTiming,
                          icon: 'asr_end',
                          isNotificationOn: magribNotification,
                          onTap: magribNot,
                        ),
                        PrayerItem(
                          name: 'Magrib',
                          time: lblMagribTiming,
                          icon: 'magrib',
                          isNotificationOn: magribNotification,
                          onTap: magribNot,
                        ),
                        PrayerItem(
                          name: 'Isha End',
                          time: lblIshaTime,
                          icon: 'isha_end',
                          isNotificationOn: ishaEndNotification,
                          onTap: () async {
                            setState(() {
                              ishaEndNotification = !ishaEndNotification;
                            });

                            final prefs = await SharedPreferences.getInstance();

                            if (ishaEndNotification) {
                              prefs.setBool('isha_end', true);
                            } else {
                              prefs.setBool('isha_end', true);
                            }

                            setNoticiationsItems();
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        /*
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
                      */
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
              if (locationNotFound) ...[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
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
                if (nextPrayerText.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      nextPrayerText,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ],
 */

class PrayerItem extends StatelessWidget {
  final String icon;
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
              Image.asset(
                "assets/icons/$icon.png",
                width: 24,
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
                  child: const ImageIcon(
                    AssetImage("assets/icons/bell_on.png"),
                    color: CColors.green_main,
                  ),
                ),
              ] else ...[
                GestureDetector(
                  onTap: onTap,
                  child: const ImageIcon(
                    AssetImage("assets/icons/bell-off.png"),
                    color: CColors.green_main,
                  ),
                ),
              ],
              const SizedBox(
                width: 4,
              ),
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
