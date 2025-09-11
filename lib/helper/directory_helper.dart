import 'dart:io';

import 'package:filemanager/preferences/preferences.dart';

class DirectoryHelper {
  DirectoryHelper._();
  static final _instance = DirectoryHelper._();
  factory DirectoryHelper() => _instance;

  // TODO: write functions to save and get root paths from shared preferences
  final List<Directory> _rootDirectories = [];

  //TODO: write functions to fetch root directories

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
      //TODO: complete below functions
      if (Platform.isAndroid) {
      } else if (Platform.isIOS) {
      } else if (Platform.isLinux) {
      } else if (Platform.isMacOS) {
      } else if (Platform.isWindows) {
      } else {
        throw Exception("OS not supported");
      }
      return _rootDirectories;
    }
  }
}
