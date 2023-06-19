// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scadule/component/addSchedule.dart';
import 'package:scadule/component/dateCalc.dart';
import 'package:scadule/component/deleteSchedule.dart';
import 'package:scadule/controller/select_schedule_controller.dart';
import 'package:scadule/model/insert_data_model.dart';
import 'package:scadule/model/model.dart';
import 'package:scadule/model/schedule.dart';
import 'package:scadule/service/schedule_services.dart';

class ScheduleList extends StatefulWidget {
  // final String event;
  const ScheduleList({super.key});

  @override
  State<ScheduleList> createState() => _ScheduleListState();
}

class _ScheduleListState extends State<ScheduleList> {
  final controller = Get.put(ScheduleController());

  @override
  void initState() {
    super.initState();
    controller.getNotPastEventData();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
        // 일 별 그룹화한 ListView
        () {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: controller.notPastGroupedData.length,
        itemBuilder: (BuildContext context, int index) {
          DateTime date = controller.notPastGroupedData.keys.elementAt(index);
          List<Schedule> items = controller.notPastGroupedData[date]!;

          // 일 별 그룹화한 Card Widget
          return Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Card(
              shadowColor: Colors.transparent,
              margin: const EdgeInsets.fromLTRB(0, 15, 0, 3),
              color: context.theme.colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              // ----
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 10, 12, 0),
                              child: Row(
                                children: [
                                  Text(
                                    // 이벤트 날 까지 며칠 남았는지
                                    DateCalc()
                                        .subTitle(items.first.startDate)[0],
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 4, 12, 5),
                              child: Row(
                                children: [
                                  Text(
                                    // 해당 이벤트 날짜
                                    DateFormat('y년 M월 d일 (E)', 'ko').format(
                                        DateFormat("yyyy-MM-dd")
                                            .parse(items.first.startDate)),
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: SizedBox(
                          height: 35,
                          child: TextButton(
                              onPressed: () {
                                Model.calendarCategory = '하루';
                                InsertDataModel.startDate =
                                    items[index].startDate;
                                AddSchedule().addSchedule(
                                  context,
                                  items[index],
                                  null,
                                  ['add', 'home'],
                                );
                              },
                              child: const Text(
                                '할 일 추가',
                                style: TextStyle(),
                              )),
                        ),
                      ),
                    ],
                  ),
                  _EventListView(items)
                ],
              ),
            ),
          );
        },
      );
    });
  }

// ======================= Widget Start ============================

  Widget _EventListView(List<Schedule> items) {
    // 일별 그룹화 한 Card Widget 안 쪽 ListView
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Slidable(
          key: ValueKey(items[index].id),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            dismissible: null,
            children: [
              SlidableAction(
                onPressed: (context) {
                  DeleteSchedule().showDeleteEventDialog(
                    context,
                    items[index].id!,
                    ['home', 'notPast'],
                  );
                },
                backgroundColor: const Color.fromARGB(255, 248, 112, 112),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: '삭제',
              ),
            ],
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.07,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  Model.calendarCategory = '하루';
                  InsertDataModel.title = items[index].title;
                  InsertDataModel.content = items[index].content;
                  InsertDataModel.startDate = items[index].startDate;
                  InsertDataModel.endDate = items[index].endDate;
                  InsertDataModel.category = items[index].category;
                  AddSchedule().addSchedule(
                    context,
                    items[index],
                    null,
                    ['update', 'home', 'notToday'],
                  );
                });
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Card(
                  shadowColor: Colors.transparent,
                  color: items[index].category == '메모'
                      ? const Color.fromARGB(255, 255, 213, 213)
                      : items[index].category == '약속'
                          ? const Color.fromARGB(255, 228, 253, 228)
                          : const Color.fromARGB(255, 215, 215, 255),
                  margin: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    items[index].category,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: RichText(
                                      text: TextSpan(
                                        text: items[index].title,
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      // 텍스트가 지정 범위를 넘어가면 ... 으로 표시
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Checkbox(
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return Colors.transparent;
                            } else {
                              return items[index].category == '메모'
                                  ? const Color.fromARGB(255, 250, 166, 166)
                                  : items[index].category == '약속'
                                      ? const Color.fromARGB(255, 142, 255, 142)
                                      : const Color.fromARGB(
                                          255, 160, 160, 253);
                            }
                          }),
                          checkColor: items[index].category == '메모'
                              ? const Color.fromARGB(255, 250, 166, 166)
                              : items[index].category == '약속'
                                  ? const Color.fromARGB(255, 142, 255, 142)
                                  : const Color.fromARGB(255, 160, 160, 253),
                          value: items[index].complet == 1 ? true : false,
                          onChanged: (value) {
                            setState(() {
                              ScheduleServices().updateEventComplet(
                                  value! ? 1 : 0, items[index].id!);
                              controller.getNotPastEventData();
                            });
                          },
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ======================= Widget End ============================
  //
} // End
