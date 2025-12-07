import 'dart:io';
import 'package:filemanager/helper/app_controller.dart';
import 'package:flutter/material.dart';
import '../../../data/extensions/filesystementity_extension.dart';
import '../../../data/media_icons.dart';
import '../../../helper/thumbnail_helper.dart';

class EntityIcon extends StatelessWidget {
  const EntityIcon(this.entity, {super.key});
  final FileSystemEntity entity;

  @override
  Widget build(BuildContext context) {
    if (entity.fileType != .image) {
      return _placeholder();
    } else {
      return _thumbnail();
    }
  }

  Widget _placeholder() {
    return ValueListenableBuilder(
      key: key,
      valueListenable: AppController().viewType,
      child: Image.asset(
        entity is Directory
            ? 'assets/folder.png'
            : mediaIcons[entity.extension] ?? 'assets/unknown.png',
      ),
      builder: (_, isGrid, child) {
        return Padding(
          padding: isGrid ? EdgeInsets.only(bottom: 20) : EdgeInsets.all(5),
          child: child,
        );
      },
    );
  }

  Widget _thumbnail() {
    return FutureBuilder<String?>(
      key: key,
      future: ThumbnailHelper.fetchOrCreateThumbnail(entity.path),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.hasError ||
            !snapshot.hasData) {
          return _placeholder();
        } else if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.file(
                File(snapshot.data!),
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) {
                  return _placeholder();
                },
              ),
            ),
          );
        } else {
          return _placeholder();
        }
      },
    );
  }
}
