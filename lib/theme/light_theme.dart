import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
  textTheme: GoogleFonts.poppinsTextTheme(),
  appBarTheme: AppBarTheme(backgroundColor: Colors.indigo.shade100),
  scaffoldBackgroundColor: Colors.white,
);
