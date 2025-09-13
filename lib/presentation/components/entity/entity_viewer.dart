import 'dart:io';

import 'package:filemanager/helper/app_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:open_file/open_file.dart';

import 'entity_grid_tile.dart';
import 'entity_list_tile.dart';

class EntityViewer extends StatelessWidget {
  const EntityViewer({super.key, required this.entities});
  final List<FileSystemEntity> entities;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: AppController().viewType,
        builder: (_, isGrid, __) {
          // TODO: replace bool with EntityViewType for more view options
          return isGrid ? buildGrid() : buildList();
        });
  }

  Widget buildGrid() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: entities.map((entity) {
        return EntityGridTile(
          entity: entity,
          onTap: () {
            entity is File
                ? OpenFile.open(entity.path)
                : AppController().openDirectory(entity);
          },
          onLongPress: () {
            AppController().selectedEntity.value = entity;
          },
        );
      }).toList(),
    );
  }

  Widget buildList() {
    return ListView.builder(
        itemCount: entities.length,
        itemBuilder: (context, index) {
          return EntityListTile(
            entity: entities[index],
            onTap: () {
              entities[index] is File
                  ? OpenFile.open(entities[index].path)
                  : AppController().openDirectory(entities[index]);
            },
            onLongPress: () {
              AppController().selectedEntity.value = entities[index];
            },
          );
        });
  }
}
