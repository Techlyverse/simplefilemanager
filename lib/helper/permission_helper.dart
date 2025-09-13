import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../preferences/preferences.dart';
import 'app_controller.dart';

class PermissionHelper {
  final _deviceInfoPlugin = DeviceInfoPlugin();
  AppController controller = AppController();

  List<Permission> permissions = [];
  bool isPermissionGranted = false;

  //TODO: create a helper class for this
  Future<int> getAndroidSdkVersion() async {
    final int? version = Preferences.getAndroidVersion();
    if (version != null) return version;

    final androidInfo = await _deviceInfoPlugin.androidInfo;
    return androidInfo.version.sdkInt;
  }

  //TODO: create a helper class for this
  Future<void> getPermissionList() async {
    int androidSdk = await getAndroidSdkVersion();
    Preferences.setAndroidVersion(androidSdk);

    if (androidSdk >= 33) {
      permissions.addAll([
        Permission.photos,
        Permission.videos,
        Permission.audio,
      ]);
    } else if (androidSdk >= 29) {
      permissions.addAll([Permission.manageExternalStorage]);
    } else {
      permissions.addAll([Permission.storage]);
    }
  }

  Future<void> requestAndCheckPermissions() async {
    if (permissions.isNotEmpty) await permissions.request();
    List<bool> status = await Future.wait(permissions.map((e) => e.isGranted));
    isPermissionGranted = !status.contains(false);
  }

  Future<void> checkPermissions() async {
    await getPermissionList();
    List<bool> status = await Future.wait(permissions.map((e) => e.isGranted));
    isPermissionGranted = !status.contains(false);
  }

  Future<bool> requestStoragePermission() async {
    if (!Platform.isAndroid) return true;

    if (await Permission.manageExternalStorage.isGranted) {
      return true;
    }
    var permissionStatus = await Permission.manageExternalStorage.request();

    if (permissionStatus.isGranted) {
      return true;
    } else {
      await openAppSettings();
      return false;
    }
  }
}
