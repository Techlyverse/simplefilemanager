import 'package:filemanager/helper/context_extension.dart';
import 'package:flutter/material.dart';

class QuickAccessTile extends StatelessWidget {
  const QuickAccessTile({super.key, required this.icon, required this.title});
  final String icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.sizeOf(context);
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            icon,
            height: 28,
          ),
          SizedBox(width: 12),
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
