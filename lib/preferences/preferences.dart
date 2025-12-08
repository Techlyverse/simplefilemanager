import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  const Preferences._();

  static late final SharedPreferences _prefs;
  static const _keyViewType = 'viewType';
  static const _keyAndroidSdk = 'androidSdk';
  static const _keyRootDirPaths = 'rootDirPaths';
  static const _keyQuickAccessDirPaths = 'rootQuickAccessDirPaths';

  static Future<void> initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setViewType(bool showGridView) async => await _prefs.setBool(_keyViewType, showGridView);
  static bool getViewType() => _prefs.getBool(_keyViewType) ?? true;

  static Future<void> setAndroidVersion(int sdk) async => await _prefs.setInt(_keyAndroidSdk, sdk);
  static int? getAndroidVersion() => _prefs.getInt(_keyAndroidSdk);

  // static Future<void> setRootDirPaths(List<String> paths) async => await _prefs.setStringList(_keyRootDirPaths, paths);
  // static List<String>? getRootDirPaths() => _prefs.getStringList(_keyRootDirPaths);
  //
  // static Future<void> setQuickAccessDirPaths(List<String> paths) async => await _prefs.setStringList(_keyQuickAccessDirPaths, paths);
  // static List<String>? getQuickAccessDirPaths() => _prefs.getStringList(_keyQuickAccessDirPaths);
}
