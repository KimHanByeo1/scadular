import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scadule/GetX/preferences.dart';

class CalendarStyles {
  static String convertWeekdayToStringValue(int weekDay) {
    switch (weekDay) {
      case 1:
        return '월';
      case 2:
        return '화';
      case 3:
        return '수';
      case 4:
        return '목';
      case 5:
        return '금';
      case 6:
        return '토';
      case 7:
        return '일';
    }
    return '';
  }

  static Color dayToColor(DateTime date, BuildContext context,
      {double opacity = 1}) {
    return date.weekday == DateTime.sunday // 일요일이면 빨강
        ? Colors.red[300]!.withOpacity(opacity)
        : date.weekday == DateTime.saturday // 토요일이면 파랑
            ? Colors.blue[300]!.withOpacity(opacity)
            // 나머지 검정 or 흰색
            : context.theme.colorScheme.onBackground.withOpacity(opacity);
  }
}

// 캘린더 1일 ~ 마지막일의 text와 textStyle 컴포넌트
class Dow extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  const Dow({
    super.key,
    required this.text,
    required this.color,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontStyle: Preferences().loadFontValue()
              ? FontStyle.normal
              : FontStyle.italic,
        ),
      ),
    );
  }
}

// 캘린더 주말 텍스트 색상 변경 컴포넌트(평일: 검정 or 흰색, 일요일: 빨강, 토요일: 파랑)
class Day extends StatelessWidget {
  final DateTime date;
  final Color color;
  final bool isToday;

  const Day({
    super.key,
    required this.date,
    required this.color,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    var backgroundColor = context.theme.colorScheme.background;
    // if (isToday) backgroundColor = context.theme.colorScheme.onBackground;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Center(
            child: Text(
              '${date.day}',
              style: TextStyle(
                color: isToday ? context.theme.colorScheme.onBackground : color,
                fontSize: 16,
                fontStyle: Preferences().loadFontValue()
                    ? FontStyle.normal
                    : FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
