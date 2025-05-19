import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  const Preferences._();

  static late final SharedPreferences _prefs;
  static const _keyViewType = 'viewType';
  static const _keyAndroidSdk = 'androidSdk';

  static Future<void> initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setViewType(bool viewType) async => await _prefs.setBool(_keyViewType, viewType);
  static bool getViewType() => _prefs.getBool(_keyViewType) ?? true;

  static Future<void> setAndroidVersion(int sdk) async => await _prefs.setInt(_keyAndroidSdk, sdk);
  static int? getAndroidVersion() => _prefs.getInt(_keyAndroidSdk);


}
