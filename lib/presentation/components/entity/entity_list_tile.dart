import 'dart:io';
import 'package:filemanager/data/extensions/context_extension.dart';
import 'package:filemanager/helper/app_controller.dart';
import 'package:filemanager/helper/file_utils.dart';
import 'package:flutter/material.dart';

import '../../../data/extensions/filesystementity_extension.dart';
import 'entity_icon.dart';

class EntityListTile extends StatelessWidget {
  const EntityListTile({super.key, required this.entity});
  final FileSystemEntity entity;

  @override
  Widget build(BuildContext context) {
    final AppController controller = AppController();

    return ValueListenableBuilder(
      valueListenable: AppController().updateUi,
      builder: (context, value, child) {
        bool isSelected = controller.isCurrentEntitySelected(entity);

        Widget trailing() {
          if (controller.selectedEntities.isEmpty) {
            return FutureBuilder<FileStat>(
              future: entity.stat(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox();
                return Text(
                  entity is File
                      ? FileUtils.formatBytes(snapshot.data!.size)
                      : "${snapshot.data!.modified}".substring(0, 10),
                  style: TextStyle(fontSize: 12),
                );
              },
            );
          } else {
            if (isSelected) {
              return Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colorScheme.surfaceContainerLowest,
                  border: Border.all(
                    width: 2,
                    color: context.colorScheme.primary,
                  ),
                ),
                padding: EdgeInsets.all(3),
                child: CircleAvatar(
                  backgroundColor: context.colorScheme.primary,
                ),
              );
            } else {
              return Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colorScheme.surfaceContainerLowest,
                  border: Border.all(
                    width: 2,
                    color: context.colorScheme.primary,
                  ),
                ),
              );
            }
          }
        }

        return Padding(
          padding: EdgeInsets.zero,
          child: ListTile(
            tileColor: isSelected ? context.colorScheme.primaryFixedDim : null,
            shape: RoundedRectangleBorder(borderRadius: .circular(8)),
            onTap: () {
              controller.onTapEntity(entity);
            },
            onLongPress: () {
              controller.onLongPressEntity(entity);
            },
            title: Text(
              entity.name,
              maxLines: 2,
              style: isSelected
                  ? TextStyle(
                      fontSize: 15,
                      color: context.colorScheme.onPrimaryFixed,
                      fontWeight: FontWeight.bold,
                    )
                  : null,
            ),
            leading: EntityIcon(entity),
            trailing: trailing(),
          ),
        );
      },
    );
  }
}
