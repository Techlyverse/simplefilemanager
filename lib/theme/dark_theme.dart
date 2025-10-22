import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../globals.dart';
import 'package:flutter/services.dart';

final ColorScheme _darkColorScheme = ColorScheme.fromSwatch(
  primarySwatch: Colors.blue,
  brightness: Brightness.dark,
);

final ThemeData darkTheme = ThemeData(
  colorScheme: _darkColorScheme,
  textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    //scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
    ),
  ),
);
