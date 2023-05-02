import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:scadule/component/themes.dart';

class ThemeService extends GetxController {
  final _getStorage = GetStorage();
  final storageKey = 'isDarkMode';

  ThemeMode getThemeMode() {
    return isSaveDarkMode() ? ThemeMode.dark : ThemeMode.light;
  }

  bool isSaveDarkMode() {
    return _getStorage.read(storageKey) ?? false;
  }

  saveThemeMode(bool isDarkMode) {
    _getStorage.write(storageKey, isDarkMode);
  }

  changeThemeMode(String color) {
    Get.changeTheme(color == 'dark' ? Themes().darkMode : Themes().lightMode);
    saveThemeMode(color == 'dark' ? true : false);
  }
}
