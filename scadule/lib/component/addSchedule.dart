import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scadule/controller/controller.dart';
import 'package:scadule/model/model.dart';
import 'package:scadule/model/schedule.dart';
import 'package:scadule/model/todaySchedule.dart';
import 'package:scadule/widget/addSchedule/bottomWidget.dart';
import 'package:scadule/widget/addSchedule/calendar.dart';
import 'package:scadule/widget/addSchedule/contentTextField.dart';
import 'package:scadule/widget/addSchedule/titleTextField.dart';
import 'package:scadule/widget/addSchedule/topText.dart';

class AddSchedule {
  final FocusNodeObserverController getController =
      Get.put(FocusNodeObserverController());

  addSchedule(BuildContext context,
      [Schedule? scheduleList,
      TodaySchedule? todaySchedule,
      List<String>? result]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.theme.colorScheme.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.linear, // 일정한 속도로 에니메이션 처리
              // vsync: this, // 화면이 새로 그려지는 주기와 동일하게 업데이트함(불필요한 업데이트 X)
              // height: (MediaQuery.of(context).size.height * 0.6),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * Model.height,
                child: Column(
                  children: [
                    // result[0] == today or notToday
                    // result[1] == add or update
                    // result[2] == home or calendar
                    if (result![0] == 'add') ...[
                      const TopText(),
                      const TitleTextField(''),
                      if (getController.contentOnOff.value)
                        const ContentTextField(''),
                      BottomWidget(
                        stateSetter: setState,
                        '메모',
                        scheduleList?.startDate,
                        result,
                        scheduleList,
                      ),
                      const BottomCalendar(),
                      //
                    ] else if (result[0] == 'update') ...[
                      if (result[1] == 'home') ...[
                        if (result[2] == 'today') ...[
                          const TopText(),
                          TitleTextField(todaySchedule?.title ?? ''),
                          if (getController.contentOnOff.value)
                            ContentTextField(todaySchedule?.content ?? ''),
                          BottomWidget(
                            stateSetter: setState,
                            todaySchedule?.category ?? '메모',
                            todaySchedule?.startDate,
                            result,
                            Schedule.fromTodaySchedule(todaySchedule!),
                          ),
                          const BottomCalendar(),
                          //
                        ] else if (result[2] == 'notToday') ...[
                          const TopText(),
                          TitleTextField(scheduleList?.title ?? ''),
                          if (getController.contentOnOff.value)
                            ContentTextField(scheduleList?.content ?? ''),
                          BottomWidget(
                            stateSetter: setState,
                            scheduleList?.category ?? '메모',
                            scheduleList?.startDate,
                            result,
                            scheduleList!,
                          ),
                          const BottomCalendar(),
                          //
                        ]
                      ] else if (result[1] == 'calendar') ...[
                        const TopText(),
                        TitleTextField(scheduleList?.title ?? ''),
                        if (getController.contentOnOff.value)
                          ContentTextField(scheduleList?.content ?? ''),
                        BottomWidget(
                          stateSetter: setState,
                          scheduleList?.category ?? '메모',
                          scheduleList?.startDate,
                          result,
                          scheduleList!,
                        ),
                        const BottomCalendar(),
                        //
                      ]
                    ]
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
