import 'dart:async';
import 'dart:io';
import 'package:filemanager/data/extensions/context_extension.dart';
import 'package:filemanager/helper/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import '../data/enums.dart';
import 'components/breadcrumb/bread_crumb_bar.dart';
import 'components/entity/entity_grid_tile.dart';
import 'components/entity/entity_list_tile.dart';

class DirectoryPage extends StatefulWidget {
  const DirectoryPage({super.key, required this.dir});
  final Directory dir;

  @override
  State<DirectoryPage> createState() => _DirectoryPageState();
}

class _DirectoryPageState extends State<DirectoryPage> {
  late Future<List<FileSystemEntity>> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadFiles();
  }

  @override
  void didUpdateWidget(covariant DirectoryPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload if the directory changes
    if (oldWidget.dir.path != widget.dir.path) {
      _future = _loadFiles();
    }
  }

  Future<List<FileSystemEntity>> _loadFiles() async {
    // listSync is actually faster inside an Isolate than awaiting a Stream
    final List<FileSystemEntity> items = await widget.dir.list().toList();

    // Sort: Directories first, then Files, then Case-insensitive Alphabetical
    items.sort((a, b) {
      if (a is Directory && b is File) return -1;
      if (a is File && b is Directory) return 1;
      return a.path.toLowerCase().compareTo(b.path.toLowerCase());
    });

    items.removeWhere((e) => e.uri.pathSegments.last.startsWith("."));
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (context.layoutType != LayoutType.desktop)
          BreadCrumbBar(uri: widget.dir.uri),
        Expanded(child: _entityViewer()),
      ],
    );
  }

  Widget _entityViewer() {
    return FutureBuilder(
      future: _future,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              height: 80,
              width: 80,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null &&
            snapshot.data!.isNotEmpty) {
          return ValueListenableBuilder<bool>(
            valueListenable: AppController().viewType,
            builder: (_, isGrid, _) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: isGrid
                    ? _buildGrid(snapshot.data!)
                    : _buildList(snapshot.data!),
              );
            },
          );
        } else {
          return SizedBox();
        }
      },
    );
  }

  Widget _buildGrid(List<FileSystemEntity> entities) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: context.layoutType == .mobile ? 100 : 150,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemCount: entities.length,
      itemBuilder: (context, index) => EntityGridTile(
        entity: entities[index],
        key: ValueKey(entities[index].path),
      ),
    );
  }

  Widget _buildList(List<FileSystemEntity> entities) {
    return ListView.builder(
      itemCount: entities.length,
      itemBuilder: (context, index) => EntityListTile(
        entity: entities[index],
        key: ValueKey(entities[index].path),
      ),
    );
  }

  // Widget _buildSpeedDial(BuildContext context) {
  //   return SpeedDial(
  //     overlayOpacity: 0.2,
  //     animatedIcon: AnimatedIcons.menu_close,
  //     children: [
  //       SpeedDialChild(
  //         child: Icon(Icons.insert_drive_file),
  //         label: 'Rename Folder',
  //         labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
  //         onTap: () async {
  //           if (controller.selectedEntities.length != 1) {
  //             await showTimedDialog(
  //               context,
  //               "Please select exactly one item to rename.",
  //             );
  //             return;
  //           }
  //           final entity = controller.selectedEntities.first;
  //           final folderNamesFromUser = await showTwoTextFieldsDialog(
  //             context,
  //             "Rename",
  //             "Current name",
  //             "New name",
  //             "Rename",
  //           );
  //
  //           // Pre-fill logic isn't easily possible with this dialog structure without modifying it,
  //           // but we can at least use the result.
  //           // Ideally we should show the current name in the dialog.
  //
  //           if (folderNamesFromUser != null &&
  //               folderNamesFromUser[1].isNotEmpty) {
  //             try {
  //               await controller.renameEntity(entity, folderNamesFromUser[1]);
  //               controller.selectedEntities.clear();
  //             } catch (e) {
  //               await showTimedDialog(context, e.toString());
  //             }
  //           }
  //         },
  //       ),
  //       SpeedDialChild(
  //         child: Icon(Icons.create_new_folder),
  //         label: 'Create Folder',
  //         labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
  //         onTap: () async {
  //           final folderNameFromUser = await showEditingFolderDialog(
  //             context,
  //             "Create Folder",
  //             "Enter new folder name",
  //             "Create",
  //           );
  //           if (folderNameFromUser != null && folderNameFromUser.isNotEmpty) {
  //             try {
  //               await controller.createFolder(folderNameFromUser);
  //             } catch (e) {
  //               await showTimedDialog(context, e.toString());
  //             }
  //           }
  //         },
  //       ),
  //       SpeedDialChild(
  //         child: Icon(Icons.delete),
  //         label: 'Delete',
  //         labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
  //         onTap: () async {
  //           if (controller.selectedEntities.isEmpty) {
  //             await showTimedDialog(context, "Please select items to delete.");
  //             return;
  //           }
  //           final isUserSure = await showChoiceDialog(
  //             context,
  //             "Are you sure you want to delete ${controller.selectedEntities.length} item(s)?",
  //           );
  //           if (isUserSure == true) {
  //             for (var entity in List.from(controller.selectedEntities)) {
  //               try {
  //                 await controller.deleteEntity(entity);
  //               } catch (e) {
  //                 await showTimedDialog(
  //                   context,
  //                   "Failed to delete ${entity.path}: $e",
  //                 );
  //               }
  //             }
  //             controller.selectedEntities.clear();
  //           }
  //         },
  //       ),
  //     ],
  //   );
  // }

  // function to show dialog prompt for editing buttons -MG
  Future<String?> showEditingFolderDialog(
    BuildContext context,
    headingTitle,
    hintTitle,
    acceptButton,
  ) async {
    String folderName = '';
    final colorScheme = Theme.of(context).colorScheme;
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            headingTitle,
            style: TextStyle(color: colorScheme.onSurface),
          ),
          content: TextField(
            style: TextStyle(color: colorScheme.onSurface),
            decoration: InputDecoration(
              hintText: hintTitle,
              hintStyle: TextStyle(color: colorScheme.onSurface),
            ),
            onChanged: (value) {
              folderName = value.trim();
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (folderName.isNotEmpty) {
                  Navigator.pop(context, folderName);
                }
              },
              child: Text(acceptButton),
            ),
          ],
        );
      },
    );
  }

  // function that shows the user a dialog for choice and returns a bool value -MG
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

  // function that shows a dialog box and takes two strings from user and returns a list of strings -MG
  Future<List<String>?> showTwoTextFieldsDialog(
    BuildContext context,
    headingTitle,
    hintTitle1,
    hintTitle2,
    acceptButton,
  ) {
    String oldFolderName = '';
    String newFolderName = '';
    final colorScheme = Theme.of(context).colorScheme;
    return showDialog<List<String>>(
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
                TextField(
                  style: TextStyle(color: colorScheme.onSurface),
                  decoration: InputDecoration(
                    hintText: hintTitle1,
                    hintStyle: TextStyle(color: colorScheme.onSurface),
                  ),
                  onChanged: (value) {
                    oldFolderName = value.trim();
                  },
                ),
                SizedBox(height: 1),
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
                if (oldFolderName.isNotEmpty && newFolderName.isNotEmpty) {
                  Navigator.pop(context, [oldFolderName, newFolderName]);
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

  Future<void> showTimedDialog(
    BuildContext context,
    content, {
    Duration duration = const Duration(seconds: 6),
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
}

// appBar: AppBar(
//   elevation: 0,
//   //backgroundColor: Colors.cyan.shade100,
//   leading: IconButton(
//     onPressed: () {
//       controller.navigateBack();
//     },
//     icon: Icon(Icons.arrow_back),
//   ),
//   title: ValueListenableBuilder<FileSystemEntity>(
//     valueListenable: controller.fileSystemEntity,
//     builder: (_, entity, __) {
//       return Text(
//         entity.name,
//         style: TextStyle(fontSize: size * 0.07),
//       );
//     },
//   ),
//   actions: [],
// ),

/*
floatingActionButton: SpeedDial(
          //overlayColor: Colors.transparent,
          overlayOpacity: 0.2,
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            SpeedDialChild(
              child: Icon(Icons.insert_drive_file),
              label: 'Rename Folder',
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onTap: () async {
                final folderNamesFromUser = await showTwoTextFieldsDialog(
                    context,
                    "Rename Folder",
                    "Enter the folder you want to rename",
                    "Enter new folder name",
                    "Rename");
                if (folderNamesFromUser![1].isNotEmpty) {
                  final oldName = folderNamesFromUser[0];
                  final newName = folderNamesFromUser[1];
                  final currentDir =
                      controller.fileSystemEntity.value as Directory;
                  final oldFolder = Directory(p.join(currentDir.path, oldName));
                  if (await oldFolder.exists()) {
                    await renameCurrentFolder(newName, oldFolder);
                  } else {
                    await showTimedDialog(context,
                        "The folder you want to rename does not exist.");
                  }
                  controller.fileSystemEntities.value =
                      (controller.fileSystemEntity.value as Directory)
                          .listSync();
                } else {
                  await showTimedDialog(context,
                      "Either the folder you want to rename does not exist or you did not fill the data required, please retry.");
                }
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.create_new_folder),
              label: 'Create Folder',
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onTap: () async {
                final currentDirPath = controller.fileSystemEntity.value.path;
                final folderNameFromUser = await showEditingFolderDialog(
                    context,
                    "Create Folder",
                    "Enter new folder name",
                    "Create");
                if (folderNameFromUser != null &&
                    folderNameFromUser.isNotEmpty) {
                  await createNewFolderInCurrentDir(
                      folderNameFromUser!, currentDirPath);
                  controller.fileSystemEntities.value =
                      (controller.fileSystemEntity.value as Directory)
                          .listSync();
                }
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.delete),
              label: 'Delete',
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onTap: () async {
                final currentDirPath = controller.fileSystemEntity.value.path;
                final folderToBeDeletedFromUser = await showEditingFolderDialog(
                    context,
                    "Delete Folder",
                    "Enter the name of folder to be deleted",
                    "Delete");
                final isUserSure = await showChoiceDialog(context,
                    "Are you sure you want to delete ${folderToBeDeletedFromUser} folder?");
                if (folderToBeDeletedFromUser != null &&
                    folderToBeDeletedFromUser.isNotEmpty &&
                    isUserSure == true) {
                  await deleteFolder(folderToBeDeletedFromUser, currentDirPath);
                  controller.fileSystemEntities.value =
                      (controller.fileSystemEntity.value as Directory)
                          .listSync();
                }
              },
            )
          ],
        ),
 */
