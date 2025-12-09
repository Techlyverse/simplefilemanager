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
  // Exposed getter for UI feedback
  int get selectedCount => _selectedPaths.length;
  bool get isSelectionMode => _selectedPaths.isNotEmpty;

  late final Directory cacheDir;
  final List<Directory> rootDirs = [];

  final ValueNotifier<bool> updateUi = ValueNotifier(true);
  final ValueNotifier<bool> showGridView = ValueNotifier(
    Preferences.getViewType(),
  );

  final ValueNotifier<FileSystemEntity?> currentEntity = ValueNotifier(null);

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
    clearSelection();
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

  void toggleEntityViewType() {
    showGridView.value = !showGridView.value;
    Preferences.setViewType(showGridView.value);
  }

  bool isSelected(String path) {
    return _selectedPaths.contains(path);
  }

  void toggleEntitySelectType(String path) {
    _selectedPaths.contains(path)
        ? _selectedPaths.remove(path)
        : _selectedPaths.add(path);
    updateUi.value = !updateUi.value;
  }

  void onTapEntity(FileSystemEntity entity) {
    if (_selectedPaths.isNotEmpty) {
      toggleEntitySelectType(entity.path);
    } else {
      if (entity is Directory) {
        openDirectory(entity);
      } else {
        OpenFile.open(entity.path);
      }
    }
  }

  void onLongPressEntity(String path) {
    toggleEntitySelectType(path);
  }

  void clearSelection() {
    if (_selectedPaths.isNotEmpty) {
      _selectedPaths.clear();
      updateUi.value = !updateUi.value;
    }
  }

  Future<void> createFolder(String folderName) async {
    final current = currentEntity.value;
    if (current is! Directory) return;

    final newPath = p.join(current.path, folderName);
    final newFolder = Directory(newPath);

    if (!await newFolder.exists()) {
      await newFolder.create();
      updateUi.value = !updateUi.value;
    } else {
      // Throwing an exception is fine for error feedback
      throw Exception("Folder already exists");
    }
  }

  Future<void> renameEntity(FileSystemEntity entity, String newName) async {
    final newPath = p.join(entity.parent.path, newName);
    if (await FileSystemEntity.type(newPath) == FileSystemEntityType.notFound) {
      await entity.rename(newPath);

      // Remove old path and add new path to selection set if it was selected
      if (_selectedPaths.remove(entity.path)) _selectedPaths.add(newPath);
      updateUi.value = !updateUi.value;
    } else {
      throw Exception("File or folder already exists");
    }
  }

  Future<void> deleteEntity(FileSystemEntity entity) async {
    if (await entity.exists()) {
      await entity.delete(recursive: true);
      // Ensure the path is removed from the selection set
      _selectedPaths.remove(entity.path);
      updateUi.value = !updateUi.value;
    }
  }
}
