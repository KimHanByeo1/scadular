import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// 데이터베이스: SQLite 사용
// 추가한 일정 저장할 데이터베이스

// Table 생성
class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, "calendar.db"),
      onCreate: (database, version) async {
        await database.execute("""
            create table calendar(id integer primary key autoincrement, 
                                  title text,
                                  content text,
                                  startDate text,
                                  endDate text,
                                  category text,
                                  clear TINYINT(1) DEFAULT 0,
                                  decideOrder integer
                                  )
            """);
      },
      version: 1,
    );
  }

  // Future<List<Schedule>> scheduleInfo() async {
  //   final Database db = await initializeDB();
  //   final List<Map<String, Object?>> queryResult = await db.rawQuery(
  //     "select * from calendar",
  //   );
  //   return queryResult.map((e) => Schedule.fromMap(e)).toList();
  // }

  Future<int> sampleInsert() async {
    int result = 0;
    final Database db = await initializeDB(); //그런애있냐 하고 이니셜라이징하고
    result = await db.rawInsert(
        "insert into calendar (title, content, startDate, endDate, category) values(?,?,?,?,?)",
        [
          'Title',
          'Content',
          (DateTime.now().toString()),
          (DateTime.now().toString()),
          '기타',
        ]);
    return result;
  }
}
