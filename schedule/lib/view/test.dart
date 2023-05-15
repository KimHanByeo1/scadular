import 'package:flutter/material.dart';
import 'package:scadule/component/calendarStyle.dart';
import 'package:scadule/model/model.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:get/get.dart';

class BottomCalendar extends StatefulWidget {
  const BottomCalendar({super.key});

  @override
  State<BottomCalendar> createState() => _BottomCalendarState();
}

class _BottomCalendarState extends State<BottomCalendar> {
  DateTime _focusedDay = DateTime.now(); // 오늘날짜
  final controller = Get.put(Model());
  DateTime? saveStartDate;
  late int num;
  DateTime? _selectedDay; // 선택한 날짜

  @override
  void initState() {
    super.initState();
    num = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        child: TableCalendar(
          rowHeight: MediaQuery.of(context).size.height * 0.048,
          locale: 'ko_KR',
          // 출력할 달력의 최대 한도
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          rangeStartDay: controller.rangeStart.value,
          rangeEndDay: controller.rangeEnd.value,

          // 달력을 보여줄 때 기준이 되는 날짜 - 현재 날짜로 설정
          focusedDay: _focusedDay,

          // 선택한 날짜에 마커 표시
          selectedDayPredicate: (day) {
            return isSameDay(controller.selectedDay.value, day);
          },

          calendarStyle: CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: Model.calendarCategory == '다중'
                  ? Colors.transparent
                  : const Color.fromARGB(255, 110, 183, 243),
              shape: BoxShape.circle,
            ),
            rangeStartDecoration: const BoxDecoration(
              color: Color.fromARGB(255, 110, 183, 243),
              shape: BoxShape.circle,
            ),
            rangeEndDecoration: const BoxDecoration(
              color: Color.fromARGB(255, 110, 183, 243),
              shape: BoxShape.circle,
            ),
            rangeHighlightColor:
                const Color.fromARGB(255, 110, 183, 243).withOpacity(0.4),
          ),

          // Day 클릭 이벤트
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              controller.selectedDay.value = selectedDay;
              _focusedDay = focusedDay;
              if (Model.calendarCategory == '하루') {
                controller.selectedDay.value = selectedDay;
                num = 0;
              } else if (Model.calendarCategory == '기간') {
                if (num % 2 == 0) {
                  saveStartDate = selectedDay;
                } else {
                  if (changeType(selectedDay) < changeType(saveStartDate!)) {
                    controller.rangeEnd.value = saveStartDate!;
                    controller.rangeStart.value = selectedDay;
                  } else {
                    controller.rangeStart.value = saveStartDate!;
                    controller.rangeEnd.value = selectedDay;
                  }
                }
                num++;
              } else if (Model.calendarCategory == '다중') {
                // 다중 선택
                setState(() {
                  // 리스트가 비어있으면 무조건 추가
                  if (controller.markers.isEmpty) {
                    controller.markers.add(selectedDay);
                  } else {
                    // 선택 날짜를 리스트 안의 데이터와 비교해서 같은 날이 있으면 삭제
                    if (controller.markers.contains(selectedDay)) {
                      controller.markers.remove(selectedDay);
                    } else {
                      // 없으면 추가
                      controller.markers.add(selectedDay);
                    }
                  }
                });
              }
              if (num == 3) {
                controller.rangeStart.value = DateTime.now();
                controller.rangeEnd.value = DateTime.now();
                num = 1;
                saveStartDate = selectedDay;
              }
            });
          },

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
            markerBuilder: (context, date, events) {
              return Obx(() {
                return ListView.builder(
                  itemCount: controller.markers.length,
                  itemBuilder: (context, index) {
                    if (controller.markers[index].toString().substring(0, 10) ==
                        date.toString().substring(0, 10)) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 30,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.4),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container(
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                      );
                    }
                  },
                );
              });
            },
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
