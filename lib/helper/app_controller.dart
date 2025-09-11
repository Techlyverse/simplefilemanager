import 'dart:io';
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

  static late final Directory _directory;
  static late final Directory _tempDirectory;


  final ValueNotifier<bool> entityViewTypeNotifier = ValueNotifier(Preferences.getViewType());
  final ValueNotifier<Directory> currentDirNotifier = ValueNotifier(Directory(r'C:/Development'));
  final ValueNotifier<FileSystemEntity> fileSystemEntityNotifier = ValueNotifier(_directory);
  final ValueNotifier<List<FileSystemEntity>> fileSystemEntities = ValueNotifier([]);

  // a list that contains all the directories that we went through for the current directory -MG
  List<String> pathList = [_directory.toString()];

  Future<void> initController() async {
    _directory =
    _tempDirectory = await getApplicationDocumentsDirectory();

  }



  Future<void> loadInitialFiles() async {
    try {
      fileSystemEntities.value = _directory.listSync();
    } catch (e) {
      fileSystemEntityNotifier.value = _directory;
    }
  }

  void openDirectory(FileSystemEntity entity) async {
    fileSystemEntityNotifier.value = entity;
    // adding the directory to the list
    if (entity is Directory) {
      pathList.add(p.basename(entity.path));
    }
    fileSystemEntities.value = Directory(entity.path).listSync();
  }

  Future<void> navigateBack() async {
    final bool isParentExists = await fileSystemEntityNotifier.value.parent.exists();
    if (isParentExists) {
      openDirectory(fileSystemEntityNotifier.value.parent);
    }
  }

  void updateViewType() {
    Preferences.setViewType(!entityViewTypeNotifier.value);
    entityViewTypeNotifier.value = !entityViewTypeNotifier.value;
  }






  Future<Directory> _getRootDirectory()async{}
}
