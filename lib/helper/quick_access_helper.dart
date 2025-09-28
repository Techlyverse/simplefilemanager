import 'dart:io';

import '../model/quick_access_model.dart';

class QuickAccessHelper {
  QuickAccessHelper._();
  static final QuickAccessHelper _instance = QuickAccessHelper._();
  factory QuickAccessHelper() => _instance;

  static final List<QuickAccessModel> _quickAccessDirs = [];

  Future<List<QuickAccessModel>> getDirectories() async {
    if (_quickAccessDirs.isNotEmpty) return _quickAccessDirs;

    _quickAccessDirs.clear();
    //TODO: complete below functions
    if (Platform.isAndroid) {
     await  _getAndroidDirectories(); // added await cause the quick access was not displayed on first install
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

    return _quickAccessDirs;
  }

  static Future<void> _getAndroidDirectories() async {
    List<String> paths = [
      "/storage/emulated/0/Download",
      "/storage/emulated/0/Documents",
      "/storage/emulated/0/Movies",
      "/storage/emulated/0/Music",
      "/storage/emulated/0/DCIM",
    ];

    await _getAndroidQA(paths); // added await because the quick access was not displayed on the first install
  }

  static Future<void> _getAndroidQA(List<String> paths) async {
    if (paths.isEmpty) return;

    for (String path in paths) {
      final Directory dir = Directory(path);
      if (await dir.exists()) {
        if (path.contains('Download')) {
          _quickAccessDirs.add(QuickAccessModel(
            image: "assets/downloads.png",
            title: "Download",
            directory: dir,
          ));
        } else if (path.contains('Documents')) {
          _quickAccessDirs.add(QuickAccessModel(
            image: "assets/documents.png",
            title: "Documents",
            directory: dir,
          ));
        } else if (path.contains('Movies')) {
          _quickAccessDirs.add(QuickAccessModel(
            image: "assets/videos.png",
            title: "Movies",
            directory: dir,
          ));
        } else if (path.contains('Music')) {
          _quickAccessDirs.add(QuickAccessModel(
            image: "assets/music.png",
            title: "Music",
            directory: dir,
          ));
        } else if (path.contains('DCIM')) {
          _quickAccessDirs.add(QuickAccessModel(
            image: "assets/image.png",
            title: "Images",
            directory: dir,
          ));
        }
      }
    }
  }
}
