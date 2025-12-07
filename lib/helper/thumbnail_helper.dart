import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

import 'app_controller.dart';

class ThumbnailHelper {
  const ThumbnailHelper._();

  static Future<String?> fetchOrCreateThumbnail(String filePath) async {
    final String thumbPath = await _getThumbnailPath(filePath);
    if (await File(thumbPath).exists()) return thumbPath;

    final args = {"imagePath": filePath, "thumbPath": thumbPath};
    return await compute(_generateThumbnail, args);
  }

  static Future<String> _getThumbnailPath(String filePath) async {
    final String cacheDir = AppController().cacheDir.path;
    final int pathHash = filePath.hashCode;

    final FileStat fileStat = await File(filePath).stat();
    final int modifiedTimestamp = fileStat.modified.millisecondsSinceEpoch;

    return "$cacheDir/$pathHash-$modifiedTimestamp.jpg";
  }

  static Future<String?> _generateThumbnail(Map<String, dynamic> args) async {
    try {
      final String imagePath = args['imagePath'];
      final String thumbPath = args['thumbPath'];

      final Uint8List bytes = await File(imagePath).readAsBytes();
      final img.Image? image = img.decodeImage(bytes);
      if (image == null) return null;

      final img.Image thumb = img.copyResize(image, width: 180);
      final Uint8List uint8list = img.encodeJpg(thumb, quality: 80);

      await File(thumbPath).writeAsBytes(uint8list);
      return thumbPath;
    } catch (e) {
      return null;
    }
  }
}
