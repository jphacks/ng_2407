import 'package:flutter/material.dart';

import 'service/station_service.dart';

class Questionarie extends StatefulWidget {
  final String stationName;
  final List<List<String>> questions;
  final List<List<String>> id;

  const Questionarie(
      {super.key,
      required this.stationName,
      required this.questions,
      required this.id});

  @override
  _QuestionarieState createState() => _QuestionarieState();
}

class _QuestionarieState extends State<Questionarie> {
  int _currentQuestionIndex = 0;
  final int _selectedValue = 1;
  List<List<Map<String, int>>> response = [];

  StationService service = StationService();

  void _onRadioChanged(int value) async {
    if (value == -1) {
      setState(() {
        _currentQuestionIndex++;
      });
    }

    bool success = await service.updateFacilityVote(
      stationName: widget.stationName,
      voteUpdates: [
        {
          "facilityName": widget.id[_currentQuestionIndex % 2]
              [_currentQuestionIndex % 2],
          "add_vote": value
        }
      ],
    );

    if (success) {
      setState(() {
        response.add([
          {
            widget.id[_currentQuestionIndex % 2][_currentQuestionIndex % 2]:
                value
          }
        ]);

        if (_currentQuestionIndex < widget.questions.length - 1) {
          _currentQuestionIndex++;
        } else {
          Navigator.of(context).pop();
        }
      });
    } else {
      // エラーハンドリング
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('投票の更新に失敗しました。')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 300,
          width: 300,
          color: const Color(0xFFE0E0E0),
          child: Center(
            child: Column(
              children: [
                Text("${widget.stationName}駅にある設備について"),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return RotationTransition(
                      turns: animation,
                      child: child,
                    );
                  },
                  child: Column(
                    children: [
                      Text(
                        "${widget.questions[_currentQuestionIndex % 2][_currentQuestionIndex % 2]}はありますか？",
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: InkWell(
                              onTap: () {
                                _onRadioChanged(2);
                              },
                              child: Container(
                                child: const Text("改札外にある"),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: InkWell(
                              onTap: () {
                                _onRadioChanged(1);
                              },
                              child: Container(
                                child: const Text("改札内にある"),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 40, right: 40),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: InkWell(
                              onTap: () {
                                _onRadioChanged(3);
                              },
                              child: Container(
                                child: const Text("ない"),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: InkWell(
                              onTap: () {
                                _onRadioChanged(-1);
                              },
                              child: Container(
                                child: const Text("わからない"),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class QuestionariePage extends StatelessWidget {
//   const QuestionariePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Test Page'),
//       ),
//       backgroundColor: const Color.fromARGB(255, 152, 56, 56),
//       body: 

//         Stack(
//         children: [
//           Container(
//             color: const Color.fromARGB(255, 152, 56, 56),
//             child: const Text('Test Page'),
//           ),
//           Container(
//             color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
//             child:const Center(
//               child: Questionarie(
//                 stationName: "Station Name",
//                 questions: [['Question 1', 'Question 2', 'Question 3', 'Question 4', 'Question 5']],
//                 id: [['1', '2', '3', '4', '5']],
//               ),
//             ),
//           ),
//         ]
//       ),
//     );
//   }
// }