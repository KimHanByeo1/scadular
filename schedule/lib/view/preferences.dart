import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scadule/component/preferences.dart';
import 'package:scadule/widget/preferences/app_font.dart';
import 'package:scadule/widget/preferences/screen_mode.dart';
import 'package:scadule/widget/preferences/starting_day_of_week.dart';

// 환경설정 페이지
// Getx 라이브러리를 통하여 테마를 변경할 수 있음.

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  final controller = Get.put(Preferences());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.colorScheme.background,
        foregroundColor: context.theme.colorScheme.outline,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
          ), // 뒤로가기 아이콘 추가
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Container(
        color: context.theme.colorScheme.background,
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Obx(
                    () => Text(
                      '설정',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        fontStyle: controller.result.value
                            ? FontStyle.normal
                            : FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 10),
                  child: Text(
                    '화면 모드',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: Preferences().loadFontValue()
                          ? FontStyle.normal
                          : FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
            const ScreenMode(),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 20, 0, 10),
                  child: Text(
                    '캘린더 설정',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: Preferences().loadFontValue()
                          ? FontStyle.normal
                          : FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
            const StartingDayOfWeek(),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 20, 0, 10),
                  child: Text(
                    '폰트 설정',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: Preferences().loadFontValue()
                          ? FontStyle.normal
                          : FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
            const FontPreferences(),
          ],
        ),
      ),
    );
  }
}
