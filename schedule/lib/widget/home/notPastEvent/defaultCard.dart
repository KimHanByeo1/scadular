import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scadule/component/addSchedule.dart';
import 'package:scadule/component/deleteSchedule.dart';
import 'package:scadule/controller/select_schedule_controller.dart';
import 'package:scadule/model/insert_data_model.dart';
import 'package:scadule/model/model.dart';
import 'package:scadule/service/schedule_services.dart';

class DefaultCard extends StatefulWidget {
  const DefaultCard({super.key});

  @override
  State<DefaultCard> createState() => _DefaultCardState();
}

class _DefaultCardState extends State<DefaultCard> {
  final controller = Get.put(ScheduleController());

  @override
  void initState() {
    super.initState();
    controller.getTodayEventData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      // padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Card(
        shadowColor: Colors.transparent,
        margin: const EdgeInsets.fromLTRB(0, 3, 0, 3),
        color: context.theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(15, 10, 12, 0),
                        child: Row(
                          children: [
                            Text(
                              '오늘',
                              style: TextStyle(
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
                              DateFormat('y년 M월 d일 (E)', 'ko').format(
                                  DateFormat("yyyy-MM-dd")
                                      .parse(DateTime.now().toString())),
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
                              DateTime.now().toString().substring(0, 11);
                          AddSchedule().addSchedule(
                            context,
                            null,
                            null,
                            ['add', 'home', '', 'notPast'],
                            DateTime.now().toString().substring(0, 10),
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
            Obx(
              () {
                if (controller.scheduleTodayList.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: Card(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '오늘은 등록된 일정이 없습니다.!!❤️‍🔥❤️‍🔥',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '발 닦고 잠이나 자러 가자고요 ㅎㅎ',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return ReorderableListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.scheduleTodayList.length,
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        controller.scheduleTodayList.insert(newIndex,
                            controller.scheduleTodayList.removeAt(oldIndex));
                        ScheduleServices()
                            .updateTodayEventList(controller.scheduleTodayList);
                      });
                    },
                    itemBuilder: (context, index) {
                      return Slidable(
                        key: ValueKey(index),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          dismissible: null,
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                DeleteSchedule().showDeleteEventDialog(
                                  context,
                                  controller.scheduleTodayList[index].id!,
                                  ['home', 'notPast'],
                                );
                              },
                              backgroundColor:
                                  const Color.fromARGB(255, 248, 112, 112),
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
                                InsertDataModel.title =
                                    controller.scheduleTodayList[index].title;
                                InsertDataModel.content =
                                    controller.scheduleTodayList[index].content;
                                InsertDataModel.startDate = controller
                                    .scheduleTodayList[index].startDate;
                                InsertDataModel.endDate =
                                    controller.scheduleTodayList[index].endDate;
                                InsertDataModel.category = controller
                                    .scheduleTodayList[index].category;
                                AddSchedule().addSchedule(
                                  context,
                                  null,
                                  controller.scheduleTodayList[index],
                                  ['update', 'home', 'today', 'notPast'],
                                );
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                              child: Card(
                                shadowColor: Colors.transparent,
                                color: controller.scheduleTodayList[index]
                                            .category ==
                                        '메모'
                                    ? const Color.fromARGB(255, 255, 213, 213)
                                    : controller.scheduleTodayList[index]
                                                .category ==
                                            '약속'
                                        ? const Color.fromARGB(
                                            255, 228, 253, 228)
                                        : const Color.fromARGB(
                                            255, 215, 215, 255),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  controller
                                                      .scheduleTodayList[index]
                                                      .category,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
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
                                                      text: controller
                                                          .scheduleTodayList[
                                                              index]
                                                          .title,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    // 텍스트가 지정 범위를 넘어가면 ... 으로 표시
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Checkbox(
                                        fillColor: MaterialStateProperty
                                            .resolveWith<Color>(
                                                (Set<MaterialState> states) {
                                          if (states.contains(
                                              MaterialState.selected)) {
                                            return Colors.transparent;
                                          } else {
                                            return controller
                                                        .scheduleTodayList[
                                                            index]
                                                        .category ==
                                                    '메모'
                                                ? const Color.fromARGB(
                                                    255, 250, 166, 166)
                                                : controller
                                                            .scheduleTodayList[
                                                                index]
                                                            .category ==
                                                        '약속'
                                                    ? const Color.fromARGB(
                                                        255, 142, 255, 142)
                                                    : const Color.fromARGB(
                                                        255, 160, 160, 253);
                                          }
                                        }),
                                        checkColor: controller
                                                    .scheduleTodayList[index]
                                                    .category ==
                                                '메모'
                                            ? const Color.fromARGB(
                                                255, 250, 166, 166)
                                            : controller
                                                        .scheduleTodayList[
                                                            index]
                                                        .category ==
                                                    '약속'
                                                ? const Color.fromARGB(
                                                    255, 142, 255, 142)
                                                : const Color.fromARGB(
                                                    255, 160, 160, 253),
                                        value: controller
                                                    .scheduleTodayList[index]
                                                    .complet ==
                                                1
                                            ? true
                                            : false,
                                        onChanged: (value) {
                                          setState(() {
                                            ScheduleServices()
                                                .updateEventComplet(
                                                    value! ? 1 : 0,
                                                    controller
                                                        .scheduleTodayList[
                                                            index]
                                                        .id!);
                                            controller.getTodayEventData();
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
              },
            ),
          ],
        ),
      ),
    );
  }
}
