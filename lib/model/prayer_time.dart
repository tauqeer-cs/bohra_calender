import 'dart:ffi';
import 'dart:math';

enum PTKCalculationMethod {
  PTKCalculationMethodJafari, // Ithna Ashari
  PTKCalculationMethodKarachi, // University of Islamic Sciences, Karachi
  PTKCalculationMethodISNA, // Islamic Society of North America (ISNA)
  PTKCalculationMethodMWL, // Muslim World League (MWL)
  PTKCalculationMethodMakkah, // Umm al-Qura, Makkah
  PTKCalculationMethodEgypt, // Egyptian General Authority of Survey
  PTKCalculationMethodTehran, // Institute of Geophysics, University of Tehran
  PTKCalculationMethodCustom,
}

enum PTKJuristicMethod {
  PTKJuristicMethodShafii, // Shafii (standard)
  PTKJuristicMethodHanafi
}

enum PTKHigherLatitudes {
  PTKHigherLatitudesNone, // No adjustment
  PTKHigherLatitudesMidNight, // middle of night
  PTKHigherLatitudesOneSeventh, // 1/7th of night
  PTKHigherLatitudesAngleBased
}

enum PTKTimeFormat {
  PTKTimeFormatTime24, // 24-hour format
  PTKTimeFormatTime12WithSuffix, // 12-hour format with suffix
  PTKTimeFormatTime12NoSuffix, // 12-hour format with no suffix
  PTKTimeFormatFloat, // floating point number
  PTKTimeFormatNSDate
}

class PrayTime {
  String PTKInvalidTimeString = '';
  List<String> timeNames = [];
  int numIterations = 0;
  Map<PTKCalculationMethod, List<double>> methodParams = {};

  List<String> prayerTimesCurrent = [];
  List<int> offsets = [];

  PTKCalculationMethod calcMethod =
      PTKCalculationMethod.PTKCalculationMethodJafari;
  PTKJuristicMethod asrJuristic = PTKJuristicMethod.PTKJuristicMethodShafii;
  PTKHigherLatitudes adjustHighLats =
      PTKHigherLatitudes.PTKHigherLatitudesAngleBased;

  PTKTimeFormat timeFormat = PTKTimeFormat.PTKTimeFormatFloat;

  double dhuhrMinutes = 0.0;

  double latitude = 0.0;
  double longitude = 0.0;
  double timeZone = 0.0;

  int calcYear = 0;
  int calcMonth = 0;
  int calcDay = 0;
  double JDate = 0.0;

  void init() {
    calcMethod = PTKCalculationMethod.PTKCalculationMethodJafari;
    asrJuristic = PTKJuristicMethod.PTKJuristicMethodShafii;
    dhuhrMinutes = 0;
    adjustHighLats = PTKHigherLatitudes.PTKHigherLatitudesMidNight;
    timeFormat = PTKTimeFormat.PTKTimeFormatTime24;

    timeNames = [
      "Fajr",
      "Sunrise",
      "Dhuhr",
      "Asr",
      "Sunset",
      "Maghrib",
      "Isha"
    ];

    numIterations = 1; // number of iterations needed to compute times
    offsets = [
      0, //fajr
      0, //sunrise
      0, //dhuhr
      0, //asr
      0, //sunset
      0, //maghrib
      0, //isha
    ];

    methodParams = {
      PTKCalculationMethod.PTKCalculationMethodJafari: [
        16.0,
        0.0,
        4.0,
        0.0,
        14.0
      ],
      PTKCalculationMethod.PTKCalculationMethodKarachi: [
        18.0,
        1.0,
        0.0,
        0.0,
        18.0
      ],
      PTKCalculationMethod.PTKCalculationMethodISNA: [
        15.0,
        1.0,
        0.0,
        0.0,
        15.0
      ],
      PTKCalculationMethod.PTKCalculationMethodMWL: [18.0, 1.0, 0.0, 0.0, 17.0],
      PTKCalculationMethod.PTKCalculationMethodMakkah: [
        18.5,
        1.0,
        0.0,
        1.0,
        90.0
      ],
      PTKCalculationMethod.PTKCalculationMethodEgypt: [
        19.5,
        1.0,
        0.0,
        0.0,
        17.5
      ],
      PTKCalculationMethod.PTKCalculationMethodTehran: [
        17.7,
        0.0,
        4.5,
        0.0,
        14.0
      ],
      PTKCalculationMethod.PTKCalculationMethodCustom: [
        18.0,
        1.0,
        0.0,
        0.0,
        17.0
      ]
    };
  }

