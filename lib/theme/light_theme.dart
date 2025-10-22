import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

final ColorScheme _lightColorScheme =
    ColorScheme.fromSwatch(primarySwatch: Colors.blue);

final ThemeData lightTheme = ThemeData(
  colorScheme: _lightColorScheme,
  textTheme: GoogleFonts.poppinsTextTheme(),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.black,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
    ),
  ),
);
