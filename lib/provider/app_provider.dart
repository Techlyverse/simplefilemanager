import 'package:filemanager/preferences/preferences.dart';
import 'package:flutter/cupertino.dart';

class AppProvider extends ChangeNotifier {
  bool get showGrid => _showGrid;

  bool _showGrid = Preferences.getViewType();

  void updateViewType(bool value) {
    _showGrid = value;
    notifyListeners();
  }
}
