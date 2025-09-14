import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:filemanager/preferences/preferences.dart';

class DirectoryHelper {
  DirectoryHelper._();
  static final _instance = DirectoryHelper._();
  factory DirectoryHelper() => _instance;

  static final List<Directory> _rootDirectories = [];

  Future<List<Directory>> getRootDirectories() async {
    if (_rootDirectories.isNotEmpty) return _rootDirectories;

    final List<String> rootDirPaths = Preferences.getRootDirPaths() ?? [];
    if (rootDirPaths.isNotEmpty) {
      for (String path in rootDirPaths) {
        final Directory dir = Directory(path);
        if (await dir.exists()) _rootDirectories.add(dir);
      }
      return _rootDirectories;
    } else {
      /// clear list to avoid duplicate directory issues
      _rootDirectories.clear();
      //TODO: complete below functions
      if (Platform.isAndroid) {
        _getAndroidRootDirectories();
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

      /// Cache root directory path
      final List<String> paths = _rootDirectories.map((e) => e.path).toList();
      Preferences.setRootDirPaths(paths);

      return _rootDirectories;
    }
  }

  /// Get internal and external storage directories of android
  static Future<void> _getAndroidRootDirectories() async {
    _rootDirectories.add(Directory("/storage/emulated/0"));
    _rootDirectories.addAll((await getExternalStorageDirectories()) ?? []);
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
}
