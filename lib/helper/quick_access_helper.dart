import 'dart:io';

import '../model/quick_access_model.dart';

class QuickAccessHelper {
  QuickAccessHelper._();
  static final QuickAccessHelper _instance = QuickAccessHelper._();
  factory QuickAccessHelper() => _instance;

  static final List<QuickAccessModel> _quickAccessDirs = [];

  Future<List<QuickAccessModel>> getDirectories() async {
    if (_quickAccessDirs.isNotEmpty) return _quickAccessDirs;
    List<String> paths = [];

    if (Platform.isAndroid) {
      paths = [
        "/storage/emulated/0/Download",
        "/storage/emulated/0/Documents",
        "/storage/emulated/0/Movies",
        "/storage/emulated/0/Music",
        "/storage/emulated/0/DCIM",
      ];
    } else if (Platform.isLinux) {
      final home = Platform.environment['HOME'] ?? '/home';
      paths = [
        "$home/Downloads",
        "$home/Documents",
        "$home/Music",
        "$home/Pictures",
        "$home/Videos",
      ];
    } else if (Platform.isWindows) {
      final user = Platform.environment['USERPROFILE'] ?? r"C:\Users\Public";
      paths = [
        "$user\\Downloads",
        "$user\\Documents",
        "$user\\Videos",
        "$user\\Music",
        "$user\\Pictures",
      ];
    } else if (Platform.isIOS) {
      throw Exception("Implementation not found");
    } else if (Platform.isMacOS) {
      throw Exception("Implementation not found");
    } else {
      throw Exception("Implementation not found");
    }

    if (paths.isNotEmpty) await _processPaths(paths);
    return _quickAccessDirs;
  }

  static Future<void> _processPaths(List<String> paths) async {
    await Future.wait(
      paths.map((path) async {
        final dir = Directory(path);
        if (await dir.exists()) {
          final model = _createModel(path, dir);
          if (model != null) _quickAccessDirs.add(model);
        }
      }),
    );
  }

  static QuickAccessModel? _createModel(String path, Directory dir) {
    // Normalize path to handle case sensitivity generic checks
    final lowerPath = path.toLowerCase();
    if (lowerPath.contains('download')) {
      return QuickAccessModel(
        image: "assets/downloads.png",
        title: "Downloads",
        directory: dir,
      );
    } else if (lowerPath.contains('document')) {
      return QuickAccessModel(
        image: "assets/documents.png",
        title: "Documents",
        directory: dir,
      );
    } else if (lowerPath.contains('movie') || lowerPath.contains('video')) {
      return QuickAccessModel(
        image: "assets/videos.png",
        title: "Videos",
        directory: dir,
      );
    } else if (lowerPath.contains('music')) {
      return QuickAccessModel(
        image: "assets/music.png",
        title: "Music",
        directory: dir,
      );
    } else if (lowerPath.contains('dcim') ||
        lowerPath.contains('picture') ||
        lowerPath.contains('image')) {
      return QuickAccessModel(
        image: "assets/image.png",
        title: "Images",
        directory: dir,
      );
    }
    return null;
  }
}
