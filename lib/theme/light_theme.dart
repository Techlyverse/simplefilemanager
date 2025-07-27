import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final _lightScheme = ColorScheme.fromSeed(seedColor: Colors.indigo);

final ThemeData lightTheme = ThemeData(
  colorScheme: _lightScheme,
  textTheme: GoogleFonts.poppinsTextTheme(),
  scaffoldBackgroundColor: Colors.white,
  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom(iconSize: 18),
  ),
);
