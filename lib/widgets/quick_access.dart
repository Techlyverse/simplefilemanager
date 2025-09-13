import 'dart:io';
import 'dart:math';

import 'package:filemanager/globals.dart';
import 'package:filemanager/helper/context_extension.dart';
import 'package:filemanager/model/quick_access_model.dart';
import 'package:filemanager/widgets/quick_access_tile.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

class QuickAccess extends StatelessWidget {
  final List<Directory> dirInRoot;
  const QuickAccess({
    required this.dirInRoot,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return !context.isMobile
        ?
          Container(
            color: context.colorScheme.onSecondary,
            child: SizedBox(
                width: (context.widthOfScreen / 3.0).clamp(220, 300),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: (isAndroid ? directoriesMobile : directoriesNotMobile).map((e) {
                    final exists = dirInRoot.any(
                        (dir) => p.basename(dir.path).toLowerCase() == e.title.toLowerCase()
                    );
                    if (exists){
                      return QuickAccessTile(icon: e.image, title: e.title);
                    } else {
                      return const SizedBox.shrink();
                    }
                  }).toList(),
                ),
              ),
          )
        : SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(// make this wrap later
              children: (isAndroid ? directoriesMobile : directoriesNotMobile).map((e) {
                final exists = dirInRoot.any(
                        (dir) => p.basename(dir.path).toLowerCase() == e.title.toLowerCase()
                );
                if (exists){
                  return QuickAccessTile(icon: e.image, title: e.title);
                } else {
                  return const SizedBox.shrink();
                }
              }).toList()),
        );
  }
}

List<QuickAccessModel> directoriesMobile = [
  QuickAccessModel(image: "assets/videos.png", title: "Download"),
  QuickAccessModel(image: "assets/videos.png", title: "Pictures"),
  QuickAccessModel(image: "assets/videos.png", title: "Videos"),
  QuickAccessModel(image: "assets/videos.png", title: "Audio"),
  QuickAccessModel(image: "assets/videos.png", title: "Documents"),
  QuickAccessModel(image: "assets/videos.png", title: "Apps")
];

List<QuickAccessModel> directoriesNotMobile = [
  QuickAccessModel(image: "assets/videos.png", title: "Recent"),
  QuickAccessModel(image: "assets/videos.png", title: "Home"),
  QuickAccessModel(image: "assets/videos.png", title: "Documents"),
  QuickAccessModel(image: "assets/videos.png", title: "Downloads"),
  QuickAccessModel(image: "assets/videos.png", title: "Music"),
  QuickAccessModel(image: "assets/videos.png", title: "Picture"),
  QuickAccessModel(image: "assets/videos.png", title: "Videos"),
  QuickAccessModel(image: "assets/videos.png", title: "Trash")
];
