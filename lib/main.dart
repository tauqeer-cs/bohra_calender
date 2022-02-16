import 'dart:async';
import 'dart:io';
import 'package:bohra_calender/screens/root.dart';
import 'package:bohra_calender/services/objectbox_service.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest.dart' as tz;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  tz.initializeTimeZones();




 // await Hive.openBox<PersonalEvent>('personal_event');



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
        appBarTheme: AppBarTheme(color: Colors.green.withOpacity(0.5)),
      ),
      home: const RootScreen(),
    );
  }
}
