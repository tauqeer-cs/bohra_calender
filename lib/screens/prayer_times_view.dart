import 'package:bohra_calender/core/constants.dart';
import 'package:bohra_calender/model/date_service.dart';
import 'package:bohra_calender/services/location_service.dart';
import 'package:bohra_calender/services/notification_service.dart';
import 'package:daylight/daylight.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../views/prayer_item.dart';
import 'dashboard.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sunrise_sunset_calc/sunrise_sunset_calc.dart';

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

  int addDayLightSavingTime = 0;

  String lblMagribTiming = '', lblIshaTime = '', lblNisfulailTime = '';

  bool sihoriNotification = false;

  bool showingMore = false;

  void getInitialState() async {
    final prefs = await SharedPreferences.getInstance();
    sihoriNotification = prefs.getBool('sihori') ?? false;
    fajrNotification = prefs.getBool('fajr') ?? false;
    sunriseNotification = prefs.getBool('sunrise') ?? false;
    zawaalNotification = prefs.getBool('zawaal') ?? false;
    zuhrEndNotification = prefs.getBool('zuhr_end') ?? false;
    asrEndNotification = prefs.getBool('asr') ?? false;
    magribNotification = prefs.getBool('magrib') ?? false;
    ishaEndNotification = prefs.getBool('isha_end') ?? false;
    niftUlLailNotification = prefs.getBool('nisf_end') ?? false;
    isDaylight = prefs.getBool('daylight') ?? false;
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
  double lT = 0.0, lG = 0.0;

  bool addHalfAnHourtoTime = false;

  Placemark? _placemark;

  void getTimes() async {
    List<String>? resultLocation = await locationService.getLocationMapData(
      givePermission: () {
        setState(() {
          noLocationPermissionDisabled = true;
        });
      },
    );

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
      lblNisfulailTime = '-';

      if (prefs.getDouble('lat') != null) {
        latit = lT;

        long = lG;

        locationNotFound = false;

        bool? tmp = prefs.getBool('halfHourAdd');
        if (tmp != null) {
          addHalfAnHourtoTime = true;
        } else {
          addHalfAnHourtoTime = false;
        }
        var result = await getNamazTimesWithLatLong(DateTime.now(), lT, lG);
        await setTimes(result);
      }
      return;
    }

    List<Placemark> placemarks = await placemarkFromCoordinates(
        double.parse(resultLocation.first), double.parse(resultLocation[1]));

    if (placemarks.isNotEmpty) {

      setState(() {
        _placemark = placemarks.first;
      });
      if (placemarks.first.country == 'India') {

        setState(() {
          _placemark = placemarks.first;
        });

        addHalfAnHourtoTime = true;

        prefs.setBool('halfHourAdd', true);

        
        /*
        if (DateTime.now().timeZoneName == 'PKT') {
          addHalfAnHourtoTime = true;
          prefs.setBool('halfHourAdd', true);
        } else {
          addHalfAnHourtoTime = false;
        }*/


      }
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
    lblNisfulailTime = DateFormat('hh:mm a').format(result[8]);

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
    var sunR = sunsetRise.sunrise!.toLocal();

    var secondsBetweenDuration =
        sunsetRise.sunset!.difference(sunsetRise.sunrise!.toLocal());


    //here
    var sunriseSunset = getSunriseSunset(lat, longitude, 1, DateTime.now());
   // var s5 = sunriseSunset.sunrise.toLocal();


   // secondsBetweenDuration =
     //   sunsetRise.sunset!.difference(sunsetRise.sunrise!);

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
    DateTime nasfus = zawalDate.add(const Duration(hours: 12));

    if (isDaylight) {
      curentSohoriTime = curentSohoriTime.add(const Duration(hours: -1));
      newFajrTime = newFajrTime.add(const Duration(hours: -1));
      lblSunriseTime = lblSunriseTime.add(const Duration(hours: -1));
      zawalDate = zawalDate.add(const Duration(hours: -1));
      zoharEndDate = zoharEndDate.add(const Duration(hours: -1));
      asrEndDate = asrEndDate = asrEndDate.add(const Duration(hours: 1));
      lblSunsetTime = lblSunsetTime.add(const Duration(hours: -1));
      ishaEnd = ishaEnd.add(const Duration(hours: -1));
      nasfus = nasfus.add(const Duration(hours: -1));
    }
    if (addHalfAnHourtoTime) {
      curentSohoriTime = curentSohoriTime.add(const Duration(minutes: 30));
      newFajrTime = newFajrTime.add(const Duration(minutes: 30));
      lblSunriseTime = lblSunriseTime.add(const Duration(minutes: 30));
      zawalDate = zawalDate.add(const Duration(minutes: 30));
      zoharEndDate = zoharEndDate.add(const Duration(minutes: 30));
      asrEndDate = asrEndDate = asrEndDate.add(const Duration(minutes: 30));
      lblSunsetTime = lblSunsetTime.add(const Duration(minutes: 30));
      ishaEnd = ishaEnd.add(const Duration(minutes: 30));
      nasfus = nasfus.add(const Duration(minutes: 30));
    }

    return [
      curentSohoriTime,
      newFajrTime,
      lblSunriseTime,
      zawalDate,
      zoharEndDate,
      asrEndDate,
      lblSunsetTime,
      ishaEnd,
      nasfus
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

  bool magribNotification = false,
      ishaEndNotification = false,
      niftUlLailNotification = false;

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

        if (difference > 0) {
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

        if (difference > 0) {
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

    if (asrEndNotification) {
      prefs.setBool('asr', true);
    } else {
      prefs.setBool('asr', true);
    }

    setState(() {
      asrEndNotification = !asrEndNotification;
    });

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

  bool isDaylight = false;

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
              const SizedBox(
                height: 32,
              ),
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
                            onTap: zohrEndNot),
                        PrayerItem(
                          name: 'Asr End',
                          time: lblAsrTiming,
                          icon: 'asr_end',
                          isNotificationOn: asrEndNotification,
                          onTap: asrNotTapped,
                        ),
                        PrayerItem(
                          name: 'Magrib',
                          time: lblMagribTiming,
                          icon: 'magrib',
                          isNotificationOn: magribNotification,
                          onTap: magribNot,
                        ),
                        PrayerItem(
                          name: 'Isha End/Nisf-ul-Layl',
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
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(),
              ),

              if (1 == 2) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Text(
                        'Adjust the time for daylight saving:',
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Checkbox(
                        value: isDaylight,
                        onChanged: (bool? value) async {
                          if (value != null) {
                            setState(() {
                              isDaylight = value;

                              if (isDaylight) {
                                addDayLightSavingTime = 1;
                              } else {
                                addDayLightSavingTime = 0;
                              }
                            });

                            //      if (prefs.getDouble('lat') != null) {
                            final prefs = await SharedPreferences.getInstance();
                            prefs.setBool('daylight', isDaylight);
                          }

                          var result = await getNamazTimesWithLatLong(
                              DateTime.now(), latit, long);
                          await setTimes(result);
                        },
                      ),
                    ],
                  ),
                ),
              ],
//
              //  ;

//    ;


            if(_placemark != null) ... [
              if (_placemark!.country == 'India' || 1 == 1) ...[
                Text(
                    '${_placemark!.locality} with your phone timezone set to ' +
                        DateTime.now().timeZoneName),
              ],

            ],


              //isDaylight
              const SizedBox(
                height: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
