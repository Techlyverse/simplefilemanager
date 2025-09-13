import 'package:filemanager/data/extensions/context_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CurDirectoryPathBar extends StatelessWidget {
  const CurDirectoryPathBar({super.key});

  @override
  Widget build(BuildContext context) {
    final EdgeInsetsGeometry myMargin = context.isMobile
        ? EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0)
        : EdgeInsets.zero;
    final double heightOfWidget = context.isMobile ? 50 : 40;
    return Flexible(
      child: Container(
        margin: myMargin,
        padding: EdgeInsets.symmetric(vertical: 2),
        height: heightOfWidget,
        //width: (context.widthOfScreen/ 1.6),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          color: context.colorScheme.onSecondary,
        ),
        child: Flexible(
          child: Row(
            children: [
              SizedBox(
                width: 8,
              ),
              Icon(Icons.place),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    "Current Directory Path will be displayed here",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: (context.widthOfScreen / 75).clamp(15, 20),
                        color: context.colorScheme.onSurface),
                  ),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Icon(Icons.more_vert)
            ],
          ),
        ),
      ),
    );
  }
}
