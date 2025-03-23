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
  FileManagerController fmc = FileManagerController();
  final List<Permission> permissions = [
    Permission.storage,
    Permission.manageExternalStorage,
    Permission.mediaLibrary,
    Permission.audio,
  ];
  bool isAllowed = false;

  // bool readStorage = false;
  // bool manageStorage = false;
  // bool media = false;
  // bool audio = false;

  Future<void> checkAndRequestPermission() async {
    List<bool> statuses =
        await Future.wait(permissions.map((e) => e.isGranted));

    setState(() {
      isAllowed = !statuses.contains(false);
    });

    if (statuses.contains(false)) {
      await permissions.request();
      await FileManager.requestFilesAccessPermission();
    }

    statuses = await Future.wait(permissions.map((e) => e.isGranted));

    setState(() {
      isAllowed = !statuses.contains(false);
    });
  }

  Future<void> requestPermission() async {
    await permissions.request();
    await FileManager.requestFilesAccessPermission();

    final statuses = await Future.wait(permissions.map((e) => e.isGranted));

    setState(() {
      isAllowed = !statuses.contains(false);
    });
  }

  @override
  void initState() {
    super.initState();
    checkAndRequestPermission();
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
      body: isAllowed ? buildFileManagerHome() : buildPermissionButton(),
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
                requestPermission();
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
