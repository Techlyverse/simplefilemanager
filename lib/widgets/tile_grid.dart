import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_manager/file_manager.dart';
import 'file_icon.dart';

class TileGrid extends StatelessWidget {
  const TileGrid({
    super.key,
    required this.entity,
    required this.onTap,
  });
  final FileSystemEntity entity;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool isFile = FileManager.isFile(entity);
    final colorScheme = Theme.of(context).colorScheme;
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        elevation: 0.5,
        backgroundColor: colorScheme.surfaceContainer,
        foregroundColor: colorScheme.onSurface.withValues(alpha: 0.9),
        padding: const EdgeInsets.all(2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(),
          FileIcon(
            isFile: isFile,
            extension: isFile ? FileManager.getFileExtension(entity) : '',
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
            child: Text(
              FileManager.basename(entity),
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
