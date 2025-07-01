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
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double factor = constraints.biggest.shortestSide;
        double size = factor * 0.5;
        double fontSize = size * 0.08;
        double borderRadius = size * 0.08;
        final double padding = size * 0.05;
        double spacing = size * 0.03;
        return Padding(
          padding: EdgeInsets.all(padding * 2),
          child: SizedBox(
            width: size,
            height: size,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                elevation: 0.5,
                backgroundColor: colorScheme.surfaceContainer,
                foregroundColor: colorScheme.onSurface.withValues(alpha: 0.9),
                padding: EdgeInsets.all(padding),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: spacing,),
                  EntityIcon(entity),
                  Padding(
                    padding: EdgeInsets.fromLTRB(padding, 0, padding, padding*2),
                    child: Text(
                      entity.name,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: fontSize *1.5, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },

    );
  }
}
