import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scadule/component/addSchedule.dart';
import 'package:scadule/component/deleteSchedule.dart';
import 'package:scadule/component/preferences.dart';
import 'package:scadule/controller/select_schedule_controller.dart';
import 'package:scadule/model/insert_data_model.dart';
import 'package:scadule/model/model.dart';
import 'package:scadule/service/schedule_services.dart';
import 'package:scadule/view/preferences.dart';
import 'package:scadule/widget/home/defaultCard.dart';
import 'package:scadule/widget/todayEvent/title.dart';

// 모든 일정이 나오는 메인 화면
// AppBar 우측 아이콘을 통해 환경설정 가능

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String categoryValue;
  late List<String> items;

  final controller = Get.put(ScheduleController());

  late int itemCount = 0;

  @override
  void initState() {
    super.initState();
    categoryValue = '메모';
    items = ['메모', '약속', '기타'];

    // 앱 실행과 동시에 모든 데이터 불러오기
    // startDate를 그룹해서 개수만 가져오기 (큰 카드 위젯 개수에 사용)
    controller.getAllEventData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.colorScheme.background,
        foregroundColor: context.theme.colorScheme.outline,
        title: Text(
          'My App',
          style: TextStyle(
            color: context.theme.colorScheme.outline,
            fontStyle: Preferences().loadFontValue()
                ? FontStyle.normal
                : FontStyle.italic,
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Get.to(() => const PreferencesPage());
            },
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 1,
        color: context.theme.colorScheme.background,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
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
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 10, 12, 0),
                                    child: Row(
                                      children: [
                                        Text(
                                          '오늘',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                Preferences().loadFontValue()
                                                    ? FontStyle.normal
                                                    : FontStyle.italic,
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
                                          DateFormat('y년 M월 d일 (E)', 'ko')
                                              .format(DateFormat("yyyy-MM-dd")
                                                  .parse(DateTime.now()
                                                      .toString())),
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontStyle:
                                                Preferences().loadFontValue()
                                                    ? FontStyle.normal
                                                    : FontStyle.italic,
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
                                      InsertDataModel.startDate = DateTime.now()
                                          .toString()
                                          .substring(0, 11);
                                      AddSchedule().addSchedule(
                                        context,
                                        null,
                                        null,
                                        ['add', 'home'],
                                      );
                                    },
                                    child: Text(
                                      '할 일 추가',
                                      style: TextStyle(
                                        fontStyle: Preferences().loadFontValue()
                                            ? FontStyle.normal
                                            : FontStyle.italic,
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: DefaultCard()),
                      ],
                    ),
                  ),
                ),
                Obx(
                  () {
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.scheduleList.length,
                      // onReorder: (int oldIndex, int newIndex) {
                      //   setState(() {
                      //     if (oldIndex < newIndex) {
                      //       newIndex -= 1;
                      //     }
                      //     controller.scheduleList.insert(
                      //       newIndex,
                      //       controller.scheduleList.removeAt(oldIndex),
                      //     );
                      //     ScheduleServices()
                      //         .updateEventList(controller.scheduleList);
                      //   });
                      // },
                      itemBuilder: (BuildContext context, int index) {
                        late Widget widgetCard;

                        widgetCard = Slidable(
                          key: ValueKey(controller.scheduleList[index].id),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            dismissible: null,
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  DeleteSchedule().showDeleteEventDialog(
                                    context,
                                    controller.scheduleList[index].id!,
                                    'home',
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
                                      controller.scheduleList[index].title;
                                  InsertDataModel.content =
                                      controller.scheduleList[index].content;
                                  InsertDataModel.startDate =
                                      controller.scheduleList[index].startDate;
                                  InsertDataModel.endDate =
                                      controller.scheduleList[index].endDate;
                                  InsertDataModel.category =
                                      controller.scheduleList[index].category;
                                  AddSchedule().addSchedule(
                                    context,
                                    controller.scheduleList[index],
                                    null,
                                    ['update', 'home', 'notToday'],
                                  );
                                });
                              },
                              child: Card(
                                shadowColor: Colors.transparent,
                                color: controller
                                            .scheduleList[index].category ==
                                        '메모'
                                    ? const Color.fromARGB(255, 255, 213, 213)
                                    : controller.scheduleList[index].category ==
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
                                                  controller.scheduleList[index]
                                                      .category,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontStyle: Preferences()
                                                            .loadFontValue()
                                                        ? FontStyle.normal
                                                        : FontStyle.italic,
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
                                                          .scheduleList[index]
                                                          .title,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontStyle: Preferences()
                                                                .loadFontValue()
                                                            ? FontStyle.normal
                                                            : FontStyle.italic,
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
                                                        .scheduleList[index]
                                                        .category ==
                                                    '메모'
                                                ? const Color.fromARGB(
                                                    255, 250, 166, 166)
                                                : controller.scheduleList[index]
                                                            .category ==
                                                        '약속'
                                                    ? const Color.fromARGB(
                                                        255, 142, 255, 142)
                                                    : const Color.fromARGB(
                                                        255, 160, 160, 253);
                                          }
                                        }),
                                        checkColor: controller
                                                    .scheduleList[index]
                                                    .category ==
                                                '메모'
                                            ? const Color.fromARGB(
                                                255, 250, 166, 166)
                                            : controller.scheduleList[index]
                                                        .category ==
                                                    '약속'
                                                ? const Color.fromARGB(
                                                    255, 142, 255, 142)
                                                : const Color.fromARGB(
                                                    255, 160, 160, 253),
                                        value: controller.scheduleList[index]
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
                                                        .scheduleList[index]
                                                        .id!);
                                            controller.getAllEventData();
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
                            controller.scheduleList[index].startDate !=
                                controller.scheduleList[index - 1].startDate) {
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
                                                  const EdgeInsets.fromLTRB(
                                                      15, 10, 12, 0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    const TopTitle().subTitle(
                                                        controller
                                                            .scheduleList[index]
                                                            .startDate)[0],
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle: Preferences()
                                                              .loadFontValue()
                                                          ? FontStyle.normal
                                                          : FontStyle.italic,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      15, 4, 12, 5),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    DateFormat('y년 M월 d일 (E)',
                                                            'ko')
                                                        .format(DateFormat(
                                                                "yyyy-MM-dd")
                                                            .parse(controller
                                                                .scheduleList[
                                                                    index]
                                                                .startDate)),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontStyle: Preferences()
                                                              .loadFontValue()
                                                          ? FontStyle.normal
                                                          : FontStyle.italic,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 10, 0),
                                        child: SizedBox(
                                          height: 35,
                                          child: TextButton(
                                              onPressed: () {
                                                Model.calendarCategory = '하루';
                                                InsertDataModel.startDate =
                                                    controller
                                                        .scheduleList[index]
                                                        .startDate;
                                                AddSchedule().addSchedule(
                                                  context,
                                                  controller
                                                      .scheduleList[index],
                                                  null,
                                                  ['add', 'home'],
                                                );
                                              },
                                              child: Text(
                                                '할 일 추가',
                                                style: TextStyle(
                                                  fontStyle: Preferences()
                                                          .loadFontValue()
                                                      ? FontStyle.normal
                                                      : FontStyle.italic,
                                                ),
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 0, 8, 0),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
