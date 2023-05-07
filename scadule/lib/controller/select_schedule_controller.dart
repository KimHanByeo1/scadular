import 'package:get/get.dart';
import 'package:scadule/model/insert_data_model.dart';
import 'package:scadule/model/schedule.dart';
import 'package:scadule/service/schedule_services.dart';

class ScheduleController extends GetxController {
  var scheduleList = <Schedule>[].obs;
  var item = [].obs;

  @override
  void onInit() {
    super.onInit();
    getAllEventData();
  }

  getAllEventData() async {
    List result = await ScheduleServices.getAllEventData();
    item.value = result;
    var results = await ScheduleServices.getDailyData();
    scheduleList.value = results!;
  }

  // 데이터를 전달 받은 후에 동작을 해야하기 때문에 async, await 키워드를 사용한다
  fetchData() async {
    var results = await ScheduleServices.fetchProduct();
    scheduleList.value = results!;
  }

  addStudents() async {
    Schedule add = Schedule(
      title: InsertDataModel.title,
      content: InsertDataModel.content,
      startDate: InsertDataModel.startDate,
      endDate: InsertDataModel.endDate,
      category: InsertDataModel.category,
      clear: 0,
    );
    // await ScheduleServices.insertEvent(add);
    await ScheduleServices.listCount(add);
  }
}