  /*
  double getTimeZone {
  NSTimeZone *timeZone = [NSTimeZone localTimeZone];
  double hoursDiff = [timeZone secondsFromGMT]/3600.0f;
  return hoursDiff;
  }*/

  //: (int)year :(int)month :(int)day
  double julianDateAndMonthAndDay(int year, int month, int day) {
    if (month <= 2) {
      year -= 1;
      month += 12;
    }
    //here here
    double A = (year / 100.0).floorToDouble();
    double B = 2 - A + (A / 4.0).floorToDouble();

    double JD = (365.25 * (year + 4716)).floorToDouble() +
        (30.6001 * (month + 1)).floorToDouble() +
        day +
        B -
        1524.5;

    return JD;
  }

  double fixangle(double a) {
    a = a - (360 * ((a / 360.0).floorToDouble()));
    a = a < 0 ? (a + 360) : a;
    return a;
  }

  double dsin(double d) {
    return sin(DegreesToRadians(d));
  }

  double DegreesToRadians(double alpha) {
    return ((alpha * M_PI) / 180.0);
  }

  double dcos(double d) {
    return cos(DegreesToRadians(d));
  }

// degree tan
  double dtan(double d) {
    return tan(DegreesToRadians(d));
  }

  // radian to degree
  double radiansToDegrees(double alpha) {
    return ((alpha * 180.0) / M_PI);
  }

  // degree arcsin
  double darcsin(double x) {
    double val = asin(x);
    return radiansToDegrees(val);
  }

  double darccos(double x) {
    double val = acos(x);
    return radiansToDegrees(val);
  }

  double darctan(double x) {
    double val = atan(x);
    return radiansToDegrees(val);
  }

  // (double)y (double) x
  double darctan2AndX(double y, double x) {
    double val = atan2(y, x);
    return radiansToDegrees(val);
  }

  double darccot(double x) {
    double val = atan2(1.0, x);
    return radiansToDegrees(val);
  }

  /*


// degree arctan


// degree arctan2


// degree arccot


   */
  static const double M_PI = 3.1415926535897932;

// compute declination angle of sun and equation of time
  List<double> sunPosition(double jd) {
    double D = jd - 2451545;

    double g = fixangle(357.529 + 0.98560028 * D);
    double q = fixangle(280.459 + 0.98564736 * D);
    double L = fixangle(q + (1.915 * dsin(g))) + (0.020 * dsin((2 * g)));

    //double R = 1.00014 - 0.01671 * [self dcos:g] - 0.00014 * [self dcos: (2*g)];
    double e = 23.439 - (0.00000036 * D);

    double d = darcsin((dsin(e) * dsin(L)));

    double RA = darctan2AndX((dcos(e) * dsin(L)), dcos(L)) / 15.0;

    RA = fixhour(RA);

    double EqT = q / 15.0 - RA;

    List<double> sPosition = [];

    sPosition.add(d);
    sPosition.add(EqT);

    return sPosition;
  }

  // compute equation of time
  double equationOfTime(double jd) {
    double eq = sunPosition(jd)[1];
    return eq;
  }

  // compute declination angle of sun
  double sunDeclination(double jd) {
    double d = sunPosition(jd)[0];
    return d;
  }

  // compute mid-day (Dhuhr, Zawal) time
  double computeMidDay(double t) {
    double T = equationOfTime(JDate + t);
    double Z = fixhour(12 - T);
    return Z;
  }

