import 'dart:io';
import 'package:filemanager/helper/app_controller.dart';
import 'package:flutter/material.dart';

class BreadCrumbBar extends StatelessWidget {
  const BreadCrumbBar({super.key, required this.currentEntity});
  final FileSystemEntity? currentEntity;
  static final controller = AppController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: currentEntity == null
          ? SizedBox()
          : Row(
              children: currentEntity!.uri.pathSegments
                  .where((e) => e.isNotEmpty)
                  .map((e) => TextButton.icon(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 4)),
                        icon: Icon(Icons.keyboard_arrow_right_outlined),
                        label: Text(e),
                      ))
                  .toList(),
            ),
    );
  }
}
