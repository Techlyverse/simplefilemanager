import 'dart:io';
import 'file_icon.dart';
import 'package:flutter/material.dart';
import 'package:file_manager/file_manager.dart';

class ListWidget extends StatelessWidget {
  const ListWidget({
    super.key,
    required this.entity,
    required this.onTap,
  });
  final FileSystemEntity entity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool isFile = FileManager.isFile(entity);

    return Column(
      children: [
        ListTile(
          onTap: onTap,
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          title: Text(FileManager.basename(entity, showFileExtension: false)),
          leading: FileIcon(
            isFile: isFile,
            extension: isFile ? FileManager.getFileExtension(entity) : '',
          ),
          trailing: FutureBuilder<FileStat>(
              future: entity.stat(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox();
                return Text(
                  isFile
                      ? FileManager.formatBytes(snapshot.data!.size)
                      : "${snapshot.data!.modified}".substring(0, 10),
                );
              }),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 70, right: 8),
          child: Divider(thickness: 1, height: 1),
        )
      ],
    );
  }
}
