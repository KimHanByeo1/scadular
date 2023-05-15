import 'package:scadule/model/todaySchedule.dart';

class Schedule {
  final int? id;
  final String title;
  final String content;
  final String startDate;
  final String endDate;
  final String category;
  final int complet;

  Schedule({
    this.id,
    required this.title,
    required this.content,
    required this.startDate,
    required this.endDate,
    required this.category,
    required this.complet,
  });

  Schedule.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        title = res['title'],
        content = res['content'],
        startDate = res['startDate'],
        endDate = res['endDate'],
        category = res['category'],
        complet = res['complet'];

  static Schedule fromTodaySchedule(TodaySchedule todaySchedule) {
    return Schedule(
      title: todaySchedule.title,
      content: todaySchedule.content,
      startDate: todaySchedule.startDate,
      category: todaySchedule.category,
      complet: todaySchedule.complet,
      endDate: todaySchedule.endDate,
      id: todaySchedule.id,
    );
  }
}
