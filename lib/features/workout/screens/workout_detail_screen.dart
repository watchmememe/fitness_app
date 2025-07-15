import 'package:fitness_app/features/workout/screens/workout_start_screen.dart';
import 'package:flutter/material.dart';

class WorkoutDetailScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;

  const WorkoutDetailScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔙 Back + more icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Icon(Icons.more_horiz),
                ],
              ),

              const SizedBox(height: 12),

              // 📝 Title and info
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(subtitle, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),

              // 📅 Schedule Card
              _infoCard(
                Icons.calendar_today,
                'Schedule Workout',
                '5/27, 09:00 AM',
              ),
              const SizedBox(height: 12),

              // 🧩 Difficulty Card
              _infoCard(
                Icons.swap_vert,
                'Difficulty',
                'Beginner',
                color: const Color(0xFFF4EFFF),
              ),
              const SizedBox(height: 24),

              // 🔥 Exercises header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Exercises',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text('2 Sets', style: TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 12),

              _exerciseSetTitle('Set 1'),
              _exerciseItem('Warm Up', '05:00', 'assets/images/WarmUp.png'),
              _exerciseItem(
                'Jumping Jack',
                '12x',
                'assets/images/JumpingJack.png',
              ),
              _exerciseItem('Skipping', '15x', 'assets/images/Skipping.png'),
              _exerciseItem('Squats', '20x', 'assets/images/Squats.png'),
              _exerciseItem(
                'Arm Raises',
                '00:50',
                'assets/images/ArmRaises.png',
              ),
              _exerciseItem(
                'Rest and Drink',
                '02:00',
                'assets/images/RestandDrink.png',
              ),

              const SizedBox(height: 16),

              _exerciseSetTitle('Set 2'),
              _exerciseItem(
                'Incline Push-Ups',
                '12x',
                'assets/images/InclinePushUps.png',
              ),
              _exerciseItem('Push-Ups', '15x', 'assets/images/PushUps.png'),
              _exerciseItem('Skipping', '15x', 'assets/images/Skipping.png'),
              _exerciseItem(
                'Cobra Stretch',
                '20x',
                'assets/images/CobraStretch.png',
              ),
            ],
          ),
        ),
      ),

      // 🔘 Start button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => WorkoutStartScreen(
                      exercises: [
                        {
                          'name': 'Warm Up',
                          'image': 'assets/images/WarmUp.png',
                          'reps': '05:00',
                        },
                        {
                          'name': 'Jumping Jack',
                          'image': 'assets/images/JumpingJack.png',
                          'reps': '12 reps',
                        },
                        {
                          'name': 'Skipping',
                          'image': 'assets/images/Skipping.png',
                          'reps': '15 reps',
                        },
                        {
                          'name': 'Squats',
                          'image': 'assets/images/Squats.png',
                          'reps': '20 reps',
                        },
                        {
                          'name': 'Arm Raises',
                          'image': 'assets/images/ArmRaises.png',
                          'reps': '00:50',
                        },
                        {
                          'name': 'Rest and Drink',
                          'image': 'assets/images/RestandDrink.png',
                          'reps': '02:00',
                        },
                        {
                          'name': 'Incline Push-Ups',
                          'image': 'assets/images/InclinePushUps.png',
                          'reps': '12 reps',
                        },
                        {
                          'name': 'Push-Ups',
                          'image': 'assets/images/PushUps.png',
                          'reps': '15 reps',
                        },
                        {
                          'name': 'Skipping',
                          'image': 'assets/images/Skipping.png',
                          'reps': '15 reps',
                        },
                        {
                          'name': 'Cobra Stretch',
                          'image': 'assets/images/CobraStretch.png',
                          'reps': '20 reps',
                        },
                      ],
                    ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: const Color(0xFF7FAAFF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text('Start Workout', style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }

  Widget _infoCard(IconData icon, String title, String value, {Color? color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? const Color(0xFFECE9FF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.black),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const Spacer(),
          Text(value, style: const TextStyle(color: Colors.grey)),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _exerciseSetTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _exerciseItem(String name, String value, String imagePath) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(value, style: const TextStyle(color: Colors.grey)),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}
