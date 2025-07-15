import 'package:fitness_app/features/auth/screens/register_screen.dart';
import 'package:fitness_app/features/bmi/screens/bim_screen.dart';
import 'package:fitness_app/features/home/screens/home_screen.dart';
import 'package:fitness_app/features/onboarding/screens/welcome_screen.dart';
import 'package:fitness_app/features/workout/screens/workout_list_screen.dart';
import 'package:fitness_app/firebase_options.dart';
import 'package:flutter/material.dart';
import 'features/auth/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const FitnessApp());
}

class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins', primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/workouts': (context) => const WorkoutListScreen(),
        '/bmi': (context) => const BMIScreen(),
      },
    );
  }
}
