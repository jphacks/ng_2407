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

  @override
  void initState() {
    super.initState();
    // 質問データの検証
    if (widget.questions.isEmpty || widget.id.isEmpty) {
      // 質問がない場合は前の画面に戻る
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
      });
    }
  }

  void _onRadioChanged(int value) async {
    if (_currentQuestionIndex >= widget.questions[0].length) {
      Navigator.of(context).pop();
      return;
    }
    if (value == -1) {
      if (mounted) {
        // mountedチェックを追加
        setState(() {
          _currentQuestionIndex++;
        });
      }
      // return;
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

    // mountedチェックを追加
    if (!mounted) return;
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
      if (mounted) {
        // mountedチェックを追加
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('投票の更新に失敗しました。')),
        );
      }
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   // 配列が空でないことを確認
  //   if (widget.questions.isEmpty || widget.questions[0].isEmpty) {
  //     throw Exception('Questions array cannot be empty');
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 配列の境界チェックを追加
    if (_currentQuestionIndex >= widget.questions[0].length) {
      print("Questionnaire finished");
      Navigator.of(context).pop();
      // return Container(); // または適切なエラー表示
    }

    // ビルド時にチェックを行う
    if (widget.questions.isEmpty) {
      print("Questions array cannot be empty");
      Navigator.of(context).pop();
      // return Container();
    }
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