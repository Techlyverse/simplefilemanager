import 'dart:io';

import 'package:filemanager/preferences/preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppController {
  AppController._();
  static final AppController _instance = AppController._();
  factory AppController() => _instance;

  static final _initialDirectory = Directory(r'/home/manu/Downloads');

  ValueNotifier<bool> showGrid = ValueNotifier(Preferences.getViewType());

  ValueNotifier<FileSystemEntity> fileSystemEntity = ValueNotifier(_initialDirectory);
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
