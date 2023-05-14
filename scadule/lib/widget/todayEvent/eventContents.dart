import 'package:flutter/material.dart';
import 'package:scadule/component/addSchedule.dart';
import 'package:scadule/component/preferences.dart';
import 'package:scadule/controller/select_schedule_controller.dart';
import 'package:scadule/model/insert_data_model.dart';
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
      onTap: () {
        setState(() {
          Model.calendarCategory = '하루';
          InsertDataModel.title = widget.scheduleList.title;
          InsertDataModel.content = widget.scheduleList.content;
          InsertDataModel.startDate = widget.scheduleList.startDate;
          InsertDataModel.endDate = widget.scheduleList.endDate;
          InsertDataModel.category = widget.scheduleList.category;
          AddSchedule().addSchedule(
            context,
            widget.scheduleList,
            null,
            ['update', 'calendar'],
          );
        });
      },
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.scheduleList.category,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontStyle: Preferences().loadFontValue()
                                ? FontStyle.normal
                                : FontStyle.italic,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: RichText(
                            text: TextSpan(
                              text: widget.scheduleList.title,
                              style: TextStyle(
                                color: Colors.black,
                                fontStyle: Preferences().loadFontValue()
                                    ? FontStyle.normal
                                    : FontStyle.italic,
                              ),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
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
                value: widget.scheduleList.complet == 1 ? true : false,
                onChanged: (value) {
                  setState(() {
                    ScheduleServices().updateEventComplet(
                        value! ? 1 : 0, widget.scheduleList.id!);
                    controller.fetchData();
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
