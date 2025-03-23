import 'dart:io';

import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';

import '../../widgets/tile_list.dart';

class DirList extends StatelessWidget {
  const DirList({super.key, required this.entity, required this.fmc});
  final List<FileSystemEntity> entity;
  final FileManagerController fmc;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: entity.length,
        itemBuilder: (context, index) {
          return TileList(
            entity: entity[index],
            onTap: () {
              FileManager.isFile(entity[index])
                  ? OpenFilex.open(entity[index].path)
                  : fmc.openDirectory(entity[index]);
            },
          );
        });
  }
}
