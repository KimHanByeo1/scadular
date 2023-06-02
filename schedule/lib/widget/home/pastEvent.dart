import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scadule/model/model.dart';
import 'package:scadule/widget/home/scheduleList_v1.dart';

class GoPastEvent extends StatefulWidget {
  const GoPastEvent({super.key});

  @override
  State<GoPastEvent> createState() => _GoPastEventState();
}

class _GoPastEventState extends State<GoPastEvent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.colorScheme.background,
        foregroundColor: context.theme.colorScheme.outline,
        title: Text(
          'Past Events',
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
            StaticModel.eventDataToFetched = 'notPastEvent';
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 1,
          color: context.theme.colorScheme.background,
          child: const ScheduleList(),
        ),
      ),
    );
  }
}
