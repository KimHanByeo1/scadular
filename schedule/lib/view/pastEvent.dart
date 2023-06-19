import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scadule/controller/select_schedule_controller.dart';
import 'package:scadule/widget/home/pastEvent/pastScheduleList.dart';

class GoPastEvent extends StatefulWidget {
  const GoPastEvent({super.key});

  @override
  State<GoPastEvent> createState() => _GoPastEventState();
}

class _GoPastEventState extends State<GoPastEvent> {
  final controller = Get.put(ScheduleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.colorScheme.background,
        foregroundColor: context.theme.colorScheme.outline,
        title: Text(
          '지난 이벤트',
          style: TextStyle(
            color: context.theme.colorScheme.outline,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
          ), // 뒤로가기 아이콘 추가
          onPressed: () {
            setState(() {
              Get.back();
            });
          },
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 1,
        color: context.theme.colorScheme.background,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    // padding: const EdgeInsets.all(12.0),
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                    child: Obx(
                      () => RichText(
                        text: TextSpan(
                            text: '완료되지 않은 이벤트가 ',
                            style: TextStyle(
                              color: context.theme.colorScheme.onBackground,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: '${controller.pastEventList.length}개 ',
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 252, 107, 96),
                                  fontSize: 27,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: '있습니다',
                                style: TextStyle(
                                  color: context.theme.colorScheme.onBackground,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
              const PaseScheduleList(),
            ],
          ),
        ),
      ),
    );
  }
}
