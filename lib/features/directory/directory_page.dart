import 'dart:io';

import 'package:filemanager/helper/app_controller.dart';
import 'package:filemanager/helper/extension.dart';
import 'package:filemanager/widgets/entity_viewer.dart';
import 'package:flutter/material.dart';

class DirectoryPage extends StatefulWidget {
  const DirectoryPage({super.key, this.entity});
  final FileSystemEntity? entity;

  @override
  State<DirectoryPage> createState() => _DirectoryPageState();
}

class _DirectoryPageState extends State<DirectoryPage> {
  final AppController controller = AppController();

  @override
  void initState() {
    /// Open the given directory
    controller.loadInitialFiles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            controller.navigateBack();
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: ValueListenableBuilder<FileSystemEntity>(
          valueListenable: controller.fileSystemEntity,
          builder: (_, entity, __) {
            return Text(entity.name);
          },
        ),
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
      body: ValueListenableBuilder(
          valueListenable: controller.showGrid,
          builder: (_, showGrid, __) {
            return ValueListenableBuilder(
                valueListenable: controller.fileSystemEntities,
                builder: (_, entities, __) {
                  return EntityViewer(entities: entities, showGrid: showGrid);
                });
          }),
    );
  }
}
