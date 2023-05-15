import 'package:flutter/material.dart';
import 'package:scadule/component/preferences.dart';
import 'package:get/get.dart';

class StartingDayOfWeek extends StatefulWidget {
  const StartingDayOfWeek({super.key});

  @override
  State<StartingDayOfWeek> createState() => _StartingDayOfWeekState();
}

class _StartingDayOfWeekState extends State<StartingDayOfWeek> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
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
              // 컨테이너 안쪽 텍스트와 Switch 위치 조정
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 2), // 박스 상단 사이즈
                  Row(
                    children: [
                      Text(
                        '월요일 부터 시작',
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
                            child: Switch(
                              onChanged: (value) {
                                setState(() {
                                  Preferences().saveSwitchValue(value);
                                });
                              },
                              value: Preferences().loadSwitchValue()
                                  ? true
                                  : false,
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2), // 박스 하단 사이즈
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
