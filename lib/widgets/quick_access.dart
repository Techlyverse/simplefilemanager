import 'package:filemanager/helper/context_extension.dart';
import 'package:filemanager/model/quick_access_model.dart';
import 'package:filemanager/widgets/quick_access_tile.dart';
import 'package:flutter/material.dart';

class QuickAccess extends StatelessWidget {
  const QuickAccess({super.key});

  @override
  Widget build(BuildContext context) {
    return !context.isMobile
        ? SizedBox(
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: directories.map((e) {
                return QuickAccessTile(icon: e.image, title: e.title);
              }).toList(),
            ),
          )
        : Wrap(
            children: directories.map((e) {
            return QuickAccessTile(icon: e.image, title: e.title);
          }).toList());
  }
}

List<QuickAccessModel> directories = [
  QuickAccessModel(image: "assets/downloads.png", title: "Downloads"),
  QuickAccessModel(image: "assets/videos.png", title: "Videos"),
  QuickAccessModel(image: "assets/downloads.png", title: "Downloads"),
  QuickAccessModel(image: "assets/videos.png", title: "Videos"),
  QuickAccessModel(image: "assets/downloads.png", title: "Downloads"),
];