  double fixhour(double a) {
    a = a - 24.0 * (a / 24.0).floorToDouble();
    a = a < 0 ? (a + 24) : a;
    return a;
  }

  //: (double)G : (double)t
  double computeTimeAndTime(double G, double t) {
    double D = sunDeclination(JDate + t);
    double Z = computeMidDay(t);

    double V = (darccos(-dsin(G) - (dsin(D) * dsin(latitude))) /
        (dcos(D) * dcos(latitude))) /
        15.0;

    return Z + (G > 90 ? -V : V);
  }

  //: (double)step :(double)t
  double computeAsrAndTime(double step, double t) {
    double D = sunDeclination(JDate + t);
    double G = -darccot(step + dtan((latitude - D).abs()));
    return computeTimeAndTime(G, t);
  }

//:(double)time1 :(double) time2
  double timeDiffAndTime2(double time1, double time2) {
    return fixhour(time2 - time1);
  }

  //:(int)year :(int)month :(int)day :(double)latitude  :(double)longitude :(double)tZone
  List<double>
  getDatePrayerTimesAndMonthAndDayAndLatitudeAndLongitudeAndtimeZone(int year,
      int month,
      int day,
      double latitude,
      double longitude,
      double tZone) {
    this.latitude = latitude;
    this.longitude = longitude;

    calcYear = year;
    calcMonth = month;
    calcDay = day;

    //timeZone = this.effectiveTimeZone(year, month, day, timeZone);
    //timeZone = [self getTimeZone];
    timeZone = tZone;

    JDate = julianDateAndMonthAndDay(year, month, day);

    double lonDiff = longitude / (15.0 * 24.0);
    JDate = JDate - lonDiff;

    return computeDayTimes();
  }

  List<double> getPrayerTimesAndLatitudeAndLongitudeAndtimeZone(DateTime date,
      double latitude, double longitude, double tZone) {
    int year = date.year;
    int month = date.month;
    int day = date.day;

    return getDatePrayerTimesAndMonthAndDayAndLatitudeAndLongitudeAndtimeZone(
        year, month, day, latitude, longitude, tZone);
  }

// compute prayer times at given julian date
  List<double> computeDayTimes() {
    List<double> defaultTimes;
    defaultTimes = [5.0, 6.0, 12.0, 13.0, 18.0, 18.0, 18.0];
    //int i = 0;
    List<double> t1 = [],
        t2 = [],
        t3 = [];
    //default times
    List<double> times = List.from(defaultTimes);

    for (int i = 1; i <= numIterations; i++) {
      t1 = computeTimes(times);
    }

    t2 = adjustTimes(t1);
    t2 = tuneTimes(t2);
    ;

    prayerTimesCurrent = List.from(t2);

    t3 = adjustTimes(t2);

    return t3;
  }

  List<double> tuneTimes(List<double> times) {
    double off = 0.0,
        time = 0.0;

    for (int i = 0; i < times.length; i++) {
      off = (offsets)[i] / 60.0;
      time = times[i] + off;
      times[i] = time;
    }
    return times;
  }

  List<double> dayPortion(List<double> times) {
    int i = 0;
    double time = 0;
    for (i = 0; i < 7; i++) {
      time = times[i].toDouble();
      time = time / 24.0;

      times[i] = time;
    }
    return times;
  }

  List<double> computeTimes(List<double> times) {
    List<dynamic> t = dayPortion(times);
    calcMethod;

    List<double> obj = methodParams[calcMethod]!;

    double idk = obj[0];

    double Fajr = computeTimeAndTime(180 - idk, t[0]);
    double Sunrise = computeTimeAndTime(180 - 0.833, t[1]);
    double Dhuhr = computeMidDay(t[2]);

    double Asr = computeAsrAndTime(1.0 + asrJuristic.index, t[3]);
    double Sunset = computeTimeAndTime(0.833, t[4]);
    double Maghrib = computeTimeAndTime(methodParams[calcMethod]![2], t[5]);
    double Isha = computeTimeAndTime(methodParams[calcMethod]![4], t[6]);

    List<double> Ctimes = [Fajr,Sunrise, Dhuhr, Asr, Sunset, Maghrib, Isha];

    //Tune times here
    //Ctimes = [self tuneTimes:Ctimes];

    return Ctimes;
  }

