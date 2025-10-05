import 'package:filemanager/data/extensions/context_extension.dart';
import 'package:filemanager/helper/app_controller.dart';
import 'package:filemanager/model/quick_access_model.dart';
import 'package:flutter/material.dart';

class QuickAccessTile extends StatelessWidget {
  const QuickAccessTile({super.key, required this.quickAccessModel});
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
          foregroundColor: context.colorScheme.onSurfaceVariant,
          backgroundColor: context.colorScheme.surfaceContainerLowest,
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
          side: BorderSide(color: context.colorScheme.surfaceContainerHighest),
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
            Text(
              quickAccessModel.title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
