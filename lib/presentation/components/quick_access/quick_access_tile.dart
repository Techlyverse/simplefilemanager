import 'package:filemanager/helper/context_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuickAccessTile extends StatelessWidget {
  const QuickAccessTile({super.key, required this.icon, required this.title});
  final String icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorOfTile = isDarkMode? Colors.indigo.shade700 : Colors.indigo.shade100;
    return Container(
      width: (context.widthOfScreen / 3.1).clamp(210, 290),
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
            height: context.isMobile ? 45 : 30,
          ),
          SizedBox(width: 20),
          Text(title,overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyLarge?,),
        ],
      ),
    );
  }
}
