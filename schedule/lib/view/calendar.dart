import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:scadule/component/addSchedule.dart';
import 'package:scadule/component/calendarStyle.dart';
import 'package:scadule/component/eventCard.dart';
import 'package:scadule/component/preferences.dart';
import 'package:scadule/controller/controller.dart';
import 'package:scadule/controller/select_schedule_controller.dart';
import 'package:scadule/model/insert_data_model.dart';
import 'package:scadule/model/model.dart';
import 'package:scadule/model/schedule.dart';
import 'package:scadule/service/schedule_services.dart';
import 'package:scadule/widget/todayEvent/button.dart';
import 'package:scadule/widget/todayEvent/title.dart';
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

  List<Schedule> schedules = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    schedules = await ScheduleServices.getData() ?? [];
  }

  Map<DateTime, List<Schedule>> _getEventsMap(List<Schedule> schedules) {
    final Map<DateTime, List<Schedule>> events = {};
    for (final schedule in schedules) {
      print(schedule.startDate);
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

  List<Schedule> _getEventsForDay(DateTime day, List<Schedule> schedules) {
    final events = _getEventsMap(schedules);
    final date = DateTime(day.year, day.month, day.day).toLocal();
    return events[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
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
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        CalendarModel.selectedDay = selectedDay;
                        InsertDataModel.startDate =
                            selectedDay.toString().substring(0, 11);
                      });

                      controller.fetchData();

                      // 날짜 클릭 시 해당 날짜에 대한 정보를 showDialog로 출력
                      clickEvent(selectedDay);

                      // _keyboardHeight = value.keyboardHeight;
                      // _screenHeight = value.screenHeight;
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

                    // calendarStyle: CalendarStyle(
                    //     defaultTextStyle: TextStyle(
                    //       color: Colors.grey,
                    //     ),
                    //     weekendTextStyle: TextStyle(color: Colors.grey),
                    //     outsideDaysVisible: false,
                    //     todayDecoration: BoxDecoration(
                    //         color: Colors.transparent,
                    //         shape: BoxShape.circle,
                    //         border:
                    //             Border.all(color: Colors.green, width: 1.5)),
                    //     todayTextStyle: TextStyle(
                    //         fontWeight: FontWeight.bold, color: Colors.grey)),

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
                        final markers = <Widget>[];

                        if (events.isNotEmpty) {
                          final eventCount = events.length;
                          const maxVisibleCount = 3;

                          for (int i = 0;
                              i < eventCount && i < maxVisibleCount;
                              i++) {
                            markers.add(
                              Positioned(
                                bottom: i * 15.0, // 컨테이너 간격을 조절합니다.
                                left: 8,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 250, 166, 166),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  width: 40,
                                  height: 12,
                                  child: Text(
                                    schedules[i].startDate,
                                    style: TextStyle(
                                      fontSize: 5,
                                      fontStyle: Preferences().loadFontValue()
                                          ? FontStyle.normal
                                          : FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          if (eventCount > maxVisibleCount) {
                            markers.add(
                              Positioned(
                                top: maxVisibleCount * 16.0, // 컨테이너 간격을 조절합니다.
                                // left: 8,
                                child: Container(
                                  width: 20,
                                  height: 12,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "...",
                                    style: TextStyle(
                                      color: context
                                          .theme.colorScheme.onBackground,
                                      fontSize: 13,
                                      fontStyle: Preferences().loadFontValue()
                                          ? FontStyle.normal
                                          : FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        }

                        return Stack(
                          children: markers,
                        );
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

  void clickEvent(DateTime selectedDay) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: context.theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Column(
            children: const [
              TopTitle(),
            ],
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            width: 0,
            child: SingleChildScrollView(
              child: Column(
                children: const [
                  EventCard(),
                ],
              ),
            ),
          ),
          actions: [
            AddScheduleButton(
              onPressed: () {
                setState(() {
                  Model.calendarCategory = '하루';
                });
                AddSchedule().addSchedule(
                  context,
                  null,
                  null,
                  ['add', 'calendar'],
                );
                Model.height = 0.583;
                getController.focusNodeObserver.value = false;
                getController.contentOnOff.value = false;
              },
            ),
          ],
        );
      },
    );
  }
}
