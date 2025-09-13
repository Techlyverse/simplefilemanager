import 'package:filemanager/helper/context_extension.dart';
import 'package:filemanager/model/quick_access_model.dart';
import 'package:flutter/material.dart';

import '../../../data/enums.dart';
import 'quick_access_tile.dart';

class QuickAccess extends StatelessWidget {
  const QuickAccess({super.key});

  @override
  Widget build(BuildContext context) {
    final LayoutType layoutType = context.viewType;

    switch (layoutType) {
      case LayoutType.mobile:
        return _mobileView();
      case LayoutType.tablet:
        return _tabletView();
      case LayoutType.desktop:
        return _desktopView();
    }
  }

  Widget _mobileView() {
    return GridView.builder(
      itemCount: directories.length,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 4,
      ),
      itemBuilder: (_, index) {
        return QuickAccessTile(
          icon: directories[index].image,
          title: directories[index].title,
        );
      },
    );
  }

  Widget _tabletView() {
    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: directories.map((e) {
          return QuickAccessTile(icon: e.image, title: e.title);
        }).toList(),
      ),
    );
  }

  Widget _desktopView() {
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: directories.map((e) {
          return QuickAccessTile(icon: e.image, title: e.title);
        }).toList(),
      ),
    );
  }
}

List<QuickAccessModel> directories = [
  QuickAccessModel(image: "assets/downloads.png", title: "Downloads"),
  QuickAccessModel(image: "assets/videos.png", title: "Videos"),
  QuickAccessModel(image: "assets/downloads.png", title: "Downloads"),
  QuickAccessModel(image: "assets/videos.png", title: "Videos"),
  QuickAccessModel(image: "assets/downloads.png", title: "Downloads"),
];
