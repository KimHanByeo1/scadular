import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:intl/intl.dart';
import 'package:scadule/component/calendarStyle.dart';
import 'package:scadule/controller/controller.dart';
import 'package:scadule/model/model.dart';
import 'package:scadule/widget/addSchedule/bottomWidget.dart';
import 'package:scadule/widget/addSchedule/calendar.dart';
import 'package:scadule/widget/addSchedule/middleTextField.dart';
import 'package:scadule/widget/addSchedule/topText.dart';
import 'package:scadule/widget/todayEvent/button.dart';
import 'package:scadule/widget/todayEvent/content.dart';
import 'package:scadule/widget/todayEvent/title.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:get/get.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar>
    with SingleTickerProviderStateMixin {
  DateTime _focusedDay = DateTime.now(); // 오늘날짜
  DateTime? _selectedDay; // 선택한 날짜
  late double _keyboardHeight;
  late double _screenHeight;

  final FocusNodeObserverController getController =
      Get.put(FocusNodeObserverController());

  @override
  void initState() {
    super.initState();
    _keyboardHeight = 0.0;
    _screenHeight = 0.0;
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
                      });
                      // 날짜 클릭 시 해당 날짜에 대한 정보를 showDialog로 출력
                      clickEvent(selectedDay);
                      _keyboardHeight = value.keyboardHeight;
                      _screenHeight = value.screenHeight;
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

  void clickEvent(selectedDay) {
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
              SizedBox(
                height: 3,
              ),
              EventContent()
            ],
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            child: ListTile(
              title: Text(DateFormat.yMd('ko_KR').format(selectedDay)),
              trailing: const Icon(Icons.keyboard_arrow_down),
            ),
          ),
          actions: [
            AddScheduleButton(
              onPressed: () {
                addSchedule();
                Model.height = 0.583;
                getController.focusNodeObserver.value = false;
              },
            ),
          ],
        );
      },
    );
  }

  void addSchedule() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.theme.colorScheme.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AnimatedSize(
              duration: const Duration(milliseconds: 100),
              curve: Curves.linear, // 일정한 속도로 에니메이션 처리
              vsync: this, // 화면이 새로 그려지는 주기와 동일하게 업데이트함(불필요한 업데이트 X)
              // height: (MediaQuery.of(context).size.height * 0.6),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * Model.height,
                child: Column(
                  children: [
                    const TopText(),
                    const MiddleTextField(),
                    BottomWidget(stateSetter: setState),
                    const BottomCalendar(),
                  ],
                ),
              ),
            );
          },
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
