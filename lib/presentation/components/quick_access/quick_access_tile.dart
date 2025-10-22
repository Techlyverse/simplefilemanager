import 'package:filemanager/data/extensions/context_extension.dart';
import 'package:filemanager/helper/app_controller.dart';
import 'package:filemanager/model/quick_access_model.dart';
import 'package:flutter/material.dart';

class QuickAccessTile extends StatelessWidget {
  const QuickAccessTile({Key? key, required this.quickAccessModel})
      : super(key: key);
  final QuickAccessModel quickAccessModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: OutlinedButton(
        onPressed: () {
          AppController().openDirectory(quickAccessModel.directory);
        },
        style: OutlinedButton.styleFrom(
          elevation: 0,
          alignment: Alignment.centerLeft,
          primary: context.colorScheme.onSurface,
          backgroundColor:
              context.isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
          side: BorderSide(
            color: context.isDarkMode
                ? Colors.grey.shade600
                : Colors.grey.shade400,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              quickAccessModel.image,
              height: context.isMobile ? 45 : 30,
            ),
            SizedBox(width: 20),
            Flexible(
              child: Text(
                quickAccessModel.title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
