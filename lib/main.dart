import 'package:filemanager/custom.dart';
import 'package:filemanager/features/directory/directory_page.dart';
import 'package:filemanager/features/home/homepage.dart';
import 'package:flutter/material.dart';

import 'preferences/preferences.dart';
import 'theme/dark_theme.dart';
import 'theme/light_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.initPreferences();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const DirectoryPage(),
      //home: SomeWidget(),
    );
  }
}
