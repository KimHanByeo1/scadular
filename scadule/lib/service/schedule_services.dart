import 'package:scadule/model/model.dart';
import 'package:scadule/model/schedule.dart';
import 'package:scadule/model/todaySchedule.dart';
import 'package:scadule/repository/sqlite.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:get/get.dart';

class ScheduleServices {
  static Future<List<Schedule>?> getData() async {
    DatabaseHandler handler = DatabaseHandler();
    final Database db = await handler.initializeDB();

    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      "SELECT * FROM calendar",
    );
    return queryResult.map((e) => Schedule.fromMap(e)).toList();
  }

  // 오늘 날짜를 기준으로 다음날 데이터부터 불러오기
  // 오늘 날짜의 데이터는 디폴트로 불러옴
  static Future<List<Schedule>?> getDailyData() async {
    DatabaseHandler handler = DatabaseHandler();
    final Database db = await handler.initializeDB();

    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      "SELECT * FROM calendar WHERE startDate > ? ORDER BY startDate ASC, decideOrder ASC",
      [DateTime.now().toString().substring(0, 11)],
    );
    return queryResult.map((e) => Schedule.fromMap(e)).toList();
  }

  // 오늘 날짜 데이터만 불러오기
  static Future<List<TodaySchedule>?> getTodayData() async {
    DatabaseHandler handler = DatabaseHandler();
    final Database db = await handler.initializeDB();

    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      "SELECT * FROM calendar WHERE startDate == ? ORDER BY startDate ASC, decideOrder ASC",
      [
        DateTime.now().add(const Duration(days: -1)).toString().substring(0, 11)
      ],
    );
    return queryResult.map((e) => TodaySchedule.fromMap(e)).toList();
  }

  // 선택한 일정 데이터 불러오기
  static Future<List<Schedule>?> fetchProduct() async {
    DatabaseHandler handler = DatabaseHandler();
    final Database db = await handler.initializeDB();

    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      "SELECT * FROM calendar WHERE startDate == ? ORDER BY decideOrder ASC",
      [CalendarModel.selectedDay.toString().substring(0, 11)],
    );
    return queryResult.map((e) => Schedule.fromMap(e)).toList();
  }

  // 일정 삭제하기
  deleteEvent(int id) async {
    DatabaseHandler handler = DatabaseHandler();
    final Database db = await handler.initializeDB();

    await db.delete('calendar', where: 'id = ?', whereArgs: [id]);
  }

  // 일정 추가하기 전 decideOrder의 마지막 번호 확인하기
  static Future listCount(Schedule item) async {
    int index;
    DatabaseHandler handler = DatabaseHandler();
    final Database db = await handler.initializeDB();

    List<Map<String, dynamic>> result = await db.rawQuery(
      "SELECT MAX(decideOrder) FROM calendar WHERE startDate = ?",
      [item.startDate],
    );

    result[0]['MAX(decideOrder)'] == null
        ? index = 0
        : index = result[0]['MAX(decideOrder)'];
    if (Model.calendarCategory == '하루') {
      oneDayAddEvent(item, index);
    } else if (Model.calendarCategory == '기간') {
      periodAddEvent(item, index);
    } else {
      multipleAddEvent(item, index);
    }
  }

  // 일정 하루만 추가하기
  static Future oneDayAddEvent(Schedule item, int index) async {
    DatabaseHandler handler = DatabaseHandler();
    final Database db = await handler.initializeDB();
    await db.rawInsert(
      '''
        INSERT INTO calendar(
                  title, content, category, startDate, endDate, complet, decideOrder)
        VALUES(?, ?, ?, ?, ?, ?, ?)
      ''',
      [
        item.title,
        item.content,
        item.category,
        item.startDate,
        item.endDate,
        item.complet,
        index + 1
      ],
    );
  }

  // 일정 기간으로 추가하기
  static Future periodAddEvent(Schedule item, int index) async {
    final controller = Get.put(Model());
    DatabaseHandler handler = DatabaseHandler();
    final Database db = await handler.initializeDB();

    int periodBetween = DateTime.parse(controller.rangeEnd.toString())
        .difference(DateTime.parse(controller.rangeStart.toString()))
        .inDays;

    for (int i = 0; i <= periodBetween; i++) {
      await db.rawInsert(
        '''
        INSERT INTO calendar(
                  title, content, category, startDate, endDate, complet, decideOrder)
        VALUES(?, ?, ?, ?, ?, ?, ?)
      ''',
        [
          item.title,
          item.content,
          item.category,
          DateTime.parse(controller.rangeStart.toString())
              .add(Duration(days: i))
              .toString()
              .substring(0, 11),
          item.endDate,
          item.complet,
          index + i + 1
        ],
      );
    }
  }

  // 일정 다중으로 추가하기
  static Future multipleAddEvent(Schedule item, int index) async {
    final controller = Get.put(Model());
    DatabaseHandler handler = DatabaseHandler();
    final Database db = await handler.initializeDB();

    for (int i = 0; i < controller.markers.length; i++) {
      await db.rawInsert(
        '''
        INSERT INTO calendar(
                  title, content, category, startDate, endDate, complet, decideOrder)
        VALUES(?, ?, ?, ?, ?, ?, ?)
      ''',
        [
          item.title,
          item.content,
          item.category,
          controller.markers[i].toString().substring(0, 11),
          item.endDate,
          item.complet,
          index + i + 1
        ],
      );
    }
  }

  // 해결한 일정 체크하기
  updateEventComplet(int isChecked, int id) async {
    DatabaseHandler handler = DatabaseHandler();
    final Database db = await handler.initializeDB();

    await db.rawUpdate(
      'UPDATE calendar SET complet = ? WHERE id = ?',
      [isChecked, id],
    );
  }

  // 일정 수정하기
  static Future updateSchedule(Schedule scheduleList) async {
    DatabaseHandler handler = DatabaseHandler();
    final Database db = await handler.initializeDB();
    await db.rawUpdate(
      '''
        UPDATE calendar SET title = ?, content = ?, startDate = ?, endDate = ?, category = ?, complet = ? WHERE id = ?
      ''',
      [
        scheduleList.title,
        scheduleList.content,
        scheduleList.startDate,
        scheduleList.endDate,
        scheduleList.category,
        scheduleList.complet,
        scheduleList.id
      ],
    );
  }

  // 일정 순서 바꾸기
  updateEventList(List<Schedule> item) async {
    DatabaseHandler handler = DatabaseHandler();
    final Database db = await handler.initializeDB();

    for (int i = 0; i < item.length; i++) {
      await db.rawUpdate(
        'UPDATE calendar SET decideOrder = ? WHERE id = ?',
        [i, item[i].id],
      );
    }
  }

  // 일정 순서 바꾸기
  updateTodayEventList(List<TodaySchedule> item) async {
    DatabaseHandler handler = DatabaseHandler();
    final Database db = await handler.initializeDB();

    for (int i = 0; i < item.length; i++) {
      await db.rawUpdate(
        'UPDATE calendar SET decideOrder = ? WHERE id = ?',
        [i, item[i].id],
      );
    }
  }
}
