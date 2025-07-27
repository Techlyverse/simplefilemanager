import 'dart:io';

import 'package:filemanager/helper/extension.dart';
import 'package:flutter/material.dart';
import '../../../data/media_icons.dart';

class EntityIcon extends StatelessWidget {
  const EntityIcon(this.entity, {super.key});
  final FileSystemEntity entity;

  @override
  Widget build(BuildContext context) {
    return entity is File
        ? Image.asset(
            mediaIcons[entity.extension] ?? 'assets/unknown.png',
            height: 35,
          )
        : Image.asset(
            mediaIcons[entity.extension] ?? 'assets/folder.png',
            height: 35,
          );
  }
}
