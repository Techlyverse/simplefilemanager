import 'dart:io';
import 'package:filemanager/helper/directory_helper.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:filemanager/preferences/preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppController {
  AppController._();
  static final AppController _instance = AppController._();
  factory AppController() => _instance;

  late final List<Directory> rootDirs = [];
  static late Directory _tempDir;

  final ValueNotifier<bool> viewType = ValueNotifier(Preferences.getViewType());
  final ValueNotifier<bool> updateUi = ValueNotifier(true);
  final ValueNotifier<FileSystemEntity?> currentEntity = ValueNotifier(null);
  final List<FileSystemEntity> selectedEntities = [];

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

  void openDirectory(FileSystemEntity entity) async {
    currentEntity.value = entity;
    // adding the directory path to the list
    if (entity is Directory) {
      pathList.add(entity.path);
    }
  }

  Future<void> navigateBack() async {
    if (currentEntity.value != null) {
      /// if root directory contains parent directory then make currentDirectory null to show homepage
      final bool showRootDir =
          rootDirs.map((e) => e.path).contains(currentEntity.value!.path);
      final bool isParentExists = await currentEntity.value!.parent.exists();
      if (isParentExists && !showRootDir) {
        openDirectory(currentEntity.value!.parent);
      } else {
        currentEntity.value = null;
      }
    }
  }

  void updateViewType() {
    viewType.value = !viewType.value;
    Preferences.setViewType(!viewType.value);
  }

  bool isCurrentEntitySelected(FileSystemEntity entity) {
    return selectedEntities.where((e) => e.path == entity.path).isNotEmpty;
  }

  void _selectEntity(FileSystemEntity entity) {
    isCurrentEntitySelected(entity)
        ? selectedEntities.removeWhere((e) => e.path == entity.path)
        : selectedEntities.add(entity);
    updateUi.value = !updateUi.value;
  }

  void onTapEntity(FileSystemEntity entity) {
    if (selectedEntities.isNotEmpty) {
      _selectEntity(entity);
    } else {
      if (entity is File) {
        OpenFile.open(entity.path);
      } else {
        openDirectory(entity);
      }
    }
  }

  void onLongPressEntity(FileSystemEntity entity) {
    _selectEntity(entity);
  }
}
