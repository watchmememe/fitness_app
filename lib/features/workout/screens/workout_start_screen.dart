import 'dart:async';
import 'package:flutter/material.dart';

class WorkoutStartScreen extends StatefulWidget {
  final List<Map<String, String>> exercises;

  const WorkoutStartScreen({super.key, required this.exercises});

  @override
  State<WorkoutStartScreen> createState() => _WorkoutStartScreenState();
}

class _WorkoutStartScreenState extends State<WorkoutStartScreen> {
  int currentIndex = 0;
  Timer? _timer;
  int _remainingSeconds = 0;
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    _checkIfTimeBased();
  }

  void _checkIfTimeBased() {
    final reps = widget.exercises[currentIndex]['reps']!;
    if (_isTimeFormat(reps)) {
      final parts = reps.split(':');
      _remainingSeconds = int.parse(parts[0]) * 60 + int.parse(parts[1]);
      _startTimer();
    }
  }

  bool _isTimeFormat(String reps) => reps.contains(':');

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isPaused) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            _nextExercise();
          }
        });
      }
    });
  }

  void _pauseTimer() => setState(() => isPaused = true);
  void _resumeTimer() => setState(() => isPaused = false);

  void _restartTimer() {
    final reps = widget.exercises[currentIndex]['reps']!;
    final parts = reps.split(':');
    setState(() {
      _remainingSeconds = int.parse(parts[0]) * 60 + int.parse(parts[1]);
      isPaused = false;
    });
  }

  void _nextExercise() {
    _timer?.cancel();
    if (currentIndex < widget.exercises.length - 1) {
      setState(() {
        currentIndex++;
        isPaused = false;
      });
      _checkIfTimeBased();
    } else {
      _showFinishDialog();
    }
  }

  void _showFinishDialog() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Finished!'),
            content: const Text('You have completed all exercises.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final min = (seconds ~/ 60).toString().padLeft(2, '0');
    final sec = (seconds % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercises[currentIndex];
    final isTimeBased = _isTimeFormat(exercise['reps']!);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    'Pose ${currentIndex + 1} / ${widget.exercises.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const Icon(Icons.more_horiz),
                ],
              ),
            ),

            const Spacer(),

            // Image
            CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage(exercise['image']!),
            ),
            const SizedBox(height: 24),

            // Exercise name
            Text(
              exercise['name']!,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // Reps or Timer
            Text(
              isTimeBased ? _formatTime(_remainingSeconds) : exercise['reps']!,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),

            const Spacer(),

            // Buttons
            if (isTimeBased)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: _restartTimer,
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      side: const BorderSide(color: Color(0xFF7FAAFF)),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 28,
                      ),
                    ),
                    child: const Text(
                      'Restart',
                      style: TextStyle(
                        color: Color(0xFF7FAAFF),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: isPaused ? _resumeTimer : _pauseTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7FAAFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 28,
                      ),
                    ),
                    child: Text(
                      isPaused ? 'Resume' : 'Pause',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              )
            else
              ElevatedButton(
                onPressed: _nextExercise,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7FAAFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 40,
                  ),
                ),
                child: const Text('Next', style: TextStyle(fontSize: 16)),
              ),

            const SizedBox(height: 12),

            TextButton(
              onPressed: _nextExercise,
              child: const Text('Skip', style: TextStyle(color: Colors.grey)),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
