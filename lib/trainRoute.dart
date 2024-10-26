import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

class MyTrainRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("駅情報")),
        body: TrainRouteWidget(),
      ),
    );
  }
}

class TrainRouteWidget extends StatelessWidget {
  // 駅名
  final List<String> stations = [
    '名古屋駅',
    '金山駅',
    '千種駅',
    '本山駅',
    '栄駅',
    '伏見駅',
    '川名駅',
    '塩釜口駅',
    '名古屋大学駅',
    '名古屋駅',
    '名古屋駅',
    '名古屋駅',
    '名古屋駅',
    '名古屋駅',
    '名古屋駅',
    '名古屋駅',
    '名古屋駅',
    '名古屋駅',
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(stations.length * 2 - 1, (index) {
            // 奇数インデックスに線、偶数インデックスに駅名を表示
            if (index % 2 == 0) {
              return StationBox(stationName: stations[index ~/ 2]);
            } else {
              return VerticalDividerLine();
            }
          }),
        ),
      )
    );
  }
}

class StationBox extends StatelessWidget {
  final String stationName;

  const StationBox({required this.stationName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.orange, width: 5.0),
      ),
      child: Text(
        stationName,
        style: TextStyle(fontSize: 16.0, color: Colors.black),
      ),
    );
  }
}

class VerticalDividerLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.0,
      width: 3.0,
      color: Colors.black,
    );
  }
}
