import 'dart:io';

import 'package:filemanager/helper/app_controller.dart';
import 'package:filemanager/data/extensions/context_extension.dart';
import 'package:filemanager/presentation/components/appbar.dart';
import 'package:filemanager/presentation/homepage.dart';
import 'package:flutter/material.dart';

import '../data/enums.dart';
import 'components/quick_access/quick_access.dart';

import 'directory_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static final controller = AppController();

  @override
  Widget build(BuildContext context) {
    final LayoutType viewType = context.layoutType;

    return ValueListenableBuilder<FileSystemEntity?>(
      valueListenable: controller.currentEntity,
      builder: (_, entity, _) {
        return PopScope(
          canPop: entity == null,
          onPopInvokedWithResult: (didPop, result) async {
            if (entity != null) {
              await controller.navigateBack();
            }
          },
          child: Scaffold(
            appBar: ToolBar(entity: entity),
            body: Row(
              children: [
                // do not show sidebar on mobile view
                if (viewType != LayoutType.mobile) QuickAccess(),
                Expanded(
                  child: entity == null
                      ? HomePage()
                      : DirectoryPage(dir: entity as Directory),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
