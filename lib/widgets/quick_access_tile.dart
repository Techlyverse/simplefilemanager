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
      //width: 200,
      width: (context.widthOfScreen / 3.1).clamp(210, 290),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: colorOfTile,
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
          Text(title, style: TextStyle(color: context.colorScheme.onSurface),),
        ],
      ),
    );
  }
}
