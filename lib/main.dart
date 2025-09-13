import 'package:filemanager/helper/app_controller.dart';
import 'dart:io';
import 'package:filemanager/features/main_screen.dart';
import 'package:filemanager/globals.dart';
import 'package:filemanager/helper/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'preferences/preferences.dart';
import 'presentation/main_screen.dart';
import 'theme/dark_theme.dart';
import 'theme/light_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.initPreferences();
  if(Platform.isAndroid){
    await _requestStoragePermission();
  }
  await AppController().init();
  checkPlatform();
  await AppController().init();
  runApp(const MyApp());
}

Future<void> _requestStoragePermission() async {
  if(await Permission.manageExternalStorage.isGranted || await Permission.storage.isGranted){
    return;
  }
  final status1 = await Permission.manageExternalStorage.request();
  final status2 = await Permission.storage.request();
  if (status2.isPermanentlyDenied || status1.isPermanentlyDenied){
    await openAppSettings();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}
