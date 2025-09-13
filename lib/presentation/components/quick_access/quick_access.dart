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

    /*
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
     */

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