  double nightPortion(double angle) {
    double calc = 0;
    if (adjustHighLats == PTKHigherLatitudes.PTKHigherLatitudesAngleBased) {
      calc = angle / 60.0;
    } else if (adjustHighLats ==
        PTKHigherLatitudes.PTKHigherLatitudesMidNight) {
      calc = 0.5;
    } else if (adjustHighLats ==
        PTKHigherLatitudes.PTKHigherLatitudesOneSeventh) {
      calc = 0.14286;
    }
    return calc;
  }

  // adjust times in a prayer time array
  List<double> adjustTimes(List<double> times) {
    int i = 0;
    List<double> a; //test variable
    double time = 0.0,
        Dtime = 0.0,
        Dtime1 = 0.0,
        Dtime2 = 0.0;

    for (i = 0; i < 7; i++) {
      time = times[i] + timeZone - longitude / 15.0;
      times[i] = time;
    }
    Dtime = times[2] + (dhuhrMinutes / 60.0); //Dhuhr
    times[2] = Dtime;

    a = methodParams[calcMethod]!;

    double val = a[1];

    if (val == 1) {
      // Maghrib
      Dtime1 = times[4] + (methodParams[calcMethod]![2] / 60.0);
      times[5] = Dtime1;
    }

    if (methodParams[calcMethod]![3] == 1) {
      Dtime2 = times[5] + methodParams[calcMethod]![4] / 60.0;
      times[6] = Dtime2;
    }

    if (adjustHighLats != PTKHigherLatitudes.PTKHigherLatitudesNone) {
      times = adjustHighLatTimes(times);
    }

    return times;
  }

  List<double> adjustHighLatTimes(List<double> times) {
    double time0 = times[0];
    double time1 = times[1];
    //double time2 = [[times objectAtIndex:2] doubleValue];
    //double time3 = [[times objectAtIndex:3] doubleValue];
    double time4 = times[4];
    double time5 = times[5];
    double time6 = times[6];

    double nightTime = timeDiffAndTime2(time4, time1); // sunset to sunrise

    // Adjust Fajr
    double obj0 = methodParams[calcMethod]![0];
    double obj1 = methodParams[calcMethod]![1];
    double obj2 = methodParams[calcMethod]![2];
    double obj3 = methodParams[calcMethod]![3];
    double obj4 = methodParams[calcMethod]![4];

    double FajrDiff = nightPortion(obj0) * nightTime;

    ;

    if (time0.isNaN || (timeDiffAndTime2(time0, time1) > FajrDiff)) {
      times[0] = time1 - FajrDiff;
    }

    double IshaAngle = (obj3 == 0) ? obj4 : 18;

    double IshaDiff = nightPortion(IshaAngle) * nightTime;

    if (time6.isNaN || timeDiffAndTime2(time4, time6) > IshaDiff) {
      times[6] = time4 + IshaDiff;
    }

    double MaghribAngle = (obj1 == 0) ? obj2 : 4;
    double MaghribDiff = nightPortion(MaghribAngle) * nightTime;

    if (time5.isNaN || timeDiffAndTime2(time4, time5) > MaghribDiff) {
      times[5] = time4 + MaghribDiff;
    }

    return times;
  }

