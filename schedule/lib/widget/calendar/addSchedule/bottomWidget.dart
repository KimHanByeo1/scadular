import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scadule/component/calendarStyle.dart';
import 'package:scadule/component/dateCalc.dart';
import 'package:scadule/controller/controller.dart';
import 'package:scadule/controller/select_schedule_controller.dart';
import 'package:scadule/model/insert_data_model.dart';
import 'package:scadule/model/model.dart';
import 'package:scadule/model/schedule.dart';

class BottomWidget extends StatefulWidget {
  final StateSetter stateSetter;
  final String? category;
  final String? startDate;
  final List<String>? result;
  final Schedule? scheduleList;

  const BottomWidget(
      this.category, this.startDate, this.result, this.scheduleList,
      {required this.stateSetter, Key? key})
      : super(key: key);

  @override
  State<BottomWidget> createState() => _BottomWidgetState();
}

class _BottomWidgetState extends State<BottomWidget> {
  // 다른 클래스에 있는 텍스트 필드에 접근하기 위해 GetxController를 사용
  // Get.put 매소드를 이용해서 Controller에 접근
  final FocusNodeObserverController getController =
      Get.put(FocusNodeObserverController());

  final controller = Get.put(ScheduleController());
  final modelController = Get.put(Model());

  String _selectedButton = '하루';
  Rx<bool> calendarOnOff = false.obs;

  String choice = '';
  DateTime now = DateTime.now();

  late String categoryValue;
  late List<String> items;

  String _selected = '하루';

  @override
  void initState() {
    super.initState();
    categoryValue = widget.category ?? '메모';
    items = ['메모', '약속', '기타'];
    choice = widget.startDate!;
    now = DateTime.parse(DateTime.now().toString().substring(0, 10));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.02,
          height: MediaQuery.of(context).size.height * 0.057,
        ),
        Material(
          color: context.theme.colorScheme.background,
          child: InkWell(
            splashColor: context.theme.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              if (getController.focusNodeObserver2.value) {
                setState(() {
                  getController.focusNodeObserver.toggle();
                });
              }
              getController.focusNodeObserver.toggle();
            },
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.04,
                  height: MediaQuery.of(context).size.height * 0.045,
                ),
                const Icon(Icons.calendar_month),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.015,
                ),
                Obx(
                  () => getController.focusNodeObserver.value ||
                          getController.focusNodeObserver2.value
                      ? Text(
                          _selectedButton == '하루'
                              ? DateCalc().subTitle(widget.startDate)[1]
                              : _selectedButton == '기간'
                                  ? '기간 일정'
                                  : '다중 일정',
                          style: const TextStyle(),
                        )
                      : const Icon(Icons.keyboard_arrow_up),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.04,
                ),
              ],
            ),
          ),
        ),
        // 좌측 캘린터 아이콘을 누르면 나오는 아이콘 리스트들이 달라서
        // 삼항 연산자로 상태에 맞는 Widget 출력
        getController.focusNodeObserver.value ||
                getController.focusNodeObserver2.value
            ? addScheduleIconList()
            : calendarIconList()
      ],
    );
  }

  Widget addScheduleIconList() {
    return Row(
      children: [
        Material(
          color: context.theme.colorScheme.background,
          child: InkWell(
            splashColor: context.theme.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              getController.contentOnOff.toggle();
              widget.stateSetter(
                () {
                  getController.contentOnOff.value
                      ? Model.height = 0.73
                      : Model.height = 0.583;
                },
              );
              if (getController.focusNodeObserver2.value) {
                getController.focusNodeObserver.value = true;
              }
            },
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                  height: MediaQuery.of(context).size.height * 0.045,
                ),
                Obx(
                  () => Icon(
                    getController.contentOnOff.value
                        ? Icons.content_paste_off_outlined
                        : Icons.content_paste_go_outlined,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.04,
        ),
        SizedBox(
          width: 100,
          height: 50,
          child: CupertinoButton(
            child: Text(categoryValue),
            onPressed: () {
              showCupertinoModalPopup(
                context: context,
                builder: (BuildContext context) {
                  return CupertinoActionSheet(
                    title: const Text(
                      '카테고리를 선택하세요',
                      style: TextStyle(),
                    ),
                    actions: items.map((item) {
                      return CupertinoActionSheetAction(
                        onPressed: () {
                          setState(() {
                            Navigator.pop(context);
                            categoryValue = item;
                            InsertDataModel.category = item;
                          });
                        },
                        child: Text(
                          item,
                          style: const TextStyle(),
                        ),
                      );
                    }).toList(),
                    cancelButton: CupertinoActionSheetAction(
                      child: const Text(
                        'Cancel',
                        style: TextStyle(),
                      ),
                      onPressed: () {
                        Navigator.pop(context, 'Cancel');
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
        SizedBox(
          width: _selectedButton == '하루' &&
                  (choice.trim() == now.toString().substring(0, 10).trim() ||
                      choice.trim() ==
                          now
                              .subtract(const Duration(days: -1))
                              .toString()
                              .substring(0, 10)
                              .trim())
              ? MediaQuery.of(context).size.width * 0.24
              : _selectedButton != '하루'
                  ? MediaQuery.of(context).size.width * 0.16
                  : MediaQuery.of(context).size.width * 0.09,
        ),
        Material(
          color: context.theme.colorScheme.background,
          child: InkWell(
            splashColor: context.theme.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
            onTap: () async {
              // 업데이트인지 인서트인지 switch 문
              // 둘중에서 홈에서 왔는지 켈린더에서 왔는지
              var statusLocation = widget.result?.take(2).join();
              Navigator.of(context).pop();

              switch (statusLocation) {
                case 'addhome':
                  await controller.addSchedule();
                  await controller.getTodayEventData();
                  await controller.getNotPastEventData();
                  break;
                case 'addcalendar':
                  await controller.addSchedule();
                  await controller.getSelectedDateData();
                  break;
                case 'updatehome':
                  await controller.updateSchedule(widget.scheduleList!);
                  await controller.getTodayEventData();
                  await controller.getNotPastEventData();
                  break;
                case 'updatecalendar':
                  await controller.updateSchedule(widget.scheduleList!);
                  await controller.getSelectedDateData();
                  break;
                default:
                  break;
              }
            },
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                  height: MediaQuery.of(context).size.height * 0.045,
                ),
                Image.asset(
                  'images/next.png',
                  color: context.theme.colorScheme.onBackground,
                  width: 24,
                  height: 24,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget calendarIconList() {
    return Row(
      children: [
        textComponent('하루'),
        textComponent('기간'),
        textComponent('다중'),
      ],
    );
  }

  Widget textComponent(String text) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.03,
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _selectedButton = text;
              _selected = text;
              Model.calendarCategory = text;
              modelController.rangeStart.value = DateTime.now();
              modelController.rangeEnd.value = DateTime.now();
              modelController.selectedDay.value = DateTime.now();
              modelController.markers.value = [];
            });
          },
          style: TextButton.styleFrom(
            minimumSize: Size(
              MediaQuery.of(context).size.width * 0.16,
              MediaQuery.of(context).size.height * 0,
            ),
            backgroundColor: context.theme.colorScheme.surface,
            side: BorderSide(
              color: _selected == text
                  ? context.theme.colorScheme.secondary
                  : context.theme.colorScheme.secondary,
              width: _selected == text ? 2 : 0,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: Dow(
            text: text,
            color: context.theme.colorScheme.onBackground,
            fontSize: 15.0,
          ),
        ),
      ],
    );
  }
}
