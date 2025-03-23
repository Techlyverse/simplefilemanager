import 'dart:io';
import 'package:file_manager/file_manager.dart';
import 'package:filemanager/features/directory/dir_grid.dart';
import 'package:filemanager/features/directory/dir_list.dart';
import 'package:filemanager/features/settings/settings_screen.dart';
import 'package:filemanager/provider/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';
import '../../preferences/preferences.dart';
import '../../widgets/tile_grid.dart';
import '../../widgets/tile_list.dart';

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
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: ControlBackButton(
        controller: fmc,
        child: FileManager(
          controller: fmc,
          builder: (context, listFileSystemEntity) {
            return provider.showGrid
                ? DirGrid(entity: listFileSystemEntity, fmc: fmc)
                : DirList(entity: listFileSystemEntity, fmc: fmc);
          },
        ),
      ),
    );
  }
}
