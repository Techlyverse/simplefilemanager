import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final _darkScheme = ColorScheme.fromSeed(
  seedColor: Colors.deepPurple,
  brightness: Brightness.dark,
);

final ThemeData darkTheme = ThemeData(
  colorScheme: _darkScheme,
  textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
  //appBarTheme: AppBarTheme(backgroundColor: Colors.indigo.shade900),
  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom(iconSize: 16),
  ),
);
