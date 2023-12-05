import 'dart:io';
import 'file_icon.dart';
import 'package:flutter/material.dart';
import 'package:file_manager/file_manager.dart';

class TileList extends StatelessWidget {
  const TileList({
    super.key,
    required this.entity,
    required this.onTap,
  });
  final FileSystemEntity entity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool isFile = FileManager.isFile(entity);
    return Column(children: [
      FutureBuilder<FileStat>(
          future: entity.stat(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListTile(
                onTap: onTap,
                title: Text(
                    FileManager.basename(entity, showFileExtension: false)),
                leading: FileIcon(
                  isFile: isFile,
                  extension: isFile ? FileManager.getFileExtension(entity) : '',
                ),
                trailing: Text(
                  isFile
                      ? FileManager.formatBytes(snapshot.data!.size)
                      : "${snapshot.data!.modified}".substring(0, 10),
                ),
              );
            } else {
              return const SizedBox();
            }
          }),
      const Padding(
        padding: EdgeInsets.only(left: 70),
        child: Divider(thickness: 1),
      )
    ]);
  }
}
