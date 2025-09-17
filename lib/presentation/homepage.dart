import 'dart:io';

import 'package:filemanager/data/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import '../data/enums.dart';
import '../helper/app_controller.dart';
import 'components/quick_access/quick_access.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static final AppController controller = AppController();

  @override
  Widget build(BuildContext context) {
    final layoutType = context.layoutType;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
          child: Text(
            "Quick Access",
            style: TextStyle(
              fontSize: 16,
              color: context.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (layoutType == LayoutType.mobile) QuickAccess(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            "Storage",
            style: TextStyle(
              fontSize: 16,
              color: context.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: controller.viewType,
          builder: (_, showGrid, __) {
            return showGrid ? _gridView(context) : _listView(context);
          },
        ),
      ],
    );
  }

  // Widget buildFileManagerHome() {
  //   return FileManager(
  //     controller: fmc,
  //     builder: (context, listFileSystemEntity) {
  //       return FutureBuilder<List<Directory>>(
  //           future: FileManager.getStorageList(),
  //           builder: (context, snapshot) {
  //             if (snapshot.data != null && snapshot.data!.isNotEmpty) {
  //               return fmc.showGrid.value
  //                   ? HomeGrid(directories: snapshot.data)
  //                   : HomeList(directories: snapshot.data);
  //             }
  //             return SizedBox();
  //           });
  //     },
  //   );
  // }

  Widget _listView(BuildContext context) {
    final AppController controller = AppController();
    List<Directory> directories = controller.rootDirs;
    return ListView.builder(
        shrinkWrap: true,
        itemCount: directories.length,
        itemBuilder: (_, index) {
          final bool sdCard = directories[index].path.split('/').last != '0';
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ElevatedButton(
              onPressed: () {
                controller.openDirectory(directories[index]);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colorScheme.primaryContainer,
                foregroundColor: context.colorScheme.onPrimaryContainer,
                padding: EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    sdCard
                        ? Icons.sd_card_outlined
                        : Icons.phone_android_outlined,
                    size: 40,
                    color: sdCard ? Colors.amber[700] : Colors.blue[600],
                  ),
                  SizedBox(width: 20),
                  Text(
                    sdCard ? 'SD Card' : 'Internal Storage',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _gridView(BuildContext context) {
    final AppController controller = AppController();
    List<Directory> directories = controller.rootDirs;
    final count = (context.widthOfScreen / 180).toInt();
    return Padding(
      padding: EdgeInsets.all(16),
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            crossAxisCount: count,
          ),
          shrinkWrap: true,
          itemCount: directories.length,
          itemBuilder: (_, index) {
            if (directories.isNotEmpty) {
              final bool sdCard =
                  directories[index].path.split('/').last != '0';
              return ElevatedButton(
                onPressed: () {
                  controller.openDirectory(directories[index]);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colorScheme.primaryContainer,
                  foregroundColor: context.colorScheme.onPrimaryContainer,
                  padding: EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      sdCard ? Icons.sd_card_outlined : Icons.phone_android,
                      size: 80,
                      color: sdCard ? Colors.amber[700] : Colors.blue[600],
                    ),
                    SizedBox(height: 12),
                    Text(
                      sdCard ? 'SD Card' : 'Device',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: Text("No directory found"),
              );
            }
          }),
    );
  }
}

/*
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
    setState(() {});
  }

  Future<void> checkPermissions() async {
    await getPermissionList();
    List<bool> status = await Future.wait(permissions.map((e) => e.isGranted));
    isPermissionGranted = !status.contains(false);
  }

  @override
  void initState() {
    super.initState();
    // checkPermissions();
  }
 */
