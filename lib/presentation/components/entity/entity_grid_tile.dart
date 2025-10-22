import 'dart:io';

import 'package:filemanager/data/extensions/filesystementity_ext.dart';
import 'package:filemanager/globals.dart';
import 'package:flutter/material.dart';

import '../../../helper/app_controller.dart';
import 'entity_icon.dart';

class EntityGridTile extends StatelessWidget {
  const EntityGridTile({Key? key, required this.entity}): super(key: key);
  final FileSystemEntity entity;
  static final AppController controller = AppController();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    bool isSelected = controller.isCurrentEntitySelected(entity);

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
          backgroundColor: isSelected ? colorScheme.background : null,
          primary: colorScheme.onSurface,
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
              style: isSelected
                  ? TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
