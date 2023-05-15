import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:scadule/component/preferences.dart';
import 'package:scadule/component/themes.dart';
import 'package:scadule/view/navigation.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: Themes().lightMode,
      darkTheme: Themes().darkMode,
      themeMode: Preferences().getThemeMode(),
      debugShowCheckedModeBanner: false,
      home: const NavigationPage(),
    );
  }
}
