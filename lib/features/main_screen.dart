import 'package:filemanager/helper/context_extension.dart';
import 'package:filemanager/widgets/quick_access.dart';
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
      body: Row(
        children: [
          if (!context.isMobile) QuickAccess(),
          Expanded(
            child: Column(
              children: [
                if (context.isMobile) QuickAccess(),
                Center(child: Text("hello"))
              ],
            ),
          )
        ],
      ),
    );
  }
}
