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

  //background: rgba(246, 242, 212, 1);
  ///  static var backgroundPatternTopColor = const Color.fromRGBO(237, 243, 217, 1);//      237, 243, 217, 1.0);
  static var backgroundPatternTopColor = const Color.fromRGBO(246, 243, 212, 1);//      237, 243, 217, 1.0);
//backgroundPatternTopColor2
//  static var backgroundPatternTopColor = const Color.fromRGBO(243, 243, 230, 1);//      237, 243, 217, 1.0);
  static var borderGray = const Color.fromRGBO(108, 112, 112, 1);

  static var iconBlack = const Color.fromRGBO(48, 52, 55, 1);

  static var inkBlack = const Color.fromRGBO(9, 10, 10, 1);

  static var ickGray = const Color.fromRGBO(114, 119, 122, 1);




//background: rgba(237, 243, 217, 1);
}
