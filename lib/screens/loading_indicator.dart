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

          const FaIcon(
            FontAwesomeIcons.locationArrow,
            size: 50,
          ),
          const SizedBox(
            height: 16,
          ),
          const CircularProgressIndicator(
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            'Loading Qibla Direction.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Container(),
          ),
          const Text(
            'If your location services are off then please turn it on so that we can get correct Qibla direction.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}
