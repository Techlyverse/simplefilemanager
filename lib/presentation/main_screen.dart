import 'dart:io';

import 'package:filemanager/data/view_type.dart';
import 'package:filemanager/helper/app_controller.dart';
import 'package:filemanager/helper/context_extension.dart';
import 'package:filemanager/presentation/components/breadcrumb/bread_crumb_bar.dart';
import 'package:flutter/material.dart';

import 'components/directory/directory_page.dart';
import 'components/quick_access/quick_access.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});
  static final controller = AppController();

  @override
  Widget build(BuildContext context) {
    final ViewType viewType = context.viewType;

    return Scaffold(
      appBar: toolBar(viewType),
      body: Row(
        children: [
          if (viewType != ViewType.mobile) QuickAccess(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (viewType != ViewType.desktop) BreadCrumbBar(),
                if (viewType == ViewType.mobile) QuickAccess(),
                Expanded(child: const DirectoryPage()),
              ],
            ),
          )
        ],
      ),
    );
  }

  AppBar toolBar(ViewType viewType) {
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
                if (viewType == ViewType.desktop) BreadCrumbBar(),
              ],
            )
          : SizedBox(),
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
}
