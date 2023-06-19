import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scadule/GetX/preferences.dart';
import 'package:scadule/view/navigation.dart';
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
            Get.offAll(const NavigationPage());
          },
        ),
      ),
      body: Container(
        color: context.theme.colorScheme.background,
        child: const Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    '설정',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 10),
                  child: Text(
                    '화면 모드',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            ScreenMode(),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 20, 0, 10),
                  child: Text(
                    '캘린더 설정',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            StartingDayOfWeek(),
            // Row(
            //   children: [
            //     Padding(
            //       padding: EdgeInsets.fromLTRB(15, 20, 0, 10),
            //       child: Text(
            //         '폰트 설정',
            //         style: TextStyle(
            //           fontSize: 20,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // FontPreferences(),
          ],
        ),
      ),
    );
  }
}
