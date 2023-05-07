import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scadule/component/eventCard.dart';
import 'package:scadule/controller/select_schedule_controller.dart';
import 'package:scadule/model/schedule.dart';
import 'package:scadule/view/preferences.dart';
import 'package:scadule/widget/todayEvent/title.dart';
import 'package:collection/collection.dart';

// 모든 일정이 나오는 메인 화면
// AppBar 우측 아이콘을 통해 환경설정 가능

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String categoryValue;
  late List<String> items;

  final getController = Get.put(ScheduleController());

  late int itemCount = 0;

  @override
  void initState() {
    super.initState();
    categoryValue = '메모';
    items = ['메모', '약속', '기타'];

    // 앱 실행과 동시에 모든 데이터 불러오기
    // startDate를 그룹해서 개수만 가져오기 (큰 카드 위젯 개수에 사용)
    getController.getAllEventData();
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
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Get.to(const Preferences());
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
                Obx(
                  () => ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: getController.item.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(8, 1, 8, 1),
                        child: SizedBox(
                          child: Card(
                            color: context.theme.colorScheme.surface,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 4, 12, 0),
                                  child: Row(
                                    children: [
                                      Text(
                                        const TopTitle().subTitle(getController
                                            .item[index]['startDate'])[0],
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                      Expanded(child: Container()),
                                      SizedBox(
                                        height: 35,
                                        child: TextButton(
                                            onPressed: () {
                                              //
                                            },
                                            child: const Text('할 일 추가')),
                                      ),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 0, 12, 0),
                                  child: Row(
                                    children: [
                                      Text(
                                        DateFormat('y년 M월 d일 (E)', 'ko').format(
                                            DateFormat("yyyy-MM-dd").parse(
                                                getController.item[index]
                                                        ['startDate']
                                                    .toString())),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                // Expanded(child: Container()),

                                SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      children: [
                                        // EventCard(getController.item[index]
                                        //         ['startDate']
                                        //     .toString()),

                                        EventCard(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
