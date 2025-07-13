import 'package:filemanager/helper/context_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuickAccessTile extends StatelessWidget {
  const QuickAccessTile({super.key, required this.icon, required this.title});
  final String icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            icon,
            height: context.isMobile ? 45 : 30,
          ),
          SizedBox(width: 20),
          Text(title),
        ],
      ),
    );
  }
}
