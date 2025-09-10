import 'package:filemanager/helper/app_controller.dart';
import 'package:filemanager/helper/context_extension.dart';
import 'package:filemanager/presentation/components/appbar.dart';
import 'package:filemanager/presentation/components/breadcrumb/bread_crumb_bar.dart';
import 'package:flutter/material.dart';

import '../data/enums.dart';
import 'components/directory/directory_page.dart';
import 'components/quick_access/quick_access.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});
  static final controller = AppController();

  @override
  Widget build(BuildContext context) {
    final ViewType viewType = context.viewType;

    return Scaffold(
      appBar: appBar(context),
      body: Row(
        children: [
          if (viewType != ViewType.mobile) QuickAccess(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (viewType != ViewType.desktop) BreadCrumbBar(),
                // TODO: add bool flag to check isRootDirectory/Homepage or directory page
                /// show quick access only in homepage
                if (viewType == ViewType.mobile) QuickAccess(),
                Expanded(child: const DirectoryPage()),
              ],
            ),
          )
        ],
      ),
    );
  }
}
