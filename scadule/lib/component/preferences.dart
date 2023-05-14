import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:scadule/component/themes.dart';

// 사용자가 설정한 테마 데이터 저장
// 리빌드시 변경 값 저장

class Preferences extends GetxController {
  final _getStorage = GetStorage();
  final themeKey = 'isDarkMode';
  final switchKey = 'switch_value';
  final fontKey = 'fontKey';

  RxBool result = false.obs;

  ThemeMode getThemeMode() {
    return isSaveDarkMode() ? ThemeMode.dark : ThemeMode.light;
  }

  bool isSaveDarkMode() {
    return _getStorage.read(themeKey) ?? false;
  }

  saveThemeMode(bool isDarkMode) {
    _getStorage.write(themeKey, isDarkMode);
  }

  changeThemeMode(String color) {
    Get.changeTheme(color == 'dark' ? Themes().darkMode : Themes().lightMode);
    saveThemeMode(color == 'dark' ? true : false);
  }

  // 스위치 값을 저장합니다.
  saveSwitchValue(bool value) {
    _getStorage.write(switchKey, value);
  }

  // 스위치 값을 불러옵니다.
  bool loadSwitchValue() {
    return _getStorage.read(switchKey) ?? false;
  }

  saveFontValue(bool value) {
    print(result.value);
    _getStorage.write(fontKey, value);
    result.value = value;
    print(result.value);
  }

  bool loadFontValue() {
    return _getStorage.read(fontKey) ?? false;
  }
}
