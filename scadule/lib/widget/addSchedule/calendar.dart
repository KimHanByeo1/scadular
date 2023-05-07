import 'package:flutter/material.dart';
import 'package:scadule/component/calendarStyle.dart';
import 'package:scadule/model/insert_data_model.dart';
import 'package:scadule/model/model.dart';
import 'package:table_calendar/table_calendar.dart';

class BottomCalendar extends StatefulWidget {
  const BottomCalendar({super.key});

  @override
  State<BottomCalendar> createState() => _BottomCalendarState();
}

class _BottomCalendarState extends State<BottomCalendar> {
  DateTime _focusedDay = DateTime.now(); // 오늘날짜
  DateTime? _selectedDay; // 선택한 날짜
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  late int num;

  @override
  void initState() {
    super.initState();
    num = 0;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: TableCalendar(
        rowHeight: MediaQuery.of(context).size.height * 0.048,
        locale: 'ko_KR',
        // 출력할 달력의 최대 한도
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        rangeStartDay: _rangeStart,
        rangeEndDay: _rangeEnd,

        // 달력을 보여줄 때 기준이 되는 날짜 - 현재 날짜로 설정
        focusedDay: _focusedDay,
        // 선택한 날짜에 마커 표시
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },

        // Day 클릭 이벤트
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            // CalendarModel.selectedDay = selectedDay;
          });
          // _rangeStart = _focusedDay;
          if (Model.qwe == 0) {
            setState(() {
              if (!isSameDay(selectedDay, _selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  // CalendarModel.selectedDay = selectedDay;
                  InsertDataModel.startDate =
                      selectedDay.toString().substring(0, 11);
                  _focusedDay = focusedDay;
                });
              }
            });
          } else {
            setState(() {
              DateTime? replace;
              if (num % 2 == 0) {
                _rangeStart = selectedDay;
                _rangeEnd = null;
              } else {
                _rangeEnd = selectedDay;
                if (changeType(_rangeEnd!) < changeType(_rangeStart!)) {
                  replace = _rangeStart;
                  _rangeStart = _rangeEnd;
                  _rangeEnd = replace;
                }
              }
              num++;
            });
          }
        },

        // calendarStyle: CalendarStyle(
        //   selectedDecoration: BoxDecoration(
        //     color: Model.qwe == 0
        //         ? context.theme.colorScheme.background
        //         : context.theme.colorScheme.background,
        //     shape: Model.qwe == 0 ? BoxShape.circle : BoxShape.rectangle,
        //   ),
        //   rangeStartDecoration: BoxDecoration(
        //     color: Model.qwe == 1
        //         ? context.theme.colorScheme.background
        //         : context.theme.colorScheme.background,
        //     shape: Model.qwe == 1 ? BoxShape.circle : BoxShape.rectangle,
        //   ),
        //   rangeEndDecoration: BoxDecoration(
        //     color: Model.qwe == 1
        //         ? context.theme.colorScheme.background
        //         : context.theme.colorScheme.background,
        //     shape: Model.qwe == 1 ? BoxShape.circle : BoxShape.rectangle,
        //   ),
        //   rangeHighlightColor: Model.qwe == 1
        //       ? context.theme.colorScheme.background
        //       : context.theme.colorScheme.background,
        // ),

        // 내가 선택한 날짜
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),

        calendarBuilders: CalendarBuilders(
          dowBuilder: (context, date) => Dow(
            text: CalendarStyles.convertWeekdayToStringValue(date.weekday),
            color: CalendarStyles.dayToColor(date, context),
            fontSize: 15.0,
          ),
          defaultBuilder: (context, date, _) => Day(
            date: date,
            color: CalendarStyles.dayToColor(date, context),
            isToday: false,
          ),
          outsideBuilder: (context, date, _) => Day(
            date: date,
            color: CalendarStyles.dayToColor(date, context, opacity: 0.3),
            isToday: false,
          ),
        ),
      ),
    );
  }

  int changeType(DateTime selectedDay) {
    return int.parse(
        "${selectedDay.year}${selectedDay.month.toString().padLeft(2, '0')}${selectedDay.day.toString().padLeft(2, '0')}");
  }
}
