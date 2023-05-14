import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scadule/component/preferences.dart';

class FontPreferences extends StatefulWidget {
  const FontPreferences({super.key});

  @override
  State<FontPreferences> createState() => _FontPreferencesState();
}

class _FontPreferencesState extends State<FontPreferences> {
  late List<bool> fontPreferences;
  final controller = Get.put(Preferences());

  @override
  void initState() {
    super.initState();
    fontPreferences = [true, false];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              Preferences().saveFontValue(true);
              showAlertDialog();
            });
          },
          child: Padding(
            // 컨테이너 박스의 위치 조정
            padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
            child: Container(
              // 라인 하나를 컨테이너로 지정
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), // 모서리 둥글게
                  color: context.theme.colorScheme.surface),
              child: Padding(
                // 컨테이너 안쪽 텍스트와 체크박스 위치 조정
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15.0), // 박스 상단 사이즈
                    Row(
                      children: [
                        Text(
                          '폰트 1',
                          style: TextStyle(
                            fontWeight: FontWeight.bold, // 텍스트 스타일 볼드
                            fontSize: 16.0, // 텍스트 사이즈
                            fontStyle: Preferences().loadFontValue()
                                ? FontStyle.normal
                                : FontStyle.italic,
                          ),
                        ),
                        Expanded(
                          // Row 위젯 공간을 사용함
                          child: Align(
                            // Row 안에서의 위치 조정
                            alignment: Alignment.centerRight, // 우측으로 정렬
                            child: Container(
                              child: Preferences().loadFontValue()
                                  ? const Icon(
                                      Icons.check,
                                      size: 20.0,
                                      // color: Colors.white,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15.0), // 박스 하단 사이즈
                  ],
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              Preferences().saveFontValue(false);
              showAlertDialog1();
            });
          },
          child: Padding(
            // 컨테이너 박스의 위치 조정
            padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
            child: Container(
              // 라인 하나를 컨테이너로 지정
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), // 모서리 둥글게
                  color: context.theme.colorScheme.surface),
              child: Padding(
                // 컨테이너 안쪽 텍스트와 체크박스 위치 조정
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15.0), // 박스 상단 사이즈
                    Row(
                      children: [
                        Text(
                          '폰트 2',
                          style: TextStyle(
                            fontWeight: FontWeight.bold, // 텍스트 스타일 볼드
                            fontSize: 16.0, // 텍스트 사이즈

                            fontStyle: Preferences().loadFontValue()
                                ? FontStyle.normal
                                : FontStyle.italic,
                          ),
                        ),
                        Expanded(
                          // Row 위젯 공간을 사용함
                          child: Align(
                            // Row 안에서의 위치 조정
                            alignment: Alignment.centerRight, // 우측으로 정렬
                            child: Container(
                              child: !Preferences().loadFontValue()
                                  ? const Icon(
                                      Icons.check,
                                      size: 20.0,
                                      // color: Colors.white,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15.0), // 박스 하단 사이즈
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: context.theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('적용 되었습니다.'),
          content: const Text('폰트1'),
          actions: [
            ElevatedButton(
                onPressed: () {
                  controller.result.value = true;
                },
                child: Text('OK'))
          ],
        );
      },
    );
  }

  showAlertDialog1() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: context.theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('적용 되었습니다.'),
          content: const Text('폰트2'),
          actions: [
            ElevatedButton(
                onPressed: () {
                  controller.result.value = false;
                },
                child: Text('OK'))
          ],
        );
      },
    );
  }
}
