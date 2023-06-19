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
import 'package:scadule/service/schedule_services.dart';

class PaseScheduleList extends StatefulWidget {
  const PaseScheduleList({super.key});

  @override
  State<PaseScheduleList> createState() => _PaseScheduleListState();
}

class _PaseScheduleListState extends State<PaseScheduleList> {
  final controller = Get.put(ScheduleController());

  @override
  void initState() {
    super.initState();
    // 앱 실행과 동시에 모든 데이터 불러오기
    // startDate를 그룹해서 개수만 가져오기 (큰 카드 위젯 개수에 사용)
    controller.getPastEventData();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: controller.pastEventList.length,
          itemBuilder: (BuildContext context, int index) {
            late Widget widgetCard;

            widgetCard = Slidable(
              key: ValueKey(controller.pastEventList[index].id),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                dismissible: null,
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      DeleteSchedule().showDeleteEventDialog(
                        context,
                        controller.pastEventList[index].id!,
                        ['home', 'past'],
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
                      InsertDataModel.title =
                          controller.pastEventList[index].title;
                      InsertDataModel.content =
                          controller.pastEventList[index].content;
                      InsertDataModel.startDate =
                          controller.pastEventList[index].startDate;
                      InsertDataModel.endDate =
                          controller.pastEventList[index].endDate;
                      InsertDataModel.category =
                          controller.pastEventList[index].category;
                      AddSchedule().addSchedule(
                        context,
                        controller.pastEventList[index],
                        null,
                        ['update', 'home', 'notToday', 'past'],
                      );
                    });
                  },
                  child: Card(
                    shadowColor: Colors.transparent,
                    color: controller.pastEventList[index].category == '메모'
                        ? const Color.fromARGB(255, 255, 213, 213)
                        : controller.pastEventList[index].category == '약속'
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
                                      controller.pastEventList[index].category,
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
                                          text: controller
                                              .pastEventList[index].title,
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
                                return controller
                                            .pastEventList[index].category ==
                                        '메모'
                                    ? const Color.fromARGB(255, 250, 166, 166)
                                    : controller.pastEventList[index]
                                                .category ==
                                            '약속'
                                        ? const Color.fromARGB(
                                            255, 142, 255, 142)
                                        : const Color.fromARGB(
                                            255, 160, 160, 253);
                              }
                            }),
                            checkColor: controller
                                        .pastEventList[index].category ==
                                    '메모'
                                ? const Color.fromARGB(255, 250, 166, 166)
                                : controller.pastEventList[index].category ==
                                        '약속'
                                    ? const Color.fromARGB(255, 142, 255, 142)
                                    : const Color.fromARGB(255, 160, 160, 253),
                            value: controller.pastEventList[index].complet == 1
                                ? true
                                : false,
                            onChanged: (value) {
                              setState(() {
                                ScheduleServices().updateEventComplet(
                                    value! ? 1 : 0,
                                    controller.pastEventList[index].id!);
                                controller.getPastEventData();
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
            );
            // 첫 번째 일정이거나, 이전 일정과 다른 날짜인 경우에만 새로운 카드 생성
            if (index == 0 ||
                controller.pastEventList[index].startDate !=
                    controller.pastEventList[index - 1].startDate) {
              return SizedBox(
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
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 10, 12, 0),
                                  child: Row(
                                    children: [
                                      Text(
                                        DateCalc().subTitle(controller
                                            .pastEventList[index].startDate)[0],
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 4, 12, 5),
                                  child: Row(
                                    children: [
                                      Text(
                                        DateFormat('y년 M월 d일 (E)', 'ko').format(
                                            DateFormat("yyyy-MM-dd").parse(
                                                controller.pastEventList[index]
                                                    .startDate)),
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
                        ],
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                              child: widgetCard,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              // 같은 날짜의 일정인 경우에는 이미 만들어진 카드에 추가
              return Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: widgetCard,
              );
            }
          },
        );
      },
    );
  }
}
