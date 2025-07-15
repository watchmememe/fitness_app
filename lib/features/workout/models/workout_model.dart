class WorkoutModel {
  final String id;
  final String title;
  final String category;
  final String imageUrl;
  final int duration; // in minutes
  final int exercises;

  WorkoutModel({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.duration,
    required this.exercises,
  });
}
