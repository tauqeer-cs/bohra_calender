import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

ThemeData getAppTheme() {
  const inputBorder = UnderlineInputBorder(
    borderSide: BorderSide(
      color: CColors.grey_f7,
    ),
  );
  return ThemeData(
    primaryColor: CColors.red_ff,
    accentColor: CColors.grey_f7,
    primarySwatch: Colors.red,
    primaryColorBrightness: Brightness.dark,
    accentColorBrightness: Brightness.dark,
    scaffoldBackgroundColor: CColors.grey_f5,

    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: CColors.grey_dd,
      titleSpacing: 0,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      textTheme: TextTheme(
        headline6: TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
        subtitle2: TextStyle(
          fontSize: 12,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(
        color: CColors.grey_f7,
      ),
      border: inputBorder,
      focusedBorder: inputBorder.copyWith(
        borderSide: BorderSide(
          color: CColors.red_ff,
        ),
      ),
      enabledBorder: inputBorder,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(1),
        minimumSize: MaterialStateProperty.all(Size.fromHeight(50)),
        backgroundColor: MaterialStateProperty.all(CColors.grey_ef),
        textStyle: MaterialStateProperty.all(
          TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
    dividerTheme: DividerThemeData(
      thickness: 1,
      space: 1,
    ),
    //CupertinoSegmentedControl
  );
}
