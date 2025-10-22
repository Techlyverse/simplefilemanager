import 'dart:io';

import 'package:filemanager/data/extensions/filesystementity_ext.dart';
import 'package:filemanager/helper/app_controller.dart';
import 'package:filemanager/data/extensions/context_extension.dart';
import 'package:filemanager/model/popup_menu_model.dart';
import 'package:flutter/material.dart';

import '../../data/enums.dart';
import 'breadcrumb/bread_crumb_bar.dart';
import 'package:path/path.dart' as p;

class ToolBar extends StatelessWidget implements PreferredSizeWidget {
  const ToolBar({Key? key, required this.currentEntity}) : super(key: key);
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
              ValueListenableBuilder<bool>(
                valueListenable: controller.viewType,
                builder: (_, showGrid, __) {
                  return IconButton(
                    onPressed: () {
                      controller.updateViewType();
                    },
                    icon: Icon(
                      showGrid ? Icons.format_list_bulleted : Icons.grid_view,
                    ),
                  );
                },
              ),
              // PopupMenuButton(
              //   color: context.colorScheme.background,
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(12),
              //   ),
              //   itemBuilder: (_) {
              //     return listPopupMenu.map((e) {
              //       return PopupMenuItem(
              //         value: e.label,
              //         child: GestureDetector(
              //           onTap: e.onTap,
              //           child: Row(
              //             children: [
              //               Icon(e.icon, size: 20),
              //               SizedBox(width: 12),
              //               Text(e.label),
              //             ],
              //           ),
              //         ),
              //       );
              //     }).toList();
              //   },
              // ),
              /*
              IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () async {
                          final currentDirPath =
                              controller.currentEntity.value?.path;
                          final folderNameFromUser =
                              await showTwoTextFieldsDialog(
                                context,
                                "Create Folder",
                                "Enter new folder name",
                                "Create",
                              );
                          if (folderNameFromUser != null &&
                              folderNameFromUser.isNotEmpty) {
                            await createNewFolderInCurrentDir(
                              context,
                              folderNameFromUser,
                              currentDirPath!,
                            );
                          }
                          // refresh ui
                          if (controller.currentEntity.value is Directory) {
                            final dir =
                                controller.currentEntity.value as Directory;
                            controller.currentEntity.value = Directory(
                              dir.path,
                            );
                          }
                        },
                      ),
               */
            ],
          );
        } else {
          return AppBar(
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                // clear selection
                controller.selectedEntities.clear();
                controller.updateUi.value = !controller.updateUi.value;
              },
            ),
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
                      IconButton(onPressed: () {}, icon: Icon(Icons.refresh)),
                      if (viewType == LayoutType.desktop)
                        BreadCrumbBar(currentEntity: currentEntity),
                    ],
                  )
                : Text(
                    '${controller.selectedEntities.length} selected',
                    style: TextStyle(fontSize: 16),
                  ),
            actions: [
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
                onPressed: () async {
                  if (controller.selectedEntities.length > 1) {
                    await showTimedDialog(
                      context,
                      "Please select only one item to use rename function.",
                    );
                    return;
                  }
                  final folderNamesFromUser =
                      controller.selectedEntities.first.name;
                  final newFolderName = await showTwoTextFieldsDialog(
                    context,
                    "Rename Folder",
                    "Enter new folder name",
                    "Rename",
                  );
                  if (folderNamesFromUser.isNotEmpty) {
                    final oldName = folderNamesFromUser;
                    final newName = newFolderName;
                    final currentDir =
                        controller.currentEntity.value as Directory;
                    final oldFolder = Directory(
                      p.join(currentDir.path, oldName),
                    );
                    if (await oldFolder.exists()) {
                      await renameCurrentFolder(context, newName!, oldFolder);
                    } else {
                      await showTimedDialog(
                        context,
                        "The folder you want to rename does not exist.",
                      );
                    }
                    // refresh ui
                    if (controller.currentEntity.value is Directory) {
                      final dir = controller.currentEntity.value as Directory;
                      controller.currentEntity.value = Directory(dir.path);
                    }
                    // clear selection
                    controller.selectedEntities.clear();
                  } else {
                    await showTimedDialog(
                      context,
                      "Either the folder you want to rename does not exist or you did not fill the data required, please retry.",
                    );
                  }
                },
                icon: Icon(Icons.drive_file_rename_outline),
              ),
              IconButton(
                onPressed: () async {
                  final currentDirPath = controller.currentEntity.value?.path;
                  bool? isUserSure;
                  if (controller.selectedEntities.length > 1) {
                    isUserSure = await showChoiceDialog(
                      context,
                      "Are you sure you want to delete the selected folders?",
                    );
                  } else {
                    isUserSure = await showChoiceDialog(
                      context,
                      "Are you sure you want to delete ${controller.selectedEntities.first.name} folder?",
                    );
                  }

                  final foldersToBeDeleted = List<FileSystemEntity>.from(
                    controller.selectedEntities,
                  );
                  for (final entity in foldersToBeDeleted) {
                    final folderToBeDeletedFromUser = entity.name;
                    if (folderToBeDeletedFromUser.isNotEmpty &&
                        isUserSure == true) {
                      await deleteFolder(
                        context,
                        folderToBeDeletedFromUser,
                        currentDirPath,
                      );
                    }
                    // refresh ui
                    if (controller.currentEntity.value is Directory) {
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
      },
    );
  }

  Future<void> deleteFolder(
    BuildContext context,
    String folderToBeDeletedName,
    pathOfCurDir,
  ) async {
    final folderToBeDeletedPath = p.join(pathOfCurDir, folderToBeDeletedName);
    final folderToBeDeleted = Directory(folderToBeDeletedPath);
    if (await folderToBeDeleted.exists()) {
      await folderToBeDeleted.delete(recursive: true);
      await showTimedDialog(context, "Successfully deleted.");
    } else {
      await showTimedDialog(context, "Folder with this name does not exist.");
    }
  }

  Future<void> createNewFolderInCurrentDir(
    BuildContext context,
    String folderName,
    pathOfCurDir,
  ) async {
    final newFolderPath = p.join(pathOfCurDir, folderName);
    final newFolder = Directory(newFolderPath);
    if (!(await newFolder.exists())) {
      await newFolder.create();
      await showTimedDialog(context, "New folder created.");
    } else {
      await showTimedDialog(context, "Folder with this name already exists.");
    }
  }

  Future<void> renameCurrentFolder(
    BuildContext context,
    String newFolderName,
    Directory folderWeWantToRename,
  ) async {
    final parentDir = folderWeWantToRename.parent;
    final newPath = p.join(parentDir.path, newFolderName);

    final renamedFolder = Directory(newPath);
    if (await renamedFolder.exists()) {
      await showTimedDialog(context, "Folder with this name already exists.");
    } else {
      await folderWeWantToRename.rename(newPath);
    }
  }

  Future<void> showTimedDialog(
    BuildContext context,
    content, {
    Duration duration = const Duration(seconds: 3),
  }) async {
    showDialog(
      context: context,
      //barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Text(
          content,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
    );
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
              child: Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  Future<String?> showTwoTextFieldsDialog(
    BuildContext context,
    headingTitle,
    hintTitle2,
    acceptButton,
  ) {
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
                    hintStyle: TextStyle(color: colorScheme.onSurface),
                  ),
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
                  await showTimedDialog(
                    context,
                    "Please retry and fill the folder name fields.",
                  );
                  Navigator.pop(context, null);
                }
              },
              child: Text(acceptButton),
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}

final List<PopupMenuModel> listPopupMenu = [
  PopupMenuModel(
    label: "Rename",
    icon: Icons.drive_file_rename_outline,
    onTap: () {},
  ),
  PopupMenuModel(label: "Info", icon: Icons.info_outline, onTap: () {}),
  PopupMenuModel(label: "Delete", icon: Icons.delete_outline, onTap: () {}),
  PopupMenuModel(label: "Cut", icon: Icons.cut, onTap: () {}),
  PopupMenuModel(label: "Copy", icon: Icons.copy, onTap: () {}),
  PopupMenuModel(label: "Paste", icon: Icons.paste, onTap: () {}),
  PopupMenuModel(
    label: "Settings",
    icon: Icons.settings_outlined,
    onTap: () {},
  ),
];
