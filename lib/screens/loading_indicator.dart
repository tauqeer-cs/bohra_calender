import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(),
          ),

          FaIcon(
            FontAwesomeIcons.locationArrow,
            color: Colors.white,
            size: 50,
          ),
          SizedBox(
            height: 16,
          ),
          CircularProgressIndicator(
            color: Colors.white,
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            'Loading Qibla Direction.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Text(
            'If your location services are off then please turn it on so that we can get correct Qibla direction.',
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}
