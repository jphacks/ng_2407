import 'package:flutter/material.dart';
import 'questionarie.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Page'),
      ),
      body: Center(
        child: Questionarie(
          stationName: "Station Name",
          questions: ['Question 1', 'Question 2', 'Question 3', 'Question 4', 'Question 5'],
        ),
      ),
    );
  }
}