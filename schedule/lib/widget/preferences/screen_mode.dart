import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scadule/GetX/preferences.dart';

// 코드가 너무 길어서 환경설정 front는 class를 분리함

class ScreenMode extends StatefulWidget {
  const ScreenMode({super.key});

  @override
  State<ScreenMode> createState() => _ScreenModeState();
}

class _ScreenModeState extends State<ScreenMode> {
  late List<bool> screenColorMode;
  late bool startingDayOfWeek;

  @override
  void initState() {
    super.initState();
    screenColorMode = [false, false, true];
    startingDayOfWeek = false;
  }

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(DarkModeController());
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              screenColorMode = [true, false, false];
              Preferences().changeThemeMode('light');
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
                          '라이트 모드',
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
                              // decoration: BoxDecoration(
                              //   shape: BoxShape.circle,
                              //   color: screenColorMode[0]
                              //       ? Theme.of(context).colorScheme.secondary
                              //       : null,
                              //   border: Border.all(
                              //     color: screenColorMode[0]
                              //         ? Theme.of(context).colorScheme.secondary
                              //         : Colors.grey,
                              //     width: 1.0,
                              //   ),
                              // ),
                              child: screenColorMode[0]
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
              screenColorMode = [false, true, false];
              // Get.changeTheme(Themes().darkMode);
              Preferences().changeThemeMode('dark');
            });
          },
          child: Padding(
            // 컨테이너 박스의 위치 조정
            padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
            child: Container(
              // 라인 하나를 컨테이너로 지정
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), // 모서리 둥글게
                color: context.theme.colorScheme.surface,
              ),
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
                          '다크 모드',
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
                              // decoration: BoxDecoration(
                              //   shape: BoxShape.circle,
                              //   color: screenColorMode[1]
                              //       ? Theme.of(context).colorScheme.secondary
                              //       : null,
                              //   border: Border.all(
                              //     color: screenColorMode[1]
                              //         ? Theme.of(context).colorScheme.secondary
                              //         : Colors.grey,
                              //     width: 1.0,
                              //   ),
                              // ),
                              child: screenColorMode[1]
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
              screenColorMode = [false, false, true];
            });
          },
          child: Padding(
            // 컨테이너 박스의 위치 조정
            padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
            child: Container(
              // 라인 하나를 컨테이너로 지정
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), // 모서리 둥글게
                color: context.theme.colorScheme.surface,
                // color: Colors.white, // 박스 색상
              ),
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
                          '시스템 모드',
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
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: screenColorMode[2]
                                    ? Theme.of(context).colorScheme.secondary
                                    : null,
                                border: Border.all(
                                  color: screenColorMode[2]
                                      ? Theme.of(context).colorScheme.secondary
                                      : Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                              child: screenColorMode[2]
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
}
