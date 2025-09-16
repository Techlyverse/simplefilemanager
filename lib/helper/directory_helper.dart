import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:filemanager/preferences/preferences.dart';

class DirectoryHelper {
  DirectoryHelper._();
  static final _instance = DirectoryHelper._();
  factory DirectoryHelper() => _instance;

  Future<List<Directory>> getRootDirectories() async {
    //TODO: complete below functions
    if (Platform.isAndroid) {
      return _getAndroidRootDirectories();
    } else if (Platform.isIOS) {
      throw Exception("Implementation not found");
    } else if (Platform.isLinux) {
      throw Exception("Implementation not found");
    } else if (Platform.isMacOS) {
      throw Exception("Implementation not found");
    } else if (Platform.isWindows) {
      throw Exception("Implementation not found");
    } else {
      throw Exception("OS not supported");
    }
  }
}

/// Get internal and external storage directories of android
Future<List<Directory>> _getAndroidRootDirectories() async {
  final extDirs = await getExternalStorageDirectories();
  if (extDirs == null) return [Directory("/storage/emulated/0")];

  final dirs = extDirs.map((e) => Directory(e.path.split("/Android").first));
  return dirs.toList();
}


/*
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
   */
