import 'dart:io';
import 'package:filemanager/helper/extension.dart';
import 'package:flutter/material.dart';

import 'entity_icon.dart';

class GridEntity extends StatelessWidget {
  const GridEntity({
    super.key,
    required this.entity,
    required this.onTap,
  });
  final FileSystemEntity entity;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        elevation: 0.5,
        backgroundColor: colorScheme.surfaceContainer,
        foregroundColor: colorScheme.onSurface.withValues(alpha: 0.9),
        padding: const EdgeInsets.all(4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(),
          EntityIcon(entity),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
            child: Text(
              entity.name,
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
