import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scadule/view/preferences.dart';
import 'package:scadule/widget/home/notPastEvent/defaultCard.dart';
import 'package:scadule/widget/home/notPastEvent/scheduleList_v1.dart';
import 'package:scadule/widget/home/pastEvent/goPastEventButton.dart';
// import 'package:scadule/widget/home/scheduleList%20copy.dart';

// 모든 일정이 나오는 메인 화면
// AppBar 우측 아이콘을 통해 환경설정 가능

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.colorScheme.background,
        foregroundColor: context.theme.colorScheme.outline,
        title: Text(
          'My Plan',
          style: TextStyle(
            color: context.theme.colorScheme.outline,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        // leading: const SizedBox.shrink(),
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Get.to(() => const PreferencesPage());
              // Get.off(const PreferencesPage());
            },
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 1,
        color: context.theme.colorScheme.background,
        child: const SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                GoPastEventButton(),
                SizedBox(
                  height: 10,
                ),
                DefaultCard(),
                ScheduleList()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
