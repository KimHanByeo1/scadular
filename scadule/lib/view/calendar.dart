import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:scadule/component/addSchedule.dart';
import 'package:scadule/component/calendarStyle.dart';
import 'package:scadule/component/eventCard.dart';
import 'package:scadule/controller/controller.dart';
import 'package:scadule/controller/select_schedule_controller.dart';
import 'package:scadule/model/insert_data_model.dart';
import 'package:scadule/model/model.dart';
import 'package:scadule/service/schedule_services.dart';
import 'package:scadule/widget/addSchedule/bottomWidget.dart';
import 'package:scadule/widget/addSchedule/calendar.dart';
import 'package:scadule/widget/addSchedule/contentTextField.dart';
import 'package:scadule/widget/addSchedule/titleTextField.dart';
import 'package:scadule/widget/addSchedule/topText.dart';
import 'package:scadule/widget/todayEvent/button.dart';
import 'package:scadule/widget/todayEvent/eventContents.dart';
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

                    eventLoader: _listOfDayEvents,

                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      // formatButtonDecoration:
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
                AddSchedule().addSchedule(context);
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

  // 필요 없을 거 같음
  Map<String, List> mySelectedEvents = {};
  List _listOfDayEvents(DateTime dateTime) {
    if (mySelectedEvents[DateFormat("yyyy-MM-dd").format(dateTime)] != null) {
      return mySelectedEvents[DateFormat("yyyy-MM-dd").format(dateTime)]!;
    } else {
      return [];
    }
  }
}
