import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:scadule/component/addSchedule.dart';
import 'package:scadule/component/calendarStyle.dart';
import 'package:scadule/widget/calendar/todayEvent/eventCard.dart';
import 'package:scadule/GetX/preferences.dart';
import 'package:scadule/controller/controller.dart';
import 'package:scadule/controller/select_schedule_controller.dart';
import 'package:scadule/model/insert_data_model.dart';
import 'package:scadule/model/model.dart';
import 'package:scadule/model/schedule.dart';
import 'package:scadule/service/schedule_services.dart';
import 'package:scadule/widget/calendar/todayEvent/button.dart';
import 'package:scadule/widget/calendar/todayEvent/progressBar.dart';
import 'package:scadule/widget/calendar/todayEvent/title.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:get/get.dart';

// 네비게이션바 두 번째 아이콘 클릭시 나오는 화면
// TableCalendar 라이브러리 사용
// 날짜 클릭 시 AlertDialog로 일정 관리
// 일정 추가하기 버튼 클릭 시 BottomSheet로 원하는 날짜에 일정 추가하기
// 각종 카테고리를 이용하여 일정을 추가 관리할 수 있음

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar>
    with SingleTickerProviderStateMixin {
  DateTime _focusedDay = DateTime.now(); // 오늘날짜
  DateTime? _selectedDay; // 선택한 날짜

  final FocusNodeObserverController getController =
      Get.put(FocusNodeObserverController());

  final controller = Get.put(ScheduleController());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Schedule>>(
      stream: ScheduleServices.getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 데이터를 가져오는 중이므로 로딩 스피너 또는 로딩 상태를 보여줄 수 있습니다.
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const CircularProgressIndicator();
        } else {
          // 데이터를 정상적으로 가져온 경우 TableCalendar를 생성하여 반환합니다.
          final schedules = snapshot.data ?? [];
          return KeyboardSizeProvider(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: context.theme.colorScheme.background,
              body: Consumer<ScreenHeight>(
                builder: (context, value, child) {
                  return SafeArea(
                    child: Container(
                      color: context.theme.colorScheme.background,
                      child: SingleChildScrollView(
                        child: TableCalendar(
                          rowHeight: MediaQuery.of(context).size.height * 0.125,
                          locale: 'ko_KR',
                          startingDayOfWeek: Preferences().loadSwitchValue()
                              ? StartingDayOfWeek.monday
                              : StartingDayOfWeek.sunday,
                          // 출력할 달력의 최대 한도
                          firstDay: DateTime.utc(2020, 1, 1),
                          lastDay: DateTime.utc(2030, 12, 31),

                          // 달력을 보여줄 때 기준이 되는 날짜 - 현재 날짜로 설정
                          focusedDay: _focusedDay,

                          // 선택한 날짜에 마커 표시
                          selectedDayPredicate: (day) {
                            return isSameDay(_selectedDay, day);
                          },

                          // Day 클릭 이벤트
                          onDaySelected: (selectedDay, focusedDay) {
                            // setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                            StaticModel.selectedDay = selectedDay;
                            InsertDataModel.startDate =
                                selectedDay.toString().substring(0, 11);
                            // });

                            controller.getSelectedDateData();

                            // // 날짜 클릭 시 해당 날짜에 대한 정보를 showDialog로 출력
                            clickEvent(selectedDay);
                          },

                          // 내가 선택한 날짜
                          onPageChanged: (focusedDay) {
                            _focusedDay = focusedDay;
                          },

                          eventLoader: (day) {
                            return _getEventsForDay(day, schedules);
                          },

                          headerStyle: const HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                          ),

                          calendarBuilders: CalendarBuilders(
                            dowBuilder: (context, date) => Dow(
                              text: CalendarStyles.convertWeekdayToStringValue(
                                  date.weekday),
                              color: CalendarStyles.dayToColor(date, context),
                              fontSize: 13.0,
                            ),
                            defaultBuilder: (context, date, _) => Day(
                              date: date,
                              color: CalendarStyles.dayToColor(date, context),
                              isToday: false,
                            ),
                            outsideBuilder: (context, date, _) => Day(
                              date: date,
                              color: CalendarStyles.dayToColor(date, context,
                                  opacity: 0.3),
                              isToday: false,
                            ),
                            markerBuilder: (context, date, events) {
                              if (events.isNotEmpty) {
                                return Positioned(
                                  top: 80,
                                  left: 22,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: context
                                          .theme.colorScheme.onBackground,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    width: 12,
                                    height: 12,
                                  ),
                                );
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }

  List<Schedule> _getEventsForDay(DateTime day, schedules) {
    final events = _getEventsMap(schedules);
    final date = DateTime(day.year, day.month, day.day).toLocal();
    return events[date] ?? [];
  }

  Map<DateTime, List<Schedule>> _getEventsMap(List<Schedule> schedules) {
    final Map<DateTime, List<Schedule>> events = {};
    for (final schedule in schedules) {
      if (schedule.startDate.isNotEmpty) {
        final date =
            DateTime.parse(schedule.startDate.toString().trim()).toLocal();
        if (events[date] == null) {
          events[date] = [schedule];
        } else {
          events[date]!.add(schedule);
        }
      }
    }
    return events;
  }

  void clickEvent(DateTime selectedDay) {
    showDialog(
      context: context,
      builder: (context) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            AlertDialog(
              backgroundColor: context.theme.colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Column(
                children: [
                  TopTitle(),
                ],
              ),
              content: SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                width: 0,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ProgressBar(),
                      EventCard(),
                    ],
                  ),
                ),
              ),
              actions: [
                AddScheduleButton(
                  onPressed: () {
                    var selectedDay = _selectedDay.toString().substring(0, 10);
                    setState(() {
                      Model.calendarCategory = '하루';
                    });
                    AddSchedule().addSchedule(
                      context,
                      null,
                      null,
                      ['add', 'calendar'],
                      selectedDay.toString(),
                    );
                    Model.height = 0.583;
                    getController.focusNodeObserver.value = false;
                    getController.contentOnOff.value = false;
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
