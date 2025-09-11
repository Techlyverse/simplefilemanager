import 'dart:io';
import 'package:flutter/material.dart';
import '../../../helper/app_controller.dart';

class BreadCrumbBar extends StatelessWidget {
  const BreadCrumbBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ValueListenableBuilder<Directory>(
        valueListenable: AppController().currentDirNotifier,
        builder: (_, dir, __) {
          return Row(
            children: dir.uri.pathSegments
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
