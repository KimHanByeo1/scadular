import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scadule/controller/select_schedule_controller.dart';

class ProgressBar extends StatefulWidget {
  ProgressBar({super.key});

  @override
  State<ProgressBar> createState() => _ProgressBarState();

  final controller = Get.put(ScheduleController());

  // check box가 onChanged 될 때마다 value 값에 따라 checkCount값 증감
  // 해당 이벤트의 Complet 체크 여부를 판단
  // checkCount: 전체 이벤트 리스트 중 체크한 리스트의 개수
  increment(bool value) {
    if (value) {
      // 체크를 하면 증가
      controller.checkCount++;
    } else {
      // 체크를 풀면 감소
      controller.checkCount--;
    }
  }
}

class _ProgressBarState extends State<ProgressBar> {
  final controller = Get.put(ScheduleController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.58,
      height: MediaQuery.of(context).size.height * 0.007,
      child: Obx(() {
        return LinearProgressIndicator(
          value: func(),
          // backgroundColor: context.theme.colorScheme.onBackground,
          backgroundColor: Colors.white,
          valueColor: const AlwaysStoppedAnimation<Color>(
              Color.fromARGB(255, 204, 206, 255)),
        );
      }),
    );
  }

  double func() {
    if ((controller.checkCount.value / controller.notPastEventList.length)
        .isNaN) {
      return 0.0;
    } else {
      return controller.checkCount.value / controller.notPastEventList.length;
    }
  }
}
