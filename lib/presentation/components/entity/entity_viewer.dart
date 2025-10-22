import 'dart:io';

import 'package:filemanager/helper/app_controller.dart';
import 'package:flutter/material.dart';

import 'entity_grid_tile.dart';
import 'entity_list_tile.dart';

class EntityViewer extends StatelessWidget {
  const EntityViewer({Key? key, required this.dir}): super(key: key);
  final Directory dir;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: AppController().viewType,
        builder: (_, isGrid, __) {
          // TODO: replace bool with EntityViewType for more view options
          return isGrid ? buildGrid() : buildList();
        });
  }

  Widget buildGrid() {
    return FutureBuilder<List<FileSystemEntity>>(
        future: dir.list().toList(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                height: 80,
                width: 80,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          } else if (snapshot.data != null && snapshot.data!.isNotEmpty) {
            final List<FileSystemEntity> entities = snapshot.data!;

            return SingleChildScrollView(
              child: ValueListenableBuilder(
                  valueListenable: AppController().updateUi,
                  builder: (context, value, child) {
                    return Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: entities.map((entity) {
                        return EntityGridTile(entity: entity);
                      }).toList(),
                    );
                  }),
            );
          }
          return SizedBox();
        });
  }

  Widget buildList() {
    return FutureBuilder<List<FileSystemEntity>>(
        future: dir.list().toList(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                height: 80,
                width: 80,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          } else if (snapshot.data != null && snapshot.data!.isNotEmpty) {
            final List<FileSystemEntity> entities = snapshot.data!;

            return ValueListenableBuilder(
                valueListenable: AppController().updateUi,
                builder: (context, value, child) {
                  return ListView.builder(
                      itemCount: entities.length,
                      itemBuilder: (context, index) {
                        return EntityListTile(entity: entities[index]);
                      });
                });
          }
          return SizedBox();
        });
  }
}
