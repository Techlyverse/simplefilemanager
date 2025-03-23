import 'package:filemanager/provider/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Column(
        children: [
          SwitchListTile(
            title: Text("Show grid view"),
            value: provider.showGrid,
            onChanged: (value) {
              provider.updateViewType(value);
            },
          ),
        ],
      ),
    );
  }
}
