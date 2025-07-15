import '../models/schedule_model.dart';

class ScheduleController {
  static final List<ScheduleModel> scheduleList = [
    ScheduleModel(
      id: '1',
      title: 'Upperbody Workout',
      dateTime: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day, // 👈 MATCHES selectedDate
        9,
        0,
      ),
      difficulty: 'Intermediate',
    ),
    ScheduleModel(
      id: '2',
      title: 'Yoga Stretch',
      dateTime: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        14,
        30,
      ),
      difficulty: 'Beginner',
    ),
  ];
}
