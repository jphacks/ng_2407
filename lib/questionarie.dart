import 'package:flutter/material.dart';

class Questionarie extends StatefulWidget {
  final String stationName;
  final List<String> questions;

  const Questionarie({super.key, required this.stationName, required this.questions});

  @override
  _QuestionarieState createState() => _QuestionarieState();
}

class _QuestionarieState extends State<Questionarie> {
  int _currentQuestionIndex = 0;
  int _selectedValue = 1;

  void _onRadioChanged(int? value) {
    setState(() {
      _selectedValue = value!;
      if (_currentQuestionIndex < widget.questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        // 全ての質問が終わった場合の処理
        _currentQuestionIndex = 0; // 例えば最初の質問に戻る
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 300,
      color: const Color(0xFFE0E0E0),
      child: Center(child:Column(
        children: [
          Text(widget.stationName),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return RotationTransition(
                turns: animation,
                child: child,
              );
            },
            child: Column(
              key: ValueKey<int>(_currentQuestionIndex),
              children: [
                Text(widget.questions[_currentQuestionIndex]),
                Row(
                  children: [
                    Radio(
                      value: 1,
                      groupValue: _selectedValue,
                      onChanged: _onRadioChanged,
                    ),
                    Radio(
                      value: 2,
                      groupValue: _selectedValue,
                      onChanged: _onRadioChanged,
                    ),
                    Radio(
                      value: 3,
                      groupValue: _selectedValue,
                      onChanged: _onRadioChanged,
                    ),
                    Radio(
                      value: 4,
                      groupValue: _selectedValue,
                      onChanged: _onRadioChanged,
                    ),
                    Radio(
                      value: 5,
                      groupValue: _selectedValue,
                      onChanged: _onRadioChanged,
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
      ),
    ),
    );
  }
}