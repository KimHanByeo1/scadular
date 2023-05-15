class TodaySchedule {
  final int? id;
  final String title;
  final String content;
  final String startDate;
  final String endDate;
  final String category;
  final int complet;

  TodaySchedule({
    this.id,
    required this.title,
    required this.content,
    required this.startDate,
    required this.endDate,
    required this.category,
    required this.complet,
  });

  TodaySchedule.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        title = res['title'],
        content = res['content'],
        startDate = res['startDate'],
        endDate = res['endDate'],
        category = res['category'],
        complet = res['complet'];
}
