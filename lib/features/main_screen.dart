import 'package:filemanager/features/directory/directory_page.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DirectoryPage(),
      // body: Row(
      //   children: [
      //     if (!context.isMobile) QuickAccess(),
      //     Expanded(
      //       child: Column(
      //         children: [
      //           if (context.isMobile) QuickAccess(),
      //           Expanded(child: DirectoryPage())
      //         ],
      //       ),
      //     )
      //   ],
      // ),
    );
  }
}
