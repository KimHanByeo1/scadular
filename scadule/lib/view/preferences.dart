import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scadule/widget/screen_mode.dart';

// 환경설정 페이지
// Getx 라이브러리를 통하여 테마를 변경할 수 있음.

class Preferences extends StatefulWidget {
  const Preferences({super.key});

  @override
  State<Preferences> createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
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
              children: const [
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
            const ScreenMode()
          ],
        ),
      ),
    );
  }
}
