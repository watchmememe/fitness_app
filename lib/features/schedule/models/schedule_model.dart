class ScheduleModel {
  final String id;
  final String title;
  final DateTime dateTime;
  final String difficulty;
  final bool isDone;

  ScheduleModel({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.difficulty,
    this.isDone = false,
  });
}
