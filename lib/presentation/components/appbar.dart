import 'dart:io';

import 'package:filemanager/data/extensions/filesystementity_ext.dart';
import 'package:filemanager/helper/app_controller.dart';
import 'package:filemanager/data/extensions/context_extension.dart';
import 'package:flutter/material.dart';

import '../../data/enums.dart';
import 'breadcrumb/bread_crumb_bar.dart';
import 'package:path/path.dart' as p;

class ToolBar extends StatelessWidget implements PreferredSizeWidget {
  const ToolBar({super.key, required this.currentEntity});
  final FileSystemEntity? currentEntity;

  static final controller = AppController();

  @override
  Widget build(BuildContext context) {
    final LayoutType viewType = context.layoutType;
    return ValueListenableBuilder(
        valueListenable: controller.updateUi,
        builder: (_, __, ___) {
          if (AppController().selectedEntities.isEmpty) {
            return AppBar(
              elevation: 0,
              leading: currentEntity == null
                  ? null
                  : IconButton(
                      onPressed: () {
                        controller.navigateBack();
                      },
                      icon: Icon(Icons.arrow_back),
                    ),
              title: Text(
                currentEntity?.path == "/storage/emulated/0"
                    ? "Home"
                    : currentEntity?.name ?? "File Manager",
              ),
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
                  : Row(
                      children: [
                        Text(
                          'Selected ${controller.selectedEntities.length} ${controller.selectedEntities.length == 1 ? "item" : "items"}'
                        )
                      ],
                    ),
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
                IconButton(
                  onPressed: () async{
                    final folderNamesFromUser = controller.selectedEntities.first.name;
                    final newFolderName = await showTwoTextFieldsDialog(
                    context,
                    "Rename Folder",
                    "Enter new folder name",
                    "Rename");
                    if (folderNamesFromUser.isNotEmpty) {
                      final oldName = folderNamesFromUser;
                      final newName = newFolderName;
                      final currentDir =
                      controller.currentEntity.value as Directory;
                      final oldFolder =
                      Directory(p.join(currentDir.path, oldName));
                      if (await oldFolder.exists()) {
                        await renameCurrentFolder(context, newName!, oldFolder);
                      } else {
                        await showTimedDialog(context,
                            "The folder you want to rename does not exist.");
                      }
                      // refresh ui
                      if(controller.currentEntity.value is Directory){
                        final dir = controller.currentEntity.value as Directory;
                        controller.currentEntity.value = Directory(dir.path);
                      }
                      // clear selection
                      controller.selectedEntities.clear();
                    } else {
                      await showTimedDialog(context,
                          "Either the folder you want to rename does not exist or you did not fill the data required, please retry.");
                    }
                  },
                  icon: Icon(Icons.drive_file_rename_outline),
                ),
                IconButton(
                  onPressed: () async{
                    final currentDirPath =
                        controller.currentEntity.value?.path;
                    final folderToBeDeletedFromUser = controller.selectedEntities.first.name;
                    final isUserSure = await showChoiceDialog(context,
                        "Are you sure you want to delete ${folderToBeDeletedFromUser} folder?");
                    if (folderToBeDeletedFromUser != null &&
                        folderToBeDeletedFromUser.isNotEmpty &&
                        isUserSure == true) {
                      await deleteFolder(
                          context,folderToBeDeletedFromUser, currentDirPath);

                    // refresh ui
                    if(controller.currentEntity.value is Directory){
                      final dir = controller.currentEntity.value as Directory;
                      controller.currentEntity.value = Directory(dir.path);
                    }
                    // clear selection
                      controller.selectedEntities.clear();
                    }

                  },
                  icon: Icon(Icons.delete_outline),
                ),
              ],
            );
          }
        });
  }



  Future<void> deleteFolder(BuildContext context, String folderToBeDeletedName, pathOfCurDir) async {
    final folderToBeDeletedPath = p.join(pathOfCurDir, folderToBeDeletedName);
    final folderToBeDeleted = Directory(folderToBeDeletedPath);
    if (await folderToBeDeleted.exists()) {
      await folderToBeDeleted.delete(recursive: true);
      await showTimedDialog(context, "Successfully deleted.");
    } else {
      await showTimedDialog(context, "Folder with this name does not exist.");
    }
  }

  Future<void> renameCurrentFolder(
      BuildContext context, String newFolderName, Directory folderWeWantToRename) async {
    final parentDir = folderWeWantToRename.parent;
    final newPath = p.join(parentDir.path, newFolderName);

    final renamedFolder = Directory(newPath);
    if (await renamedFolder.exists()) {
      await showTimedDialog(context, "Folder with this name already exists.");
    } else {
      await folderWeWantToRename.rename(newPath);
    }
  }

  Future<void> showTimedDialog(BuildContext context, content,
      {Duration duration = const Duration(seconds: 6)}) async {
    showDialog(
        context: context,
        //barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Text(content,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              )),
        ));
    await Future.delayed(duration);
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  Future<bool?> showChoiceDialog(BuildContext context, headingTitle) {
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              headingTitle,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text("No")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text("Yes"))
            ],
          );
        });
  }

  Future<String?> showTwoTextFieldsDialog(BuildContext context,
      headingTitle, hintTitle2, acceptButton) {
    //String oldFolderName = '';
    String newFolderName = '';
    final colorScheme = Theme.of(context).colorScheme;
    return showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              headingTitle,
              style: TextStyle(color: colorScheme.onSurface),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  // TextField(
                  //   style: TextStyle(color: colorScheme.onSurface),
                  //   decoration: InputDecoration(
                  //       hintText: hintTitle1,
                  //       hintStyle: TextStyle(color: colorScheme.onSurface)),
                  //   onChanged: (value) {
                  //     oldFolderName = value.trim();
                  //   },
                  // ),
                  // SizedBox(
                  //   height: 1,
                  // ),
                  TextField(
                    style: TextStyle(color: colorScheme.onSurface),
                    decoration: InputDecoration(
                        hintText: hintTitle2,
                        hintStyle: TextStyle(color: colorScheme.onSurface)),
                    onChanged: (value) {
                      newFolderName = value.trim();
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, null),
                child: Text('Cancel'),
              ),
              TextButton(
                  onPressed: () async {
                    if (newFolderName.isNotEmpty) {
                      Navigator.pop(context, newFolderName);
                    } else {
                      await showTimedDialog(context,
                          "Please retry and fill the folder name fields.");
                      Navigator.pop(context, null);
                    }
                  },
                  child: Text(acceptButton))
            ],
          );
        });
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
