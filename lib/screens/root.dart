import 'package:bohra_calender/core/colors.dart';
import 'package:bohra_calender/screens/qibla.dart';
import 'package:bohra_calender/screens/qiblah_compass.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'dashboard.dart';
import 'home.dart';


class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedIndex = 0; //New

  static final List<Widget> _pages = <Widget>[
    const Dashboard(),
    const CalenderHomeScreen(),
    const Qibla(),
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: CColors.green_main,
        fixedColor: Colors.white,
        unselectedItemColor: Colors.grey.shade400,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Icon(Icons.home),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Icon(Icons.calendar_today),
            ),
            label: 'Calender',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Icon(FontAwesomeIcons.compass),
            ),
            label: 'Qibla',
          ),

          /* BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Icon(FontAwesomeIcons.compass),
            ),
            label: 'Qibla',
          ),*/





        ],
      ),
    );
  }
}
