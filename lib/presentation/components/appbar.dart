import 'dart:io';

import 'package:filemanager/helper/app_controller.dart';
import 'package:filemanager/helper/context_extension.dart';
import 'package:filemanager/helper/extension.dart';
import 'package:flutter/material.dart';

import '../../data/enums.dart';
import 'breadcrumb/bread_crumb_bar.dart';

AppBar appBar(BuildContext context) {
  final LayoutType viewType = context.viewType;
  // TODO: your logic for selected items
  bool isSelected = true;

  final controller = AppController();

  if (!isSelected) {
    return AppBar(
      elevation: 0,
      //backgroundColor: Colors.cyan.shade100,
      leading: IconButton(
        onPressed: () {
          controller.navigateBack();
        },
        icon: Icon(Icons.arrow_back),
      ),
      // title: controller.currentEntity.value != null ? ValueListenableBuilder<FileSystemEntity>(
      //   valueListenable: controller.currentEntity,
      //   builder: (_, entity, __) => Text(entity.name),
      // ) : Text("Home"),
      actions: [],
    );
  }
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
              if (viewType == LayoutType.desktop) BreadCrumbBar(),
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
      IconButton(
        onPressed: () {},
        icon: Icon(Icons.cut),
      ),
      IconButton(
        onPressed: () {},
        icon: Icon(Icons.copy),
      ),
      IconButton(
        onPressed: () {},
        icon: Icon(Icons.paste),
      ),
      IconButton(
        onPressed: () {},
        icon: Icon(Icons.drive_file_rename_outline),
      ),
      IconButton(
        onPressed: () {},
        icon: Icon(Icons.delete_outline),
      ),
    ],
  );
}
