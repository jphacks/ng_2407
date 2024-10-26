import 'package:flutter/material.dart';
import '../page_widget/questionarie.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Page'),
      ),
      body: const Center(
        child: Questionarie(
          stationName: "Station Name",
          questions: ['Question 1', 'Question 2', 'Question 3', 'Question 4', 'Question 5'],
        ),
      ),
    );
  }
}