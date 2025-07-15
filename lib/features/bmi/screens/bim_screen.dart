import 'package:flutter/material.dart';

class BMIScreen extends StatelessWidget {
  const BMIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("BMI Details")),
      body: const Center(child: Text("This is the BMI screen")),
    );
  }
}
