import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scadule/component/dateCalc.dart';
import 'package:scadule/controller/select_schedule_controller.dart';
import 'package:scadule/model/model.dart';

class TopTitle extends StatefulWidget {
  const TopTitle({super.key});

  @override
  State<TopTitle> createState() => _TopTitleState();
}

class _TopTitleState extends State<TopTitle> {
  final controller = Get.put(ScheduleController());

  @override
  void initState() {
    super.initState();
    // dialog가 새로 열릴 때마다 이벤트 리스트가 새로 업데이트 되기 때문에
    // checkCount 값도 0으로 초기화
    controller.checkCount.value = 0;

    // 전체 리스트 중 체크가 되어있는 것만 판단해서 checkCount + 1 값으로 대체
    for (int i = 0; i < controller.notPastEventList.length; i++) {
      // 체크가 되어있으면
      if (controller.notPastEventList[i].complet == 1) {
        controller.checkCount.value++; // checkCount + 1
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('yyyy년 M월 d일 (E)', 'ko');
    final String formatted = formatter.format(StaticModel.selectedDay);

    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    formatted,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    DateCalc().subTitle(null)[0],
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // const Text('40%'),
        Obx(
          () {
            double result = (controller.checkCount.value /
                controller.notPastEventList.length *
                100);
            return Text(
              !result.isNaN ? '${result.round()}%' : '',
            );
          },
        ),
      ],
    );
  }
}
