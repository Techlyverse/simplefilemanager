import 'dart:io';
import 'package:filemanager/data/extensions/context_extension.dart';
import 'package:filemanager/helper/app_controller.dart';
import 'package:flutter/material.dart';

class BreadCrumbBar extends StatelessWidget {
  const BreadCrumbBar({super.key, required this.uri});
  final Uri? uri;
  static final controller = AppController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: uri == null
          ? SizedBox()
          : Row(
              children: uri!.pathSegments
                  .where((e) => e.isNotEmpty)
                  .toList()
                  .asMap()
                  .entries
                  .map((entry) {
                    final index = entry.key;
                    final segment = entry.value;

                    if (Platform.isAndroid && (index == 0 || index == 1)) {
                      return const SizedBox.shrink();
                    }

                    if (index == 2 && Platform.isAndroid) {
                      return TextButton.icon(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: context.colorScheme.primary,
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
                        foregroundColor: context.colorScheme.primary,
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        textStyle: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      icon: Icon(Icons.keyboard_arrow_right_outlined),
                      label: Text(segment),
                    );
                  })
                  .toList(),
            ),
    );
  }
}
