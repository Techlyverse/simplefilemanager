import 'dart:io';

import 'package:flutter/material.dart';

import '../../../data/extensions/filesystementity_extension.dart';
import '../../../data/media_icons.dart';
import '../../../helper/thumbnail_helper.dart';

class EntityIcon extends StatefulWidget {
  const EntityIcon(this.entity, {super.key});
  final FileSystemEntity entity;

  @override
  State<EntityIcon> createState() => _EntityIconState();
}

class _EntityIconState extends State<EntityIcon> {
  // Store the Future here so it only runs once per widget creation
  late Future<File?> _thumbnailFuture;
  @override
  void initState() {
    super.initState();
    _thumbnailFuture = ThumbnailHelper.fetchOrCreateThumbnail(widget.entity);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.entity.fileType != .image) {
      return _placeholder();
    } else {
      return _thumbnail();
    }
  }

  Widget _placeholder() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.asset(
        widget.entity is Directory
            ? 'assets/folder.png'
            : mediaIcons[widget.entity.extension] ?? 'assets/unknown.png',
      ),
    );
  }

  Widget _thumbnail() {
    return FutureBuilder(
      future: _thumbnailFuture,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.file(snapshot.data!, fit: BoxFit.cover),
            ),
          );
        } else {
          return _placeholder();
        }
      },
    );
  }
}
