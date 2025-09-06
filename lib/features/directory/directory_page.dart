import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'package:filemanager/helper/app_controller.dart';
import 'package:filemanager/helper/context_extension.dart';
import 'package:filemanager/helper/extension.dart';
import 'package:filemanager/helper/he.dart';
import 'package:filemanager/widgets/currentDirPath.dart';
import 'package:filemanager/widgets/entity_viewer.dart';
import 'package:filemanager/widgets/quick_access.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:path/path.dart' as p;

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
              title: Row(
                children: [
                  ValueListenableBuilder<FileSystemEntity>(
                    valueListenable: controller.fileSystemEntity,
                    builder: (_, entity, __) {
                      //return Text(entity.name, style: TextStyle(fontSize: (size * 0.07).clamp(20, 24)),);
                      return Text(entity.name, style:  Theme.of(context).textTheme.titleMedium ) ;
                    },
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  if (!context.isMobile) const CurDirectoryPathBar(),
                ],
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
            body:
                   Row(
                     children: [
                       if (!context.isMobile) QuickAccess(),
                       Expanded(
                         child: Column(
                           children: [
                             if (context.isMobile) SizedBox(height: 50, child: CurDirectoryPathBar()),
                             if (context.isMobile) SizedBox(height: 80,child: QuickAccess()),
                             if (!context.isMobile) SizedBox(height: 10,),
                             Expanded(
                               child: ValueListenableBuilder(
                                  valueListenable: controller.fileSystemEntities,
                                  builder: (_, entities, __) {
                                    return EntityViewer(entities: entities);
                                  }),
                             ),
                           ],
                         ),
                       ),
                     ],
                   ),

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
                  label: 'Rename Folder',
                  labelStyle: TextStyle(
                    color:  Theme.of(context).colorScheme.onSurface,
                  ),
                  onTap: () async {
                    final folderNamesFromUser = await showTwoTextFieldsDialog(context, "Rename Folder", "Enter the folder you want to rename", "Enter new folder name", "Rename");
                    if ( folderNamesFromUser![1].isNotEmpty){
                      final oldName = folderNamesFromUser[0];
                      final newName = folderNamesFromUser[1];
                      final currentDir = controller.fileSystemEntity.value as Directory;
                      final oldFolder = Directory(p.join(currentDir.path, oldName));
                      if (await oldFolder.exists()){
                        await renameCurrentFolder(newName, oldFolder);
                      } else {
                        await showTimedDialog(context, "The folder you want to rename does not exist.");
                      }
                      controller.fileSystemEntities.value = (controller.fileSystemEntity.value as Directory).listSync();

                    } else {
                      await showTimedDialog(context, "Either the folder you want to rename does not exist or you did not fill the data required, please retry.");
                    }

                  },
                ),
                SpeedDialChild(
                  child: Icon(Icons.create_new_folder),
                  label: 'Create Folder',
                  labelStyle: TextStyle(
                    color:  Theme.of(context).colorScheme.onSurface,
                  ),
                  onTap: () async {
                    final currentDirPath = controller.fileSystemEntity.value.path;
                    final folderNameFromUser = await showEditingFolderDialog(context, "Create Folder", "Enter new folder name", "Create");
                    if(folderNameFromUser != null && folderNameFromUser.isNotEmpty){
                      await createNewFolderInCurrentDir(folderNameFromUser!, currentDirPath);
                      controller.fileSystemEntities.value = (controller.fileSystemEntity.value as Directory).listSync();
                    }
                  },
                ),
                SpeedDialChild(
                  child: Icon(Icons.delete),
                  label: 'Delete',
                  labelStyle: TextStyle(
                    color:  Theme.of(context).colorScheme.onSurface,
                  ),
                  onTap: () async {
                    final currentDirPath = controller.fileSystemEntity.value.path;
                    final folderToBeDeletedFromUser = await showEditingFolderDialog(context, "Delete Folder", "Enter the name of folder to be deleted", "Delete");
                    final isUserSure = await showChoiceDialog(context, "Are you sure you want to delete ${folderToBeDeletedFromUser} folder?");
                    if (folderToBeDeletedFromUser != null && folderToBeDeletedFromUser.isNotEmpty && isUserSure == true){
                      await deleteFolder(folderToBeDeletedFromUser, currentDirPath);
                      controller.fileSystemEntities.value = (controller.fileSystemEntity.value as Directory).listSync();
                    }
                  },
                )
              ],
            ),
          );
        }
    );
  }

  // function to show dialog prompt for editing buttons -MG
  Future<String?> showEditingFolderDialog(BuildContext context, headingTitle, hintTitle, acceptButton) async{
    String folderName = '';
    final colorScheme = Theme.of(context).colorScheme;
    return showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(headingTitle, style: TextStyle(color: colorScheme.onSurface),),
            content: TextField(
              style: TextStyle(color: colorScheme.onSurface),
              decoration: InputDecoration(hintText: hintTitle, hintStyle: TextStyle(color: colorScheme.onSurface) ),
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
                    if (folderName.isNotEmpty){
                      Navigator.pop(context, folderName);
                    }
                  },
                  child: Text(acceptButton)
              ),
            ],
          );
    }
    );
  }

  // function that shows the user a dialog for choice and returns a bool value -MG
  Future<bool?> showChoiceDialog(BuildContext context, headingTitle){
    return showDialog<bool>(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text(headingTitle, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.pop(context, false);
                },
                child: Text("No")
            ),
            TextButton(
                onPressed: (){
                  Navigator.pop(context, true);
                },
                child: Text("Yes")
            )
          ],
        );
      }
    );
  }

  // function that shows a dialog box and takes two strings from user and returns a list of strings -MG
  Future<List<String>?> showTwoTextFieldsDialog(BuildContext context, headingTitle, hintTitle1, hintTitle2, acceptButton){
    String oldFolderName = '';
    String newFolderName = '';
    final colorScheme = Theme.of(context).colorScheme;
    return showDialog<List<String>>(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text(headingTitle, style: TextStyle(color: colorScheme.onSurface),),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    style: TextStyle(color: colorScheme.onSurface),
                    decoration: InputDecoration(hintText: hintTitle1, hintStyle: TextStyle(color: colorScheme.onSurface)),
                    onChanged: (value) {
                      oldFolderName = value.trim();
                    },
                  ),
                  SizedBox(height: 1,),
                  TextField(
                    style: TextStyle(color: colorScheme.onSurface),
                    decoration: InputDecoration(hintText: hintTitle2, hintStyle: TextStyle(color: colorScheme.onSurface)),
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
                    if(oldFolderName.isNotEmpty && newFolderName.isNotEmpty){
                      Navigator.pop(context, [oldFolderName, newFolderName]);
                    }
                    else {
                      await showTimedDialog(context, "Please retry and fill the folder name fields.");
                      Navigator.pop(context, null);
                    }
                  },
                  child: Text(acceptButton)
              )
            ],

          );
        }
    );
  }


  Future<void> createNewFolderInCurrentDir(String folderName, pathOfCurDir) async {
    final newFolderPath = p.join(pathOfCurDir, folderName);
    final newFolder = Directory(newFolderPath);
    if ( !(await newFolder.exists())){
      await newFolder.create();
      await showTimedDialog(context, "New folder created.");
    } else {
      await showTimedDialog(context, "Folder with this name already exists.");
    }
  }

  Future<void> renameCurrentFolder(String newFolderName, Directory folderWeWantToRename) async {
    final parentDir = folderWeWantToRename.parent;
    final newPath = p.join(parentDir.path, newFolderName);

    final renamedFolder = Directory(newPath);
    if(await renamedFolder.exists()){
      await showTimedDialog(context, "Folder with this name already exists.");
    } else {
      await folderWeWantToRename.rename(newPath);
    }
  }

  Future<void> deleteFolder(String folderToBeDeletedName, pathOfCurDir) async {
    final folderToBeDeletedPath = p.join(pathOfCurDir, folderToBeDeletedName);
    final folderToBeDeleted = Directory(folderToBeDeletedPath);
    if(await folderToBeDeleted.exists()){
      await folderToBeDeleted.delete(recursive: true);
      await showTimedDialog(context, "Successfully deleted.");
    } else{
      await showTimedDialog(context, "Folder with this name does not exist.");
    }

  }

  Future<void> showTimedDialog(BuildContext context, content, {Duration duration = const Duration(seconds: 6)}) async {
    showDialog(
        context: context,
        //barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Text(content, style: TextStyle(color: Theme.of(context).colorScheme.onSurface,)),
        )
    );
    await Future.delayed(duration);
    if(Navigator.canPop(context)){
      Navigator.pop(context);
    }
  }


}
