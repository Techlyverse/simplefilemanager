import 'dart:io';

import 'package:filemanager/data/extensions/filesystementity_ext.dart';
import 'package:filemanager/globals.dart';
import 'package:flutter/material.dart';

import '../../../helper/app_controller.dart';
import 'entity_icon.dart';

class EntityGridTile extends StatelessWidget {
  const EntityGridTile({super.key, required this.entity});
  final FileSystemEntity entity;
  static final AppController controller = AppController();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: isAndroid ? 90 : 70,
      height: isAndroid ? 90 : 70,
      child: TextButton(
        onPressed: () {
          controller.onTapEntity(entity);
        },
        onLongPress: () {
          controller.onLongPressEntity(entity);
        },
        style: TextButton.styleFrom(
          backgroundColor: controller.isCurrentEntitySelected(entity)
              ? colorScheme.surfaceContainerHighest
              : null,
          foregroundColor: colorScheme.onSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            EntityIcon(entity),
            Text(
              entity.name,
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: isAndroid ? 14 : 10),
            ),
          ],
        ),
      ),
    );
  }
}
