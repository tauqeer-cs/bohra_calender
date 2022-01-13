import 'package:bohra_calender/core/colors.dart';
import 'package:bohra_calender/core/constants.dart';
import 'package:bohra_calender/services/data_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:weather_icons/weather_icons.dart';

import 'extra_name_listing.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool showingMore = false;

  String get todayIslamicDate {
    var _today = HijriCalendar.now();
    return _today.hDay.toString() + ' ' + _today.longMonthName + ' ' +  _today.hYear.toString();
  }

  String get todayNormalDate {

    return DateFormat('EEEE d MMM yyyy').format(DateTime.now());
  }

  @override
  void initState() {
    super.initState();
  }

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
                  height: 24,
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
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Zohar Time is at 3:30 PM',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(
                  height: 8,
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
                          const PrayerItem(
                            name: 'Fajr',
                            time: '4:44 AM',
                            icon: WeatherIcons.horizon_alt,
                          ),
                          const PrayerItem(
                            name: 'Sunrise',
                            time: '5:31 AM',
                            icon: WeatherIcons.sunrise,
                          ),
                          const PrayerItem(
                            name: 'Zawaal',
                            time: '11:46 AM',
                            icon: WeatherIcons.day_sunny,
                            isNotificationOn: false,
                          ),
                          const PrayerItem(
                            name: 'Zuhr End',
                            time: '1:51 PM',
                            icon: WeatherIcons.day_sunny_overcast,
                          ),
                          const PrayerItem(
                              name: 'Magrib',
                              time: '6:01 PM',
                              icon: WeatherIcons.sunset),
                          if (showingMore) ...[
                            const PrayerItem(
                                name: 'Magrib',
                                time: '6:01 PM',
                                icon: WeatherIcons.sunset),
                            const PrayerItem(
                                name: 'Magrib',
                                time: '6:01 PM',
                                icon: WeatherIcons.sunset),
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
                Container(
                  height: 10,
                ),
                Container(
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
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: CColors.green_main,
                              boxShadow: const [
                                BoxShadow(color: Colors.black, spreadRadius: 3),
                              ],
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                children: const [
                                  Icon(
                                    FontAwesomeIcons.calendar,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                    '5 Jumada Ula: Rozu: Sunnat\nRozu, first Thursday of month',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                                      builder: (context) => const ExtraNamazListing(),
                                    ),
                                  );

                                  ;

                                },
                                imageName: 'extra-namaz',
                              ),
                            ),
                            Expanded(
                                child: PrayerItems(
                              title: 'View Event',
                              onTap: () {},
                              imageName: 'events-list',
                            )),
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
                                title: '+ Personal Events',
                                onTap: () {},
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

  const PrayerItem({
    Key? key,
    required this.icon,
    required this.time,
    required this.name,
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
              if(isNotificationOn) ... [
                Icon(Icons.notifications_outlined , color: CColors.green_main,),
              ] else ... [
                Icon(Icons.notifications_off_outlined , color: CColors.green_main,),
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
