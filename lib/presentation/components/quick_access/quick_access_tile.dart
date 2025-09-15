import 'package:filemanager/data/extensions/context_extension.dart';
import 'package:filemanager/helper/app_controller.dart';
import 'package:filemanager/model/quick_access_model.dart';
import 'package:flutter/material.dart';

class QuickAccessTile extends StatelessWidget {
  const QuickAccessTile({super.key, required this.quickAccessModel});
  final QuickAccessModel quickAccessModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        AppController().openDirectory(quickAccessModel.directory);
      },
      child: Container(
        width: (context.widthOfScreen / 3.1).clamp(210, 290),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
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
              style: Theme.of(context).textTheme.bodyLarge!,
            ),
          ],
        ),
      ),
    );
  }
}
