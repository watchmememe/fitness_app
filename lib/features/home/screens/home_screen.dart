import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/features/notification/screens/notification_screen.dart';
import 'package:fitness_app/features/profile/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  Future<double?> fetchAndCalculateBMI() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = doc.data();

    if (data == null ||
        !data.containsKey('height') ||
        !data.containsKey('weight')) {
      return null;
    }

    final height = (data['height'] ?? 0).toDouble();
    final weight = (data['weight'] ?? 0).toDouble();
    if (height <= 0) return null;

    final heightM = height / 100;
    return weight / (heightM * heightM);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Stack(
                alignment: Alignment.center,
                children: [
                  const Text(
                    'Welcome Back',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NotificationScreen(),
                            ),
                          );
                        },
                        child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.notifications_none,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProfileScreen(),
                            ),
                          );
                        },
                        child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person_outline,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 📦 BMI Card (Figma-style with navigation)
              FutureBuilder<double?>(
                future: fetchAndCalculateBMI(),
                builder: (context, snapshot) {
                  final bmi = snapshot.data;

                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF87B9FF), Color(0xFFB28DFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left side text + button
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'BMI (Body Mass Index)',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _getBMICategory(bmi),
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 16),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/bmi');
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFD8A8FF),
                                        Color(0xFFB28DFF),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: const Text(
                                    'View More',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Right side BMI Value Circle
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child:
                              snapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : Text(
                                    bmi?.toStringAsFixed(1) ?? '--',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFB28DFF),
                                    ),
                                  ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Today Target
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEAF0FF), Color(0xFFD8E3FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Today Target',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF77B8FF), Color(0xFFB28DFF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Text(
                        'Check',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const DailyStatsCard(),

              const SizedBox(height: 24),

              // Workout Progress
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Workout Progress',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text('Weekly', style: TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 180, child: WorkoutProgressChart()),

              const SizedBox(height: 20),

              // 🏋️ Updated Workout Card UI
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/workouts');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFEAF0FF), Color(0xFFD8E3FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Workouts',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Latest Workouts
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Latest Workout',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text('See more', style: TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 12),
              _workoutItem(
                title: 'Fullbody Workout',
                calories: '180 Calories Burn',
                time: '20 minutes',
                imagePath: 'assets/images/FullBody.png',
                progress: 0.4,
              ),
              _workoutItem(
                title: 'Lowerbody Workout',
                calories: '200 Calories Burn',
                time: '30 minutes',
                imagePath: 'assets/images/LowBody.png',
                progress: 0.7,
              ),
              _workoutItem(
                title: 'Ab Workout',
                calories: '180 Calories Burn',
                time: '20 minutes',
                imagePath: 'assets/images/AbWorkout.png',
                progress: 0.3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _workoutItem({
    required String title,
    required String calories,
    required String time,
    required String imagePath,
    double progress = 0.6,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left avatar image
          CircleAvatar(
            radius: 30,
            backgroundColor: const Color(0xFFF4ECFF),
            backgroundImage: AssetImage(imagePath),
          ),
          const SizedBox(width: 12),

          // Title & Subtitle + Progress bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '$calories | $time',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                // Progress bar
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFB28DFF),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Right circular arrow
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Color(0xFFB28DFF)),
            ),
            child: const Icon(
              Icons.chevron_right,
              size: 18,
              color: Color(0xFFB28DFF),
            ),
          ),
        ],
      ),
    );
  }
}

class WorkoutProgressChart extends StatefulWidget {
  const WorkoutProgressChart({super.key});

  @override
  State<WorkoutProgressChart> createState() => _WorkoutProgressChartState();
}

class _WorkoutProgressChartState extends State<WorkoutProgressChart> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<FlSpot> _spots = [];

  final List<String> _daysOrder = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void initState() {
    super.initState();
    fetchChartData();
  }

  Future<void> fetchChartData() async {
    final snapshot = await _firestore.collection('workout_progress').get();

    final data =
        snapshot.docs.map((doc) {
          final day = doc['day'];
          final raw = doc['percentage'];
          final percentage =
              raw is int
                  ? raw.toDouble()
                  : raw is double
                  ? raw
                  : double.parse(raw.toString());
          final index = _daysOrder.indexOf(day);

          return FlSpot(index.toDouble(), percentage);
        }).toList();

    data.sort((a, b) => a.x.compareTo(b.x));
    setState(() => _spots = data);
  }

  @override
  Widget build(BuildContext context) {
    if (_spots.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 100,
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            spots: _spots,
            color: const Color(0xFF9D88FF),
            barWidth: 3,
            belowBarData: BarAreaData(show: false),
            dotData: FlDotData(
              show: true,
              getDotPainter:
                  (spot, _, __, ___) => FlDotCirclePainter(
                    radius: 4,
                    color: Colors.white,
                    strokeWidth: 2,
                    strokeColor: const Color(0xFF9D88FF),
                  ),
            ),
          ),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                return Text(days[value.toInt()]);
              },
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}

class DailyStatsCard extends StatelessWidget {
  const DailyStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance
              .collection('daily_stats')
              .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
              .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Text("No data for today");
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final double calories = data['calories_burned']?.toDouble() ?? 0;
        final double water = data['water_intake']?.toDouble() ?? 0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Today\'s Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    title: 'Calories',
                    value: '${calories.toInt()} kcal',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statCard(title: 'Water Intake', value: '$water L'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _statCard({required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

String _getBMICategory(double? bmi) {
  if (bmi == null) return "Loading...";
  if (bmi < 18.5) return "Underweight";
  if (bmi < 25) return "Normal weight";
  if (bmi < 30) return "Overweight";
  return "Obese";
}
