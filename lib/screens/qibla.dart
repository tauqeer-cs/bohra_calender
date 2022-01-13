import 'package:bohra_calender/screens/qiblah_compass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';

import 'loading_indicator.dart';


class Qibla extends StatefulWidget {
  const Qibla({Key? key}) : super(key: key);

  @override
  State<Qibla> createState() => _QiblaState();
}

class _QiblaState extends State<Qibla> {

  final _deviceSupport = FlutterQiblah.androidDeviceSensorSupport();


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _deviceSupport,
      builder: (_, AsyncSnapshot<bool?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingIndicator();
        }
        if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error.toString()}"),
          );
        }

        if (snapshot.data!) {
          return QiblahCompass();
        } else {
          return Container(color: Colors.red,);
        }
      },
    );
  }
}




