import 'dart:io';
import 'package:file_manager/file_manager.dart';
import 'package:filemanager/features/directory/file_list_view.dart';
import 'package:filemanager/features/settings/settings_screen.dart';
import 'package:filemanager/provider/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'file_grid_view.dart';

class DirectoryPage extends StatefulWidget {
  const DirectoryPage({super.key, required this.entity});
  final FileSystemEntity entity;

  @override
  State<DirectoryPage> createState() => _DirectoryPageState();
}

class _DirectoryPageState extends State<DirectoryPage> {
  final FileManagerController fmc = FileManagerController();

  @override
  void initState() {
    /// Open the given directory
    fmc.openDirectory(widget.entity);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    return Scaffold(
      appBar: AppBar(
        //elevation: 0,
        //backgroundColor: Colors.transparent,
        title: ValueListenableBuilder<String>(
          valueListenable: fmc.titleNotifier,
          builder: (_, text, __) {
            return Text(text == '0' ? 'Device' : text);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()));
            },
            icon: Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: ControlBackButton(
        controller: fmc,
        child: FileManager(
          controller: fmc,
          builder: (context, listFileSystemEntity) {
            return provider.showGrid
                ? FileGridView(entity: listFileSystemEntity, fmc: fmc)
                : FileListView(entity: listFileSystemEntity, fmc: fmc);
          },
        ),
      ),
    );
  }
}
