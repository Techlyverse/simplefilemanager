import 'package:device_info_plus/device_info_plus.dart';
import 'package:filemanager/features/directory/directory_page.dart';
import 'package:filemanager/preferences/preferences.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../helper/app_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Files'),
          actions: [
            ValueListenableBuilder(
                valueListenable: controller.showGrid,
                builder: (_, showGrid, __) {
                  return IconButton(
                    onPressed: () {
                      controller.updateViewType();
                    },
                    icon: Icon(showGrid ? Icons.list : Icons.grid_view),
                  );
                }),
          ],
        ),
        body: DirectoryPage()

        // isPermissionGranted
        //     ? buildFileManagerHome()
        //     : buildPermissionButton(),
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
                  requestAndCheckPermissions();
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
