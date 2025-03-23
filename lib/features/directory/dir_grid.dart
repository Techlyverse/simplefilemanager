import 'dart:io';

import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';

import '../../widgets/tile_grid.dart';

class DirGrid extends StatelessWidget {
  const DirGrid({super.key, required this.entity, required this.fmc});
  final List<FileSystemEntity> entity;
  final FileManagerController fmc;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: entity.length,
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 12,
        crossAxisSpacing: 8,
        crossAxisCount: 4,
      ),
      itemBuilder: (context, index) {
        return TileGrid(
          entity: entity[index],
          onTap: () {
            FileManager.isFile(entity[index])
                ? OpenFilex.open(entity[index].path)
                : fmc.openDirectory(entity[index]);
          },
        );
      },
    );
  }
}
