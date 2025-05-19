import 'package:device_info_plus/device_info_plus.dart';
import 'package:filemanager/preferences/preferences.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:file_manager/file_manager.dart';
import 'package:provider/provider.dart';
import 'home_grid.dart';
import 'home_list.dart';
import '../settings/settings_screen.dart';
import '../../provider/app_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _deviceInfoPlugin = DeviceInfoPlugin();
  FileManagerController fmc = FileManagerController();
  late int androidSdk;

  //TODO: create a helper class for this
  Future<int> getAndroidSdkVersion() async {
    final int? version = Preferences.getAndroidVersion();
    if (version != null) return version;

    final androidInfo = await _deviceInfoPlugin.androidInfo;
    return androidInfo.version.sdkInt;
  }

  //TODO: create a helper class for this
  Future<List<Permission>> getPermissionList() async {
    androidSdk = await getAndroidSdkVersion();
    Preferences.setAndroidVersion(androidSdk);

    List<Permission> permissions = [];

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
    return permissions;
  }

  Future<bool> checkAndRequestPermissions() async {
    final permissions = await getPermissionList();
    List<bool> status = await Future.wait(permissions.map((e) => e.isGranted));
    await permissions.request();
    return !status.contains(false);
  }

  Future<void> requestPermissions() async {
    final permissions = await getPermissionList();
    await permissions.request();
  }

  @override
  void initState() {
    super.initState();
    getAndroidSdkVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Files'), actions: [
        IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SettingsScreen()));
          },
          icon: Icon(Icons.more_vert),
        ),
      ]),
      body: FutureBuilder<bool>(
        future: checkAndRequestPermissions(),
        builder: (_, snapshot) {
          if (snapshot.data != null && snapshot.data == true) {
            return buildFileManagerHome();
          } else {
            return buildPermissionButton();
          }
        },
      ),
    );
  }

  Widget buildFileManagerHome() {
    return FileManager(
      controller: fmc,
      builder: (context, listFileSystemEntity) {
        return FutureBuilder<List<Directory>>(
            future: FileManager.getStorageList(),
            builder: (context, snapshot) {
              if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                return context.watch<AppProvider>().showGrid
                    ? HomeGrid(directories: snapshot.data)
                    : HomeList(directories: snapshot.data);
              }
              return SizedBox();
            });
      },
    );
  }

  Widget buildPermissionButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          const SizedBox(height: 80),
          const Text(
            "Read and write permission is required to show files",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 100),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SizedBox(
              height: 55,
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () {
                  checkAndRequestPermissions();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber.shade700,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  "Allow Files Permission",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
