import 'dart:async';
import 'dart:io';
import 'package:bohra_calender/screens/root.dart';
import 'package:bohra_calender/services/objectbox_service.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'core/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();

  runZoned(() async {
    await objectBoxService.initialize();
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Constants.backgroundPatternTopColor,
          fontFamily: 'PlayfairDisplay',
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: Color.fromRGBO(50, 149, 55, 1),
          ), // 1
          color: Color.fromRGBO(162, 200, 177, 1.0),
          titleTextStyle: TextStyle(
            color: Color.fromRGBO(50, 149, 55, 1),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),

          // background: rgba(50, 149, 55, 1);
        ),
      ),
      home: const RootScreen(),
    );
  }
}
