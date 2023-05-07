import 'package:flutter/material.dart';
import 'package:scadule/component/addSchedule.dart';
import 'package:scadule/controller/select_schedule_controller.dart';
import 'package:scadule/model/model.dart';
import 'package:scadule/model/schedule.dart';
import 'package:scadule/service/schedule_services.dart';
import 'package:get/get.dart';

class EventContents extends StatefulWidget {
  final Schedule scheduleList;
  const EventContents(this.scheduleList, {super.key});

  @override
  State<EventContents> createState() => _EventContentsState();
}

class _EventContentsState extends State<EventContents> {
  final controller = Get.put(ScheduleController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => setState(() {
        Model.scale = 0.95;
      }),
      onTapUp: (details) {
        setState(() {
          Model.scale = 1.0;
          AddSchedule().addSchedule(context, widget.scheduleList);
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        transform: Matrix4.diagonal3Values(Model.scale, Model.scale, 1),
        child: Card(
          color: widget.scheduleList.category == '메모'
              ? const Color.fromARGB(255, 255, 213, 213)
              : widget.scheduleList.category == '약속'
                  ? const Color.fromARGB(255, 228, 253, 228)
                  : const Color.fromARGB(255, 215, 215, 255),
          margin: const EdgeInsets.fromLTRB(0, 3, 0, 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.0),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.scheduleList.title,
                      style: const TextStyle(color: Colors.black),
                    ),
                    Text(
                      widget.scheduleList.content,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              Expanded(child: Container()),
              Checkbox(
                fillColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return Colors.transparent;
                  } else {
                    return widget.scheduleList.category == '메모'
                        ? const Color.fromARGB(255, 250, 166, 166)
                        : widget.scheduleList.category == '약속'
                            ? const Color.fromARGB(255, 142, 255, 142)
                            : const Color.fromARGB(255, 160, 160, 253);
                  }
                }),
                checkColor: widget.scheduleList.category == '메모'
                    ? const Color.fromARGB(255, 250, 166, 166)
                    : widget.scheduleList.category == '약속'
                        ? const Color.fromARGB(255, 142, 255, 142)
                        : const Color.fromARGB(255, 160, 160, 253),
                value: widget.scheduleList.clear == 1 ? true : false,
                onChanged: (value) {
                  setState(() {
                    ScheduleServices().updateEventClear(
                        value! ? 1 : 0, widget.scheduleList.id!);
                    controller.fetchData();
                    Model.scale = 1.0;
                  });
                },
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              )
            ],
          ),
        ),
      ),
    );
  }
}
