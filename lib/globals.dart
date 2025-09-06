import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

bool isAndroid = false;
bool isIOS = false;
bool isLinux = false;
bool isWindows = false;
bool isMacOS = false;
bool isWeb = false;

void checkPlatform() {
  if(kIsWeb){
    isWeb = true;
    isAndroid = false;
    isIOS = false;
    isLinux = false;
    isWindows = false;
    isMacOS = false;
  } else {
    isWeb = false;
    isAndroid = Platform.isAndroid;
    isIOS = Platform.isIOS;
    isLinux = Platform.isLinux;
    isWindows = Platform.isWindows;
    isMacOS = Platform.isMacOS;
  }
}