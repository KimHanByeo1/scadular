import 'package:get/get.dart';
import 'package:scadule/model/insert_data_model.dart';
import 'package:scadule/model/schedule.dart';
import 'package:scadule/model/todaySchedule.dart';
import 'package:scadule/service/schedule_services.dart';

class ScheduleController extends GetxController {
  var scheduleList = <Schedule>[].obs;
  var scheduleTodayList = <TodaySchedule>[].obs;
  var item = [].obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   getAllEventData();
  // }

  getAllEventData() async {
    var results = await ScheduleServices.getDailyData();
    scheduleList.value = results!;
  }

  getTodayEventData() async {
    var results = await ScheduleServices.getTodayData();
    scheduleTodayList.value = results!;
  }

  // 데이터를 전달 받은 후에 동작을 해야하기 때문에 async, await 키워드를 사용한다
  fetchData() async {
    var results = await ScheduleServices.fetchProduct();
    scheduleList.value = results!;
  }

  addSchedule() async {
    Schedule add = Schedule(
      title: InsertDataModel.title,
      content: InsertDataModel.content,
      startDate: InsertDataModel.startDate,
      endDate: InsertDataModel.endDate,
      category: InsertDataModel.category,
      complet: 0,
    );
    await ScheduleServices.listCount(add);
  }

  updateSchedule(Schedule scheduleList) async {
    if (scheduleList.title.trim() == InsertDataModel.title.trim() &&
        scheduleList.content.trim() == InsertDataModel.content.trim() &&
        scheduleList.startDate.trim() == InsertDataModel.startDate.trim() &&
        scheduleList.endDate.trim() == InsertDataModel.endDate.trim() &&
        scheduleList.category.trim() == InsertDataModel.category.trim()) {
      return null;
    } else {
      Schedule update = Schedule(
        title: InsertDataModel.title,
        content: InsertDataModel.content,
        startDate: InsertDataModel.startDate,
        endDate: InsertDataModel.endDate,
        category: InsertDataModel.category,
        complet: scheduleList.complet,
        id: scheduleList.id,
      );
      await ScheduleServices.updateSchedule(update);
    }
  }
}
