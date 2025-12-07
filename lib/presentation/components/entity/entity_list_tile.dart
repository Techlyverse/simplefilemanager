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
        }

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 1),
          child: ListTile(
            tileColor: isSelected ? context.colorScheme.primaryFixedDim : null,
            shape: RoundedRectangleBorder(borderRadius: .circular(8)),
            onTap: () {
              controller.onTapEntity(entity);
            },
            onLongPress: () {
              controller.onLongPressEntity(entity);
            },
            leading: EntityIcon(entity, key: ValueKey(entity.path)),
            title: Text(
              entity.name,
              maxLines: 2,
              style: isSelected
                  ? TextStyle(
                      fontSize: 13,
                      color: context.colorScheme.onPrimaryFixed,
                      fontWeight: FontWeight.bold,
                    )
                  : null,
            ),
            trailing: trailing(),
          ),
        );
      },
    );
  }
}
