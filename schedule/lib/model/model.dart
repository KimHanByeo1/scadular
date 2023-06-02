import 'package:get/get.dart';

class Model extends GetxController {
  static double height = 0.583;
  static String calendarCategory = '하루';

  Rx<DateTime> rangeStart = DateTime.now().obs;
  Rx<DateTime> rangeEnd = DateTime.now().obs;
  Rx<DateTime> selectedDay = DateTime.now().obs;
  RxList markers = [].obs;
}

class StaticModel {
  static DateTime selectedDay = DateTime.now();
  static String eventDataToFetched = 'notPastEvent';
}
