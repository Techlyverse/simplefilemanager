import 'dart:io';

import 'package:filemanager/data/extensions/filesystementity_ext.dart';
import 'package:filemanager/presentation/components/entity/image_thumb_nail.dart';
import 'package:flutter/material.dart';

import '../../../data/media_icons.dart';

class EntityIcon extends StatelessWidget {
  const EntityIcon(this.entity, {super.key});
  final FileSystemEntity entity;

  // @override
  // Widget build(BuildContext context) {
  //   return entity is File
  //       ? Image.asset(
  //           mediaIcons[entity.extension] ?? 'assets/unknown.png',
  //           width: 40,
  //         )
  //       : Image.asset(
  //           mediaIcons[entity.extension] ?? 'assets/folder.png',
  //           width: 40,
  //         );
  // }

  // version for image thumbnail
  bool get isDirectory => entity is Directory;
  bool get isImageFile {
    final ext = entity.extension.toLowerCase();
    return ['jpg', 'jpeg', 'png','gif', 'webp'].contains(ext);
  }

  @override
  Widget build(BuildContext context){
    if(isDirectory){
      return Image.asset(
        mediaIcons['folder'] ?? 'assets/folder.png',
        width: 40,
      );
    }

    if (isImageFile) {
      return ImageThumbnail(file: entity, size: 40,);
    }

    return Image.asset(
      mediaIcons[entity.extension] ?? 'assets/unknown.png',
      width: 40,
    );
  }
}
