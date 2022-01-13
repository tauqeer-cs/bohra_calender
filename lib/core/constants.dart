import 'package:flutter/material.dart';

import 'colors.dart';

class Constants {
  Constants._();

  static const PAGE_MARGIN = 15.0;
  static const RECORDS_LIMIT = 15;
  static const SERVER_DATE_FORMATS = 'yyyy-MM-dd hh:mm:ss';


  static var backgroundPAttern = const BoxDecoration(
  color: CColors.green_main,
  image: DecorationImage(
  image: AssetImage('assets/images/pattern.png'),
  fit: BoxFit.cover,
  ));

  static var backgroundPatternTopColor = CColors.green_main.withOpacity(0.9);

}
