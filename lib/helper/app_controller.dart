import 'dart:io';
import 'package:filemanager/helper/directory_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:filemanager/preferences/preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

class AppController {
  AppController._();
  static final AppController _instance = AppController._();
  factory AppController() => _instance;

  late final List<Directory> rootDirs = [];
  static late Directory _tempDir;

  final ValueNotifier<bool> viewType = ValueNotifier(Preferences.getViewType());
  final ValueNotifier<FileSystemEntity?> currentEntity = ValueNotifier(null);
  ValueNotifier<List<FileSystemEntity>> selectedEntities = ValueNotifier([]);

  //final ValueNotifier<List<FileSystemEntity>> entities = ValueNotifier([]);
  //late final ValueNotifier<Directory> currentDir;

  // a list that contains all the directories that we went through for the current directory -MG
  List<String> pathList = [];

  /// Fetch root directories of current platform
  Future<void> init() async {
    if (rootDirs.isEmpty) {
      final dirs = await DirectoryHelper().getRootDirectories();
      rootDirs.addAll(dirs);
      _tempDir = await getApplicationDocumentsDirectory();
    }
  }

  // Future<void> loadInitialFiles() async {
  //   if (_currentDir != null) {
  //     entities.value = _currentDir!.listSync();
  //   } else {
  //     if (_rootDirs.isNotEmpty) {
  //       entities.value = _rootDirs;
  //     } else {
  //       entities.value = [_tempDir];
  //     }
  //   }
  // }

  void openDirectory(FileSystemEntity entity) async {
    currentEntity.value = entity;
    // adding the directory to the list
    if (entity is Directory) {
      pathList.add(p.basename(entity.path));
    }
    //entities.value = Directory(entity.path).listSync();
  }

  Future<void> navigateBack() async {
    //TODO: add conditions to make current entity null if can not go back
    if (currentEntity.value != null) {
      final bool isParentExists = await currentEntity.value!.parent.exists();
      if (isParentExists) {
        openDirectory(currentEntity.value!.parent);
      }
      currentEntity.value = null;
    }
  }

  void updateViewType() {
    viewType.value = !viewType.value;
    Preferences.setViewType(!viewType.value);
  }
}
