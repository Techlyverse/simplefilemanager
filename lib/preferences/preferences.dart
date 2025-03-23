import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  const Preferences._();

  static late final SharedPreferences _prefs;
  static const _keyViewType = 'viewType';
  static const _keyIsAndroid13 = 'isAndroid13';
  static const _keyIsReadAllowed = 'isReadAllowed';

  static Future<void> initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setViewType(bool viewType) async => await _prefs.setBool(_keyViewType, viewType);
  static bool getViewType() => _prefs.getBool(_keyViewType) ?? true;

  static Future<void> setAndroidVersion(bool isAndroid13) async => await _prefs.setBool(_keyIsAndroid13, isAndroid13);
  static bool? getAndroidVersion() => _prefs.getBool(_keyIsAndroid13);

  static Future<void> setReadPermission(bool isReadAllowed) async => await _prefs.setBool(_keyIsReadAllowed, isReadAllowed);
  static bool? getReadPermission() => _prefs.getBool(_keyIsReadAllowed);
}
