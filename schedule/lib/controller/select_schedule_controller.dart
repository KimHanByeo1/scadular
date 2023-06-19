import 'package:get/get.dart';
import 'package:scadule/model/insert_data_model.dart';
import 'package:scadule/model/schedule.dart';
import 'package:scadule/model/todaySchedule.dart';
import 'package:scadule/service/schedule_services.dart';

class ScheduleController extends GetxController {
  var notPastEventList = <Schedule>[].obs; // 오늘 기준 날짜가 지나지 않은 이벤트 데이터
  var pastEventList = <Schedule>[].obs; // 오늘 기준 날짜가 지난 이벤트 데이터
  var scheduleTodayList = <TodaySchedule>[].obs; // 오늘 이벤트 데이터

  var checkCount = 0.obs;

  // RxMap -> 모든 이벤트 데이터를 일별로 그룹할 때 사용할 변수
  RxMap pastGroupedData = {}.obs;
  RxMap notPastGroupedData = {}.obs;

  // 사용자가 등록한 정보 중에서 지나지 않은 이벤트 데이터만 가져오는 Function
  getNotPastEventData() async {
    notPastGroupedData = {}.obs;
    var results = await ScheduleServices.getDailyData();
    notPastEventList.value = results!;

    // // 데이터 그룹화
    // for (var item in scheduleList) {
    //   DateTime key = DateTime.parse(item.startDate.trim()); // 그룹화할 키 생성

    //   if (groupedData.keys.contains(key)) {
    //     groupedData[key]!.add(item); // 해당 키에 데이터 추가
    //   } else {
    //     groupedData[key] = [item]; // 새로운 키에 데이터 추가
    //   }
    // }
  }

  // 사용자가 등록한 정보 중에서 지난 이벤트 데이터만 가져오는 Function
  getPastEventData() async {
    pastGroupedData = {}.obs;
    var results = await ScheduleServices.getPastEventData();
    pastEventList.value = results!;
  }

  // 사용자가 등록한 정보 중에서 오늘 이벤트 데이터만 가져오는 Function
  getTodayEventData() async {
    var results = await ScheduleServices.getTodayData();
    scheduleTodayList.value = results!;
  }

  // 사용자가 선택한 날짜의 이벤트 데이터만 가져오는 Function
  getSelectedDateData() async {
    var results = await ScheduleServices.getSelectedDateData();
    notPastEventList.value = results!;
  }

  // 이벤트 추가하기
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

  // 이벤트 수정하기
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
