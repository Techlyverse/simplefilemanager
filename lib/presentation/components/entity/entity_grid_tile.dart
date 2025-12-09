import 'dart:io';

import 'package:flutter/material.dart';

import '../../../data/extensions/filesystementity_extension.dart';
import '../../../helper/app_controller.dart';
import 'entity_icon.dart';

class EntityGridTile extends StatelessWidget {
  const EntityGridTile({super.key, required this.entity});
  final FileSystemEntity entity;
  static final AppController controller = AppController();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ValueListenableBuilder(
      valueListenable: AppController().updateUi,
      builder: (context, value, child) {
        bool isSelected = controller.isSelected(entity.path);

        return TextButton(
          onPressed: () {
            controller.onTapEntity(entity);
          },
          onLongPress: () {
            controller.onLongPressEntity(entity.path);
          },
          style: TextButton.styleFrom(
            padding: isSelected ? EdgeInsets.all(8) : EdgeInsets.zero,
            backgroundColor: isSelected ? colorScheme.primaryFixedDim : null,
            foregroundColor: colorScheme.onSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: EntityIcon(entity, key: ValueKey(entity.path)),
              ),
              if (entity.fileType != .image)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    entity.name,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: isSelected
                        ? TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
                        : TextStyle(fontSize: 13),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
