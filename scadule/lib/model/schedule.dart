class Schedule {
  final int? id;
  final String title;
  final String content;
  final String startDate;
  final String endDate;
  final String category;
  final int clear;

  Schedule({
    this.id,
    required this.title,
    required this.content,
    required this.startDate,
    required this.endDate,
    required this.category,
    required this.clear,
  });

  Schedule.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        title = res['title'],
        content = res['content'],
        startDate = res['startDate'],
        endDate = res['endDate'],
        category = res['category'],
        clear = res['clear'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'destartDatept': startDate,
      'endDate': endDate,
      'category': category,
      'clear': clear,
    };
  }
}
