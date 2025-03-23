import 'package:file_manager/controller/file_manager_controller.dart';
import 'package:file_manager/file_manager.dart';
import 'package:filemanager/preferences/preferences.dart';
import 'package:flutter/cupertino.dart';

class AppProvider extends ChangeNotifier {
  //late FileManagerController fmc = FileManagerController();

  bool get showGrid => _showGrid;

  bool _showGrid = Preferences.getViewType();

  // void initFMC() {
  //   fmc = FileManagerController();
  // }

  void updateViewType(bool value) {
    _showGrid = value;
    notifyListeners();
  }
}
