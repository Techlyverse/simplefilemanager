import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

Future<bool> requestStoragePermission() async {
  if(!Platform.isAndroid) return true;

  if(await Permission.manageExternalStorage.isGranted){
    return true;
  }
  var permissionStatus = await Permission.manageExternalStorage.request();

  if (permissionStatus.isGranted){
    return true;
  } else{
    await openAppSettings();
    return false;
  }
}