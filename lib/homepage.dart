import 'package:filemanager/preferences.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:file_manager/file_manager.dart';
import 'build_grid.dart';
import 'build_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FileManagerController fileManagerController = FileManagerController();
  late bool? isAndroid13;
  late bool? isReadAllowed;

  Future<void> checkStatus() async {
    if (isReadAllowed == true) {
    } else if (isReadAllowed == false) {
      if (isAndroid13 == null) checkAndroidVersion();
      await requestReadPermission();
    } else {
      if (isAndroid13 == null) checkAndroidVersion();
      checkPermissions();
      await requestReadPermission();
    }
  }

  Future<void> checkAndroidVersion() async {
    final DeviceInfoPlugin info = DeviceInfoPlugin();
    final AndroidDeviceInfo androidInfo = await info.androidInfo;
    final int androidVersion = int.parse(androidInfo.version.release);
    bool isTiramisu = androidVersion >= 13;
    if (mounted) {
      setState(() {
        isAndroid13 = isTiramisu;
      });
    }

    await Preferences.setAndroidVersion(isTiramisu);
  }

  Future<void> checkPermissions() async {
    if (isAndroid13 == true) {
      final videoStatus = await Permission.videos.status;
      final audioStatus = await Permission.audio.status;
      final photosStatus = await Permission.photos.status;

      final listStatus = [videoStatus, audioStatus, photosStatus];
      isReadAllowed =
          listStatus.every((status) => status == PermissionStatus.granted);
      if (mounted) setState(() {});
    } else {
      isReadAllowed = await Permission.storage.status.isGranted;
      if (mounted) setState(() {});
    }
    await Preferences.setReadPermission(isReadAllowed!);
  }

  Future<void> requestReadPermission() async {
    if (isAndroid13 == true) {
      final request = await [
        Permission.videos,
        Permission.photos,
        Permission.audio,
      ].request();

      isReadAllowed =
          request.values.every((status) => status == PermissionStatus.granted);
      if (isReadAllowed != true) {
        openAppSettings();
      }
      await Preferences.setReadPermission(isReadAllowed!);
    } else {
      final status = await Permission.storage.request();
      isReadAllowed = status.isGranted;
      if (isReadAllowed != true) {
        openAppSettings();
      }
      await Preferences.setReadPermission(isReadAllowed!);
    }
  }

  // Future<void> navigateToHome() async {
  //   await Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => const HomePage()),
  //   );
  // }

  @override
  void initState() {
    super.initState();
    isAndroid13 = Preferences.getAndroidVersion();
    isReadAllowed = Preferences.getReadPermission();
    setState(() {});
    checkStatus();
  }

  @override
  void dispose() {
    super.dispose();
    fileManagerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isReadAllowed == true
          ? AppBar(
              title: const Text('My Files'),
              actions: [
                IconButton(
                  onPressed: () {
                    if (mounted) {
                      setState(() {
                        Preferences.setViewType(!Preferences.getViewType());
                      });
                    }
                  },
                  icon: Icon(Preferences.getViewType()
                      ? Icons.grid_on_rounded
                      : Icons.list_alt),
                ),
              ],
            )
          : null,
      body: isReadAllowed == true
          ? buildFileManagerHome()
          : buildPermissionScreen(),
    );
  }

  Widget buildFileManagerHome() {
    return FileManager(
      controller: fileManagerController,
      builder: (context, listFileSystemEntity) {
        return FutureBuilder<List<Directory>>(
            future: FileManager.getStorageList(),
            builder: (context, snapshot) {
              return Preferences.getViewType()
                  ? BuildGrid(
                      snapshot: snapshot.data,
                      key: const Key("grid"),
                    )
                  : BuildList(
                      snapshot: snapshot.data,
                      key: const Key('list'),
                    );
            });
      },
    );
  }

  Widget buildPermissionScreen() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          const SizedBox(height: 80),
          const Text(
            "Read permission is required to show files",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 100),
          SizedBox(
            height: 55,
            width: 250,
            child: ElevatedButton(
              onPressed: () {
                checkStatus();
              },
              child: const Text(
                "Allow Read Files",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
