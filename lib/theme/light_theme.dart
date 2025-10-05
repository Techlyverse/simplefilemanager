import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

final ColorScheme _lightColorScheme =
    ColorScheme.fromSeed(seedColor: Colors.blue);

final ThemeData lightTheme = ThemeData(
  colorScheme: _lightColorScheme,
  scaffoldBackgroundColor: _lightColorScheme.surfaceContainer,
  textTheme: GoogleFonts.poppinsTextTheme(),
  appBarTheme: AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
    ),
  ),
);
