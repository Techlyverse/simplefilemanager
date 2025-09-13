import 'dart:io';
import 'package:flutter/material.dart';
import '../../../helper/app_controller.dart';

class BreadCrumbBar extends StatelessWidget {
  const BreadCrumbBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ValueListenableBuilder<FileSystemEntity?>(
        //valueListenable: AppController().currentEntity,
        valueListenable: AppController().fileSystemEntityNotifier,
        builder: (_, entity, __) {
          if (entity == null) return SizedBox();
          return Row(
            children: entity.uri.pathSegments
                .where((e) => e.isNotEmpty)
                .map((e) => TextButton.icon(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 4)),
                      icon: Icon(Icons.keyboard_arrow_right_outlined),
                      label: Text(e),
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}
