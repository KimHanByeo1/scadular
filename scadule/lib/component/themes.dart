import 'package:flutter/material.dart';

class Themes {
  final ThemeData darkMode = ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme(
      onPrimary: CommonColors.onWhite, //required
      onSecondary: CommonColors.onWhite, //required
      primary: DarkColors.orange1, // point color1
      secondary: DarkColors.blue, // point color3
      background: DarkColors.gray1, // app backgound
      surface: DarkColors.gray2, // card background
      outline: DarkColors.gray3, // card line or divider
      surfaceVariant: DarkColors.gray4, // disabled
      onSurface: DarkColors.important, //text3
      onBackground: DarkColors.important, //text1
      error: CommonColors.red, // danger
      onError: DarkColors.basic, // no use
      brightness: Brightness.light,
    ),
  );

  final ThemeData lightMode = ThemeData.light().copyWith(
    brightness: Brightness.light,
    colorScheme: const ColorScheme(
      onPrimary: CommonColors.onWhite, //required
      onSecondary: CommonColors.onWhite, //required
      primary: LightColors.orange1, // point color1
      secondary: LightColors.blue, // point color3
      background: LightColors.gray1, // app backgound
      surface: LightColors.gray2, // card background
      outline: LightColors.gray3, // card line or divider
      surfaceVariant: LightColors.gray4, // disabled
      onSurface: LightColors.gray5, // text3
      onBackground: LightColors.important, //text1
      error: CommonColors.red, // danger

      onError: LightColors.basic, //no use
      brightness: Brightness.light,
    ),
  );
}

class LightColors {
  // color define
  static const Color basic = Color(0xFFFFFFFF);
  static const Color orange1 = Color(0xFF2D2D2D);
  static const Color blue = Color(0xFF3485FF);
  static const Color gray1 = Color(0xFFF5F5F5);
  static const Color gray2 = Color(0xFFFFFFFF);
  static const Color gray3 = Color(0xFF767676);
  static const Color gray4 = Color(0xFFDFE1E4);
  static const Color gray5 = Color(0xFFEEEEEF);
  static const Color important = Color(0xFF2D2D2D);
}

class DarkColors {
  // color define

  static const Color basic = Color(0xFF2D2D2D);
  static const Color orange1 = Color(0xFFEF8E1D);
  // static const Color orange2 = Color(0xFFFFB55E);
  static const Color blue = Color.fromARGB(255, 204, 206, 255);
  static const Color gray1 = Color(0xFF1A1A1A);
  static const Color gray2 = Color(0xFF2B2B2B);
  static const Color gray3 = Color(0xFF767676);
  static const Color gray4 = Color(0xFF4D4D4D);
  static const Color important = Color(0xFFFFFFFF);
}

// 테마에 따라 바뀌지 않는 컬러
class CommonColors {
  // color define
  static const Color red = Colors.red;
  static const Color blue = Color(0x00beefff);
  static const Color yellow = Color(0xFFFAD113);
  static const Color green = Color(0xFF8ED9AB);

  static const Color onWhite = Color(0xFFFFFFFF);
  static const Color onBlack = Color(0xFF2D2D2D);
}
