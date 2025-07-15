import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleModel {
  final String id;
  final String title;
  final DateTime dateTime;
  final String difficulty;
  bool isDone;

  ScheduleModel({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.difficulty,
    this.isDone = false,
  });
  factory ScheduleModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ScheduleModel(
      id: doc.id,
      title: data['title'],
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      difficulty: data['difficulty'],
      isDone: data['isDone'],
    );
  }
}
