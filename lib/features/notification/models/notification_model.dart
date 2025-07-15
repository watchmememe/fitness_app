import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String title;
  final String message;
  final DateTime timestamp;

  NotificationModel({
    required this.title,
    required this.message,
    required this.timestamp,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
