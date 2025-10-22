import 'dart:io';
import 'package:filemanager/data/extensions/context_extension.dart';
import 'package:filemanager/globals.dart';
import 'package:filemanager/helper/app_controller.dart';
import 'package:flutter/material.dart';

class BreadCrumbBar extends StatelessWidget {
  const BreadCrumbBar({Key? key, required this.currentEntity}): super(key: key);
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
                  .toList()
                  .asMap()
                  .entries
                  .map((entry) {
                final index = entry.key;
                final segment = entry.value;

                if (isAndroid && (index == 0 || index == 1)) {
                  return const SizedBox.shrink();
                }

                if (index == 2 && isAndroid) {
                  return TextButton.icon(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      primary: context.colorScheme.primary,
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      textStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    icon: Icon(Icons.keyboard_arrow_right_outlined),
                    label: Text("Home"),
                  );
                }

                return TextButton.icon(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    primary: context.colorScheme.primary,
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  icon: Icon(Icons.keyboard_arrow_right_outlined),
                  label: Text(segment),
                );
              }).toList(),
            ),
    );
  }
}
