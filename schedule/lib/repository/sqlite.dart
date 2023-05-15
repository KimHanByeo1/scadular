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
                                  complet TINYINT(1) DEFAULT 0,
                                  decideOrder integer
                                  )
            """);
      },
      version: 1,
    );
  }
}
