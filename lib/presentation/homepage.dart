import 'dart:io';

import 'package:filemanager/data/extensions/context_extension.dart';
import 'package:filemanager/globals.dart';
import 'package:flutter/material.dart';
import '../data/enums.dart';
import '../helper/app_controller.dart';
import 'components/quick_access/quick_access.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static final AppController controller = AppController();

  @override
  Widget build(BuildContext context) {
    final layoutType = context.layoutType;
    return Align(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (layoutType == LayoutType.mobile)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 16,
                ),
                child: Text(
                  "Quick Access",
                  style: TextStyle(
                    fontSize: 16,
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (layoutType == LayoutType.mobile) const QuickAccess(),
            if (layoutType == LayoutType.mobile) const SizedBox(height: 30),
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
            ValueListenableBuilder<bool>(
              valueListenable: controller.viewType,
              builder: (_, showGrid, __) {
                return SingleChildScrollView(
                    child: showGrid ? _gridView(context) : _listView(context));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _listView(BuildContext context) {
    final AppController controller = AppController();
    List<Directory> directories = controller.rootDirs;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: directories.length,
      itemBuilder: (_, index) {
        //final bool sdCard = directories[index].path.split('/').last != '0';
        final bool sdCard = Platform.isAndroid
            ? directories[index].path.split('/').last != '0'
            : false;
        final String dirName;
        if (isAndroid) {
          dirName = sdCard ? 'SD Card' : 'Internal Storage';
        } else if (isLinux) {
          dirName = directories[index].path.split('/').last.isNotEmpty
              ? directories[index].path.split('/').last
              : directories[index].path;
        } else {
          dirName = directories[index].path;
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: OutlinedButton(
            onPressed: () {
              controller.openDirectory(directories[index]);
            },
            style: OutlinedButton.styleFrom(
              elevation: 0,
              padding: const EdgeInsets.all(16),
              primary: context.colorScheme.onSurface,
              backgroundColor: context.isDarkMode
                  ? Colors.grey.shade800
                  : Colors.blue.shade50,
              side: BorderSide(color: context.colorScheme.background),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  isAndroid
                      ? sdCard
                          ? "assets/sd_card.png"
                          : "assets/mobile.png"
                      : "assets/folder.png",
                  width: 38,
                ),
                // Icon(
                //   sdCard
                //       ? Icons.sd_card_outlined
                //       : Icons.phone_android_outlined,
                //   size: 40,
                //   color: sdCard
                //       ? context.colorScheme.primary
                //       : context.colorScheme.tertiary,
                // ),
                const SizedBox(width: 20),
                Text(
                  //sdCard ? 'SD Card' : 'Internal Storage',
                  dirName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _gridView(BuildContext context) {
    final AppController controller = AppController();
    List<Directory> directories = controller.rootDirs;
    final count = context.widthOfScreen ~/ 180;
    return Padding(
      padding: const EdgeInsets.all(16),
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
            //final bool sdCard = directories[index].path.split('/').last != '0';
            final bool sdCard = Platform.isAndroid
                ? directories[index].path.split('/').last != '0'
                : false;
            final String dirName;
            if (isAndroid) {
              dirName = sdCard ? 'SD Card' : 'Internal Storage';
            } else if (isLinux) {
              dirName = directories[index].path.split('/').last.isNotEmpty
                  ? directories[index].path.split('/').last
                  : directories[index].path;
            } else {
              dirName = directories[index].path;
            }
            return OutlinedButton(
              onPressed: () {
                controller.openDirectory(directories[index]);
              },
              style: OutlinedButton.styleFrom(
                elevation: 0,
                padding: const EdgeInsets.all(12),
                primary: context.colorScheme.onSurface,
                backgroundColor: context.isDarkMode
                    ? Colors.grey.shade800
                    : Colors.blue.shade50,
                side: BorderSide(color: context.colorScheme.background),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Image.asset(
                        //sdCard ? "assets/sd_card.png" : "assets/mobile.png",
                        isAndroid
                            ? sdCard
                                ? "assets/sd_card.png"
                                : "assets/mobile.png"
                            : "assets/folder.png",
                        width: 80,
                        fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    //sdCard ? 'SD Card' : 'Internal Storage',
                    dirName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text("No directory found"));
          }
        },
      ),
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