  //(NSArray*)params
  void setCustomParams(List<double> params) {
    int i;
    double j = 0.0;

    List<double> cust =
    methodParams[PTKCalculationMethod.PTKCalculationMethodCustom.index]!;

    List<double> cal = methodParams[calcMethod]!;

    for (i = 0; i < 5; i++) {
      j = params[i];

      if (j == -1.0) {
        cust[i] = cal[i];
      } else {
        cust[i] = j;
      }

      methodParams[PTKCalculationMethod.PTKCalculationMethodCustom] =
          List.from(cust);

      calcMethod = PTKCalculationMethod.PTKCalculationMethodCustom;
    }
  }

  //:(double)time  :(BOOL)noSuffix
  String floatToTime12AndnoSuffix(double time, bool noSuffix) {
    if (time.isNaN) {
      return PTKInvalidTimeString;
    }

    time = fixhour((time + 0.5 / 60)); // add 0.5 minutes to round

    double hours = time.floorToDouble();
    double minutes = ((time - hours) * 60).floorToDouble();

    String suffix = '',
        result = '';

    if (hours >= 12) {
      suffix = "pm";
    } else {
      suffix = "am";
    }
    hours = (hours + 12) - 1;
    int hrs = hours.floor() % 12;

    hrs += 1;

    if (noSuffix == false) {
      if ((hrs >= 0 && hrs <= 9) && (minutes >= 0 && minutes <= 9)) {
        result = "0$hrs:0$minutes.0 $suffix";
      } else if ((hrs >= 0 && hrs <= 9)) {
        result = "0$hrs:$minutes.0 $suffix";
      } else if ((minutes >= 0 && minutes <= 9)) {
        result = "$hrs:$minutes.0 $suffix";
        ;
      } else {
        result = "$hrs:$minutes.0 $suffix";
      }
    } else {
      if ((hrs >= 0 && hrs <= 9) && (minutes >= 0 && minutes <= 9)) {
        result = "$hrs:$minutes";
        ;
      } else if ((hrs >= 0 && hrs <= 9)) {
        result = "$hrs:$minutes";
      } else if ((minutes >= 0 && minutes <= 9)) {
        result = "$hrs:$minutes";
      } else {
        result = "$hrs:$minutes";
      }
    }
    return result;
  }


  List<String> adjustTimesFormat(List<String> times) {
    int i = 0;

    if (timeFormat == PTKTimeFormat.PTKTimeFormatFloat) {
      return times;
    }
    for (i = 0; i < 7; i++) {
      if (timeFormat == PTKTimeFormat.PTKTimeFormatTime12WithSuffix) {
        times[i] = floatToTime12AndnoSuffix(double.parse(times[i]), false);
      }
      else if (timeFormat == PTKTimeFormat.PTKTimeFormatTime12NoSuffix) {
        times[i] = floatToTime12AndnoSuffix(double.parse(times[i]), false);
      }
      else if (timeFormat == PTKTimeFormat.PTKTimeFormatTime24) {
        times[i] = floatToTime24((double.parse(times[i])));
      } else {

        print('object');
        times[i] = floatToTime24((double.parse(times[i])));


      }
    }
    return times;
  }

  DateTime floatToNSDate(double time) {
    if (time.isNaN) {
      return DateTime.now();
    }
    time = fixhour(time + 0.5 / 60.0);
    int hours = time.floor();
    int minutes = ((time - hours) * 60.0).floor();


    return DateTime(calcYear, calcMonth, calcDay, hours, minutes);;
  }


// convert double hours to 24h format
String floatToTime24(double time) {
  String result = '';

  if (time.isNaN) {
    return 'PTKInvalidTimeString';
  }



  time = fixhour(time + 0.5 / 60.0);

  int hours = time.floor();
  double minutes = ((time - hours) * 60.0).floorToDouble();

  if ((hours >= 0 && hours <= 9) && (minutes >= 0 && minutes <= 9)) {
    result = "0$hours:0$minutes";
  }
  else if ((hours >= 0 && hours <= 9)) {
    result = "0$hours:0$minutes";
  }
  else if ((minutes >= 0 && minutes <= 9)) {
    result = "0$hours:0$minutes";
  }
  else {
    result = "0$hours:0$minutes";
  }
  return result;
}

}
