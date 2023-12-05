import 'package:filemanager/homepage.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isAndroid13 = false;

  Future<void> checkPermissions() async {
    final DeviceInfoPlugin info = DeviceInfoPlugin();
    final AndroidDeviceInfo androidInfo = await info.androidInfo;
    final int androidVersion = int.parse(androidInfo.version.release);

    setState(() {
      isAndroid13 = androidVersion >= 13;
    });

    if (isAndroid13) {
      final videoStatus = await Permission.videos.status;
      final audioStatus = await Permission.audio.status;
      final photosStatus = await Permission.photos.status;

      final listStatus = [videoStatus, audioStatus, photosStatus];

      bool havePermission =
          listStatus.every((status) => status == PermissionStatus.granted);
      if (havePermission) navigateToHome();
    } else {
      bool havePermission = await Permission.storage.status.isGranted;
      if (havePermission) navigateToHome();
    }
  }

  Future<void> requestReadPermission() async {
    bool openSettings = false;

    if (openSettings == false) {
      if (isAndroid13) {
        final request = await [
          Permission.videos,
          Permission.photos,
          Permission.audio,
        ].request();

        bool havePermission = request.values
            .every((status) => status == PermissionStatus.granted);
        if (havePermission) {
          navigateToHome();
        } else {
          setState(() {
            openSettings = true;
          });
        }
      } else {
        final status = await Permission.storage.request();
        if (status.isGranted) {
          navigateToHome();
        } else {
          setState(() {
            openSettings = true;
          });
        }
      }
    } else {
      await openAppSettings();
    }
  }

  void navigateToHome() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false);
  }

  @override
  void initState() {
    super.initState();
    checkPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
                  requestReadPermission();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[700]),
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
      ),
    );
  }
}
