import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

import 'app_controller.dart';

class ThumbnailHelper {
  const ThumbnailHelper._();

  static Future<File?> fetchOrCreateThumbnail(FileSystemEntity entity) async {
    if (entity is! File) return null;

    final String thumbPath = await _getThumbnailPath(entity);

    final File thumbnail = File(thumbPath);
    if (await thumbnail.exists()) return thumbnail;

    final args = {"imagePath": entity.path, "thumbPath": thumbPath};
    print('args: $args');

    return await compute(_generateThumbnail, args);
  }

  static Future<String> _getThumbnailPath(File file) async {
    final String cacheDir = AppController().cacheDir.path;
    final int pathHash = file.path.hashCode;

    final FileStat fileStat = await file.stat();
    final int modifiedTimestamp = fileStat.modified.millisecondsSinceEpoch;

    return "$cacheDir/$pathHash-$modifiedTimestamp.jpg";
  }

  static Future<File?> _generateThumbnail(Map<String, dynamic> args) async {
    try {
      final String imagePath = args['imagePath'];
      final String thumbPath = args['thumbPath'];

      final File thumbnail = File(thumbPath);

      final Uint8List bytes = await File(imagePath).readAsBytes();
      final img.Image? image = img.decodeImage(bytes);
      if (image == null) return null;

      final img.Image thumb = img.copyResize(image, width: 150);
      final Uint8List thumbBytes = img.encodeJpg(thumb, quality: 80);

      return await thumbnail.writeAsBytes(Uint8List.fromList(thumbBytes));
    } catch (e) {
      return null;
    }
  }
}
