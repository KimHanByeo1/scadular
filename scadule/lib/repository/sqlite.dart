import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
                                  startdate text,
                                  enddate text,
                                  category text,
                                  )
            """);
      },
      version: 1,
    );
  }
}
