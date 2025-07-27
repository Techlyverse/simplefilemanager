import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../globals.dart';

final ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.indigo,
    brightness: Brightness.dark,
  ),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).copyWith(
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
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.indigo.shade700
  )
);
