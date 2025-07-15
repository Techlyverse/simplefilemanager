import 'dart:math';

import 'package:filemanager/helper/context_extension.dart';
import 'package:filemanager/model/quick_access_model.dart';
import 'package:filemanager/widgets/quick_access_tile.dart';
import 'package:flutter/material.dart';

class QuickAccess extends StatelessWidget {
  const QuickAccess({super.key});

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
                  children: directories.map((e) {
                    return QuickAccessTile(icon: e.image, title: e.title);
                  }).toList(),
                ),
              ),
          )
        : SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(// make this wrap later
              children: directories.map((e) {
              return QuickAccessTile(icon: e.image, title: e.title);
            }).toList()),
        );
  }
}

List<QuickAccessModel> directories = [
  QuickAccessModel(image: "assets/videos.png", title: "Downloads"),
  QuickAccessModel(image: "assets/videos.png", title: "Videos"),
  QuickAccessModel(image: "assets/videos.png", title: "Downloads"),
  QuickAccessModel(image: "assets/videos.png", title: "Videos"),
  QuickAccessModel(image: "assets/videos.png", title: "Downloads"),
];
