import 'package:flutter/material.dart';
import 'package:scadule/GetX/preferences.dart';
import 'package:scadule/controller/select_schedule_controller.dart';
import 'package:scadule/service/schedule_services.dart';
import 'package:get/get.dart';

class DeleteSchedule {
  final controller = Get.put(ScheduleController());

  showDeleteEventDialog(BuildContext context, int id, String result) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '정말 삭제하시겠습니까?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontStyle: Preferences().loadFontValue()
                  ? FontStyle.normal
                  : FontStyle.italic,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();

                await ScheduleServices().deleteEvent(id);
                if (result == 'home') {
                  controller.getDailyData();
                  controller.getTodayEventData();
                } else {
                  controller.fetchData();
                }
              },
              child: Text(
                '예',
                style: TextStyle(
                  fontSize: 14,
                  color: const Color.fromARGB(255, 107, 141, 252),
                  fontStyle: Preferences().loadFontValue()
                      ? FontStyle.normal
                      : FontStyle.italic,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                '아니요',
                style: TextStyle(
                  fontSize: 14,
                  color: const Color.fromARGB(255, 255, 123, 123),
                  fontStyle: Preferences().loadFontValue()
                      ? FontStyle.normal
                      : FontStyle.italic,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
