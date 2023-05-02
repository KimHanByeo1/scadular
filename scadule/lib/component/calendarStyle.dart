import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

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
    return date.weekday == DateTime.sunday
        ? Colors.red[300]!.withOpacity(opacity)
        : date.weekday == DateTime.saturday
            ? Colors.blue[300]!.withOpacity(opacity)
            : context.theme.colorScheme.onBackground.withOpacity(opacity);
  }
}

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
        style: GoogleFonts.notoSans(color: color, fontSize: fontSize),
      ),
    );
  }
}

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
              style: GoogleFonts.notoSans(
                  color:
                      isToday ? context.theme.colorScheme.onBackground : color,
                  fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
