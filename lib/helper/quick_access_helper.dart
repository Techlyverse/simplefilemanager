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
      //throw Exception("Implementation not found");
      await _getLinuxDirectories();
    } else if (Platform.isMacOS) {
      throw Exception("Implementation not found");
    } else if (Platform.isWindows) {
      //throw Exception("Implementation not found");
      await _getWindowsDirectories();
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

    await _getQA(paths); // added await because the quick access was not displayed on the first install
  }

  static Future<void> _getLinuxDirectories() async {
    final home = Platform.environment['HOME'] ?? '/home';
    List<String> paths = [
      "$home/Downloads",
      "$home/Documents",
      "$home/Music",
      "$home/Pictures",
      "$home/Videos"
    ];
    await _getQA(paths);
  }

  static Future<void> _getWindowsDirectories() async {
    final userDirectory = Platform.environment['USERPROFILE'] ?? r"C:\Users\Public";
    List<String> paths = [
      "$userDirectory\\Downloads",
      "$userDirectory\\Documents",
      "$userDirectory\\Videos",
      "$userDirectory\\Music",
      "$userDirectory\\Pictures"
    ];
    await _getQA(paths);
  }

  static Future<void> _getQA(List<String> paths) async {
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
        }  else if (path.contains('Downloads')) {
          _quickAccessDirs.add(QuickAccessModel(
            image: "assets/downloads.png",
            title: "Downloads",
            directory: dir,
          ));
        }  else if (path.contains('Videos')) {
          _quickAccessDirs.add(QuickAccessModel(
            image: "assets/videos.png",
            title: "Videos",
            directory: dir,
          ));
        }  else if (path.contains('Pictures')) {
          _quickAccessDirs.add(QuickAccessModel(
            image: "assets/image.png",
            title: "Pictures",
            directory: dir,
          ));
        }
      }
    }
  }
}
