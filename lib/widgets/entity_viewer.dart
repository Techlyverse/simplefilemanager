import 'dart:io';

import 'package:filemanager/helper/app_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:open_file/open_file.dart';

import 'grid_entity.dart';
import 'list_entity.dart';

class EntityViewer extends StatelessWidget {
  const EntityViewer({super.key, required this.entities, required this.showGrid});
  final List<FileSystemEntity> entities;
  final bool showGrid;

  @override
  Widget build(BuildContext context) {
    return showGrid ? buildGrid() : buildList();
  }

  Widget buildGrid() {
    return GridView.builder(
      itemCount: entities.length,
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 12,
        crossAxisSpacing: 8,
        crossAxisCount: 4,
      ),
      itemBuilder: (context, index) {
        return GridEntity(
          entity: entities[index],
          onTap: () {
            entities[index] is File
                ? OpenFile.open(entities[index].path)
                : AppController().openDirectory(entities[index]);
          },
        );
      },
    );
  }

  Widget buildList() {
    return ListView.builder(
        itemCount: entities.length,
        itemBuilder: (context, index) {
          return ListEntity(
            entity: entities[index],
            onTap: () {
              entities[index] is File
                  ? OpenFile.open(entities[index].path)
                  : AppController().openDirectory(entities[index]);
            },
          );
        });
  }
}
