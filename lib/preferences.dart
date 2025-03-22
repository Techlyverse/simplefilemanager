import 'package:get_storage/get_storage.dart';

class Preferences{
  Preferences._();

  static final _preferences = GetStorage();
  static const _keyViewType = 'viewType';
  static const _keyIsAndroid13 = 'isAndroid13';
  static const _keyIsReadAllowed = 'isReadAllowed';

  static Future<void> setViewType(bool viewType) async => await _preferences.write(_keyViewType, viewType);
  static bool getViewType() => _preferences.read(_keyViewType) ?? true;

  static Future<void> setAndroidVersion(bool isAndroid13) async => await _preferences.write(_keyIsAndroid13, isAndroid13);
  static bool? getAndroidVersion() => _preferences.read(_keyIsAndroid13);

  static Future<void> setReadPermission(bool isReadAllowed) async => await _preferences.write(_keyIsReadAllowed, isReadAllowed);
  static bool? getReadPermission() => _preferences.read(_keyIsReadAllowed);
}