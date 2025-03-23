import 'package:flutter/material.dart';
import '../data/media_icons.dart';

class FileIcon extends StatelessWidget {
  const FileIcon({super.key, this.extension, required this.isFile});
  final String? extension;
  final bool isFile;

  @override
  Widget build(BuildContext context) {
    return isFile
        ? Image.asset(
            mediaIcons[extension] ?? 'assets/unknown.png',
            height: 35,
          )
        : Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.amber[700],
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.folder, size: 25, color: Colors.white),
          );
  }
}
