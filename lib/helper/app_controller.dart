import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:filemanager/preferences/preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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

  static final Directory _alternateDirectory = Directory(r'/home/manu/Downloads');
  late Directory _initialDirectory;

  //static final _initialDirectory = Directory(r'/home/manu/Downloads');
  // a list that contains all the directories that we went through for the current directory -MG
  //List<String> pathList = [_initialDirectory.toString()];
  late List<String> pathList;
  ValueNotifier<bool> showGrid = ValueNotifier(Preferences.getViewType());
  List<String> pathList = [_directory.toString()];

  Future<void> initController() async {
    _directory =
    _tempDirectory = await getApplicationDocumentsDirectory();

  }


  //ValueNotifier<FileSystemEntity> fileSystemEntity =
  //    ValueNotifier(_initialDirectory);
  late ValueNotifier<FileSystemEntity> fileSystemEntity;
  ValueNotifier<List<FileSystemEntity>> fileSystemEntities = ValueNotifier([]);
  ValueNotifier<List<Directory>> directoriesInRoot = ValueNotifier([]);
  // for long press on icons
  ValueNotifier<FileSystemEntity?> selectedEntity = ValueNotifier(null);



  Future<Directory> _getPlatformRootDirectory() async {
    if(Platform.isAndroid){
      final dir = await getExternalStorageDirectory();
      if(dir != null){
        String newPath = "";
        List<String> folders = dir.path.split("/");
        for (int i = 1; i < folders.length; i++){
          if(folders[i] == "Android") break;
          newPath += "/${folders[i]}";
        }
        return Directory(newPath);
      }
    }

    Directory? startingDir;
    String? userPath;

    if (Platform.isLinux || Platform.isMacOS){
      userPath = Platform.environment['HOME'];
      startingDir = await getApplicationDocumentsDirectory();
    } else if (Platform.isWindows){
      userPath = Platform.environment['USERPROFILE'];
      startingDir = await getApplicationDocumentsDirectory();
    }

    if (startingDir == null){
      return _alternateDirectory;
    }

    if(userPath != null){
      Directory current = startingDir;
      while (current.path != userPath && current.parent.path != current.path) {
        current = current.parent;
      }

      return current;
    }

    Directory root = startingDir;
    while (root.parent.path != root.path){
      root = root.parent;
    }

    return root;

    //return _alternateDirectory;
  }

  Future<void> listOfDirectoriesInRoot() async{
    final Directory root = await _getPlatformRootDirectory();
    final listOfRootDir = root.listSync().whereType<Directory>().toList();
    if (listOfRootDir != []) {
      directoriesInRoot.value = listOfRootDir;
    } else {
      directoriesInRoot.value = [];
    }

  }

  Future<void> init() async{
    _initialDirectory = await _getPlatformRootDirectory();

    pathList = [_initialDirectory.path];
    fileSystemEntity = ValueNotifier<FileSystemEntity>(_initialDirectory);
    await loadInitialFiles();
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
    // final bool isParentExists = await fileSystemEntity.value.parent.exists();
    // if (isParentExists) {
    //   openDirectory(fileSystemEntity.value.parent);
    // }
    final current = fileSystemEntity.value;
    if(current == null) return;
    final parent = current.parent;
    if(await parent.exists()){
      openDirectory(parent);
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
