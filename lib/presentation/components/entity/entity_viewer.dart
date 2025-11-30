import 'dart:io';

import 'package:filemanager/helper/app_controller.dart';
import 'package:flutter/material.dart';

import '../../../data/extensions/context_extension.dart';
import 'entity_grid_tile.dart';
import 'entity_list_tile.dart';

class EntityViewer extends StatelessWidget {
  const EntityViewer({super.key, required this.dir});
  final Directory dir;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FileSystemEntity>>(
      future: dir.list().toList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              height: 80,
              width: 80,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        } else if (snapshot.data != null && snapshot.data!.isNotEmpty) {
          return ValueListenableBuilder<bool>(
            valueListenable: AppController().viewType,
            builder: (_, isGrid, _) {
              return isGrid
                  ? buildGrid(snapshot.data!, context)
                  : buildList(snapshot.data!);
            },
          );
        } else {
          return SizedBox();
        }
      },
    );
  }

  Widget buildGrid(List<FileSystemEntity> entities, BuildContext context) {
    // Get the available width of the screen/widget
    final double screenWidth = context.width;

    final layoutType = context.layoutType;

    // Define the minimum width you want for a grid tile
    final double minItemWidth = layoutType == .mobile ? 80 : 120;

    // Define the spacing between items
    final double spacing = layoutType == .mobile ? 12 : 16;

    // Calculate the crossAxisCount (number of items per row)
    // This ensures the count adapts to screen size.
    int crossAxisCount = (screenWidth / (minItemWidth + spacing)).floor();

    // Ensure count is at least 1
    if (crossAxisCount < 1) crossAxisCount = 1;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: 0.8,
      ),
      itemCount: entities.length,
      itemBuilder: (context, index) {
        return EntityGridTile(entity: entities[index]);
      },
    );
  }

  Widget buildList(List<FileSystemEntity> entities) {
    return ListView.builder(
      itemCount: entities.length,
      itemBuilder: (context, index) {
        return EntityListTile(entity: entities[index]);
      },
    );
  }
}
