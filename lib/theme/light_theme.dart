import 'package:filemanager/globals.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
  textTheme: GoogleFonts.poppinsTextTheme().copyWith(
    bodyMedium: GoogleFonts.poppins(
      fontSize: isAndroid ? 14 : 18,
    ),
    bodyLarge: GoogleFonts.poppins(
      fontSize: isAndroid ? 16 : 20,
    ),
    titleMedium: GoogleFonts.poppins(
      fontSize: isAndroid ? 20 : 24,
    ),
    titleLarge: GoogleFonts.poppins(
      fontSize: isAndroid ? 22 : 26,
    ),
  ),
  appBarTheme: AppBarTheme(backgroundColor: Colors.indigo.shade100),
  scaffoldBackgroundColor: Colors.white,
  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom(iconSize: 18),
  ),
);
