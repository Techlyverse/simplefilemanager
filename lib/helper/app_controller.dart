import 'dart:io';

import 'package:filemanager/preferences/preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

class AppController {
  AppController._();
  static final AppController _instance = AppController._();
  factory AppController() => _instance;

  static final _initialDirectory = Directory(r'C:/');
  // a list that contains all the directories that we went through for the current directory -MG
  List<String> pathList = [_initialDirectory.toString()];
  ValueNotifier<bool> showGrid = ValueNotifier(Preferences.getViewType());

  ValueNotifier<FileSystemEntity> fileSystemEntity =
      ValueNotifier(_initialDirectory);
  ValueNotifier<List<FileSystemEntity>> fileSystemEntities = ValueNotifier([]);

  Future<void> loadInitialFiles() async {
    try {
      fileSystemEntities.value = _initialDirectory.listSync();
    } catch (e) {
      fileSystemEntity.value = _initialDirectory;
    }
  }

  void openDirectory(FileSystemEntity entity) async {
    fileSystemEntity.value = entity;
    // adding the directory to the list
    if (entity is Directory) {
      pathList.add(p.basename(entity.path));
    }
    fileSystemEntities.value = Directory(entity.path).listSync();
  }

  Future<void> navigateBack() async {
    final bool isParentExists = await fileSystemEntity.value.parent.exists();
    if (isParentExists) {
      openDirectory(fileSystemEntity.value.parent);
    }
  }

  void updateViewType() {
    Preferences.setViewType(!showGrid.value);
    showGrid.value = !showGrid.value;
  }
}
