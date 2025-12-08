import 'dart:io';
import 'package:path/path.dart' as p;
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

  final Set<String> _rootPaths = {};
  final Set<String> _selectedPaths = {};

  late final Directory cacheDir;
  final List<Directory> rootDirs = [];

  final ValueNotifier<bool> updateUi = ValueNotifier(true);
  final ValueNotifier<bool> showGridView = ValueNotifier(Preferences.getViewType());
  final ValueNotifier<FileSystemEntity?> currentEntity = ValueNotifier(null);
  final List<FileSystemEntity> selectedEntities = [];

  // a list that contains all the directories that we went through for the current directory -MG
  List<String> pathList = [];

  /// Fetch root directories of current platform
  Future<void> init() async {
    if (rootDirs.isEmpty) {
      final dirs = await DirectoryHelper().getRootDirectories();
      rootDirs.addAll(dirs);
      cacheDir = await getApplicationCacheDirectory();
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
      final bool showRootDir = rootDirs
          .map((e) => e.path)
          .contains(currentEntity.value!.path);
      final bool isParentExists = await currentEntity.value!.parent.exists();
      if (isParentExists && !showRootDir) {
        openDirectory(currentEntity.value!.parent);
      } else {
        currentEntity.value = null;
      }
    }
  }

  void updateViewType() {
    showGridView.value = !showGridView.value;
    Preferences.setViewType(!showGridView.value);
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

  Future<void> createFolder(String folderName) async {
    if (currentEntity.value is! Directory) return;
    final currentDir = currentEntity.value as Directory;
    final newPath = p.join(currentDir.path, folderName);
    final newFolder = Directory(newPath);
    if (!await newFolder.exists()) {
      await newFolder.create();
      updateUi.value = !updateUi.value;
    } else {
      throw Exception("Folder already exists");
    }
  }

  Future<void> renameEntity(FileSystemEntity entity, String newName) async {
    final parentPath = entity.parent.path;
    final newPath = p.join(parentPath, newName);
    if (await FileSystemEntity.type(newPath) == FileSystemEntityType.notFound) {
      await entity.rename(newPath);
      updateUi.value = !updateUi.value;
    } else {
      throw Exception("File or folder already exists");
    }
  }

  Future<void> deleteEntity(FileSystemEntity entity) async {
    if (await entity.exists()) {
      await entity.delete(recursive: true);
      if (selectedEntities.contains(entity)) {
        selectedEntities.remove(entity);
      }
      updateUi.value = !updateUi.value;
    }
  }
}
