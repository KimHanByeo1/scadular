import 'package:scadule/model/model.dart';
import 'package:scadule/model/schedule.dart';
import 'package:scadule/repository/sqlite.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class ScheduleServices {
  // 입력 날짜의 중복값을 제거한 일정 불러오기
  static Future<List> getAllEventData() async {
    DatabaseHandler handler = DatabaseHandler();
    final Database db = await handler.initializeDB();

    List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT DISTINCT startDate FROM calendar ORDER BY startDate ASC',
    );
    return result;
  }

  // 모든 일정 일별로 그룹지어 불러오기
  static Future<List<Schedule>?> getDailyData() async {
    DatabaseHandler handler = DatabaseHandler();
    final Database db = await handler.initializeDB();

    final List<Map<String, Object?>> queryResult = await db.rawQuery(
      "SELECT * FROM calendar ORDER BY decideOrder ASC",
    );
    return queryResult.map((e) => Schedule.fromMap(e)).toList();
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

  static Future<void> listCount(Schedule item) async {
    int index;
    DatabaseHandler handler = DatabaseHandler();
    final Database db = await handler.initializeDB();

    List<Map<String, dynamic>> result = await db.rawQuery(
      "SELECT MAX(decideOrder) FROM calendar WHERE startDate = ?",
      [item.startDate],
    );

    result[0]['MAX(decideOrder)'] == null
        ? index = 0
        : index = int.parse(result[0]['MAX(decideOrder)']);

    insertEvent(item, index);
  }

  // 일정 추가하기
  static Future<void> insertEvent(Schedule item, int index) async {
    DatabaseHandler handler = DatabaseHandler();
    final Database db = await handler.initializeDB();

    await db.rawInsert(
      '''
        INSERT INTO calendar(
                  title, content, category, startDate, endDate, clear, decideOrder)
        VALUES(?, ?, ?, ?, ?, ?, ?)
      ''',
      [
        item.title,
        item.content,
        item.category,
        item.startDate,
        item.endDate,
        item.clear,
        index + 1
      ],
    );
  }

  // 해결한 일정 체크하기
  updateEventClear(int isChecked, int id) async {
    DatabaseHandler handler = DatabaseHandler();
    final Database db = await handler.initializeDB();

    await db.rawUpdate(
      'UPDATE calendar SET clear = ? WHERE id = ?',
      [isChecked, id],
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
}
