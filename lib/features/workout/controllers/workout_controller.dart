import '../models/workout_model.dart';

class WorkoutController {
  // Static dummy data for now
  static final List<WorkoutModel> workouts = [
    WorkoutModel(
      id: 'w1',
      title: 'Cardio Burn',
      category: 'Cardio',
      imageUrl:
          'https://img.freepik.com/free-photo/young-fit-man-doing-sport-exercise-home_23-2148672296.jpg',
      duration: 20,
      exercises: 10,
    ),
    WorkoutModel(
      id: 'w2',
      title: 'Strength Builder',
      category: 'Strength',
      imageUrl:
          'https://img.freepik.com/free-photo/sportsman-doing-push-ups-gym_23-2148672295.jpg',
      duration: 30,
      exercises: 8,
    ),
    WorkoutModel(
      id: 'w3',
      title: 'Morning Yoga',
      category: 'Yoga',
      imageUrl:
          'https://img.freepik.com/free-photo/woman-practicing-yoga-home_23-2148672294.jpg',
      duration: 25,
      exercises: 6,
    ),
  ];
}
