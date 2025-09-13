import 'dart:io';

import 'package:filemanager/globals.dart';
import 'package:filemanager/helper/extension.dart';
import 'package:flutter/material.dart';

import 'entity_icon.dart';

class EntityGridTile extends StatelessWidget {
  const EntityGridTile({
    super.key,
    required this.entity,
    required this.onTap,
    this.onLongPress,
  });
  final FileSystemEntity entity;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: isAndroid ? 90 : 70,
      height: isAndroid? 90 : 70,
      child: TextButton(
        onPressed: onTap,
        onLongPress: onLongPress,
        style: TextButton.styleFrom(
          backgroundColor: colorScheme.surfaceContainerLowest,
          foregroundColor: colorScheme.onSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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