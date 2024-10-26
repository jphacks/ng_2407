import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

class MyStationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("駅情報")),
        body: StationInfoWidget(),
      ),
    );
  }
}

class StationInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 名古屋駅
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            '名古屋駅',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Divider(
          color: Colors.black,
          thickness: 1,
          indent: 40,
          endIndent: 40,
          height: 5,
        ),
        SizedBox(height: 10),
        // 改札内と改札外
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 改札内
            Expanded(
              child:Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '改札内設備',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                // Expanded(
                //     child: Divider(
                //       thickness: 1,
                //       color: Colors.black,
                //     ),
                // ),
                Divider(
                  color: Colors.black,
                  thickness: 1,
                  indent: 30,
                  endIndent: 30,
                  height: 10,
                ),
                Text('トイレ'),
                Text('ベンチ'),
                Text('チャージ機'),
              ],
            ),),
            // SizedBox(width: 80),
            // 改札外
            Expanded(
              child:Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '改札外設備',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Divider(
                  color: Colors.black,
                  thickness: 1,
                  indent: 30,
                  endIndent: 30,
                  height: 10,
                ),
                Text('コンビニ'),
                Text('多機能トイレ'),
              ],
            ),),
          ],
        ),
      ],
    );
  }
}

