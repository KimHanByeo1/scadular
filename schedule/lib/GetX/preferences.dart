import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:scadule/GetX/themes.dart';

// 사용자가 설정한 테마 데이터 저장
// 리빌드시 변경 값 저장

class Preferences extends GetxController {
  final _getStorage = GetStorage();
  var themeKey = 'isDarkMode';
  final switchKey = 'switch_value';
  final screenModeKey = 'screen_mode_value';

  ThemeMode getThemeMode() {
    return isSaveDarkMode() == 'dark'
        ? ThemeMode.dark
        : isSaveDarkMode() == 'light'
            ? ThemeMode.light
            : ThemeMode.system;
  }

  String isSaveDarkMode() {
    return _getStorage.read(themeKey) ?? '';
  }

  saveThemeMode(String isDarkMode) {
    _getStorage.write(themeKey, isDarkMode);
  }

  changeThemeMode(String color) {
    if (color == 'system') {
      systemMode();
    } else {
      Get.changeTheme(color == 'dark' ? Themes().darkMode : Themes().lightMode);
      saveThemeMode(color == 'dark' ? 'dark' : 'light');
    }
  }

  systemMode() {
    bool isDark =
        // ignore: deprecated_member_use
        SchedulerBinding.instance.window.platformBrightness == Brightness.dark;
    Get.changeTheme(isDark ? Themes().darkMode : Themes().lightMode);
    saveThemeMode('system');
  }

  // 스위치 값을 저장합니다.
  saveSwitchValue(bool value) {
    _getStorage.write(switchKey, value);
  }

  // 스위치 값을 불러옵니다.
  bool loadSwitchValue() {
    return _getStorage.read(switchKey) ?? false;
  }

  // saveFontValue(bool value) {
  //   _getStorage.write(fontKey, value);
  //   result.value = value;
  // }

  // bool loadFontValue() {
  //   return _getStorage.read(fontKey) ?? false;
  // }
}
