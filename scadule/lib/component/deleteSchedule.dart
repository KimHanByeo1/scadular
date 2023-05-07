import 'package:flutter/material.dart';
import 'package:scadule/controller/select_schedule_controller.dart';
import 'package:scadule/service/schedule_services.dart';
import 'package:get/get.dart';

class DeleteSchedule {
  final controller = Get.put(ScheduleController());

  showDeleteEventDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '정말 삭제하시겠습니까?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await ScheduleServices().deleteEvent(id);
                controller.fetchData();
                Navigator.of(context).pop();
              },
              child: const Text(
                '예',
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 107, 141, 252),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                '아니요',
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 255, 123, 123),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
