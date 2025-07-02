import 'dart:io';

import 'package:filemanager/helper/app_controller.dart';
import 'package:filemanager/helper/extension.dart';
import 'package:filemanager/widgets/entity_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

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
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double size = constraints.biggest.shortestSide * 0.5;
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              //backgroundColor: Colors.cyan.shade100,
              leading: IconButton(
                onPressed: () {
                  controller.navigateBack();
                },
                icon: Icon(Icons.arrow_back),
              ),
              title: ValueListenableBuilder<FileSystemEntity>(
                valueListenable: controller.fileSystemEntity,
                builder: (_, entity, __) {
                  return Text(entity.name, style: TextStyle(fontSize: size * 0.07),);
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
            // adding the floatingActionButton -MG
            //floatingActionButton: FloatingActionButton(onPressed: () {}, child: Icon(Icons.unfold_more),),
            // trying the speed dial -MG
            floatingActionButton: SpeedDial(
              //overlayColor: Colors.transparent,
              overlayOpacity: 0.2,
              animatedIcon: AnimatedIcons.menu_close,
              children: [
                SpeedDialChild(
                  child: Icon(Icons.insert_drive_file),
                  label: 'Create File',
                  labelStyle: TextStyle(
                    color:  Theme.of(context).colorScheme.onSurface,
                  ),
                  onTap: (){},
                ),
                SpeedDialChild(
                  child: Icon(Icons.create_new_folder),
                  label: 'Create Folder',
                  labelStyle: TextStyle(
                    color:  Theme.of(context).colorScheme.onSurface,
                  ),
                  onTap: (){},
                ),
                SpeedDialChild(
                  child: Icon(Icons.delete),
                  label: 'Delete',
                  labelStyle: TextStyle(
                    color:  Theme.of(context).colorScheme.onSurface,
                  ),
                  onTap: (){},
                )
              ],
            ),
          );
        }
    );
  }
}
