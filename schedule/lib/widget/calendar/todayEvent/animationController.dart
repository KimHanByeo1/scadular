import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scadule/controller/select_schedule_controller.dart';

class FirstClass extends GetxController with GetTickerProviderStateMixin {
  late AnimationController animationController;
  final controller = Get.put(ScheduleController());
  late Animation<double> _animation;
  // final animationController = Get.find<FirstClass>();

  final RxDouble currentValue = RxDouble(0.0);

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    Get.put(animationController);
  }

  void startAnimation() {
    animationController.forward();
  }

  void animation() {
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

    _animation = Tween(
      begin: 0.0,
      end: controller.checkCount.value / controller.notPastEventList.length,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.linear,
      ),
    );
    animationController.forward();

    _animation.addListener(() {
      currentValue.value = _animation.value;
    });
    currentValue.value = _animation.value;
  }

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
    animation();
    // animationController.startAnimation();
    // _ProgressBarState()._controller.forward();
  }
}
