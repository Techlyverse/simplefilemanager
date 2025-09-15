import 'dart:io';

import 'package:filemanager/data/extensions/filesystementity_ext.dart';
import 'package:filemanager/helper/app_controller.dart';
import 'package:filemanager/data/extensions/context_extension.dart';
import 'package:flutter/material.dart';

import '../../data/enums.dart';
import 'breadcrumb/bread_crumb_bar.dart';

AppBar appBar(
  BuildContext context,
  FileSystemEntity? currentEntity,
  List<FileSystemEntity> selectedEntities,
) {
  final LayoutType viewType = context.layoutType;

  final controller = AppController();

  if (selectedEntities.isEmpty) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          controller.navigateBack();
        },
        icon: Icon(Icons.arrow_back),
      ),
      title: Text(currentEntity?.path == "/storage/emulated/0" ? "Home": currentEntity?.name ?? ""),
      actions: [
        ValueListenableBuilder(
            valueListenable: controller.viewType,
            builder: (_, showGrid, __) {
              return IconButton(
                onPressed: () {
                  controller.updateViewType();
                },
                icon: Icon(showGrid ? Icons.list : Icons.grid_view),
              );
            }),
      ],
    );
  } else {
    return AppBar(
      title: !Platform.isAndroid && !Platform.isIOS
          ? Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.arrow_back),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.arrow_forward),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.refresh),
                ),
                if (viewType == LayoutType.desktop)
                  BreadCrumbBar(currentEntity: currentEntity),
              ],
            )
          : SizedBox(),
      actions: [
        ValueListenableBuilder(
            valueListenable: controller.viewType,
            builder: (_, showGrid, __) {
              return IconButton(
                onPressed: () {
                  controller.updateViewType();
                },
                icon: Icon(showGrid ? Icons.list : Icons.grid_view),
              );
            }),
        // IconButton(
        //   onPressed: () {},
        //   icon: Icon(Icons.cut),
        // ),
        // IconButton(
        //   onPressed: () {},
        //   icon: Icon(Icons.copy),
        // ),
        // IconButton(
        //   onPressed: () {},
        //   icon: Icon(Icons.paste),
        // ),
        // IconButton(
        //   onPressed: () {},
        //   icon: Icon(Icons.drive_file_rename_outline),
        // ),
        // IconButton(
        //   onPressed: () {},
        //   icon: Icon(Icons.delete_outline),
        // ),
      ],
    );
  }
}
