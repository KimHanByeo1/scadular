// import 'package:get/get.dart';
// import 'package:scadule/model/schedule.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// class ScheduleServices extends GetConnect {
//   Future<Database> _openDatabase() async {
//     final String dbPath = await getDatabasesPath();
//     final String path = path.join(dbPath, 'schedule.db');

//     return openDatabase(path, version: 1, onCreate: (db, version) {
//       db.execute('CREATE TABLE schedule (id INTEGER PRIMARY KEY, title TEXT, date TEXT)');
//     });
//   }

//   Stream<List<Schedule>> getDataStream() async* {
//     // DatabaseHandler handler = DatabaseHandler();
//     // final Database db = await handler.initializeDB();

//     // final List<Map<String, Object?>> queryResult = await db.rawQuery(
//     //   "SELECT * FROM calendar",
//     // );
//     // return queryResult.map((e) => Schedule.fromMap(e)).toList();
//     final Database db = await _openDatabase();

//     yield* db
//         .query('schedule', orderBy: 'date')
//         .watch()
//         .map((rows) => rows.map((row) => Schedule.fromMap(row)).toList());
//   }
// }
