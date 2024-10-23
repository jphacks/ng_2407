import 'dart:io';
import 'package:flutter/material.dart';

class MakeWidget extends StatefulWidget {
  final int index;
  final List<String> stationList;

  const MakeWidget({super.key, required this.index, required this.stationList}); // 引数の指定

  @override
  _MakeWidgetState createState() => _MakeWidgetState();
}

// ウィジェットの動的生成を行うモジュール
class _MakeWidgetState extends State<MakeWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell( // タップ可能なウィジェット
      // 画像をタップしたときの処理(のちのち追加)
      // onTap: () {
      //   // // ページへの動的遷移
      //   // Navigator.of(context).push(
      //   //   // MaterialPageRoute(builder: (context) {
      //   //   //   // return AddInfoPage(); // 駅詳細画面に遷移することを想定
      //   //   // }),
      //   // );
        
      // },
      
      child: SizedBox(
        child: Card(
          margin: const EdgeInsets.all(30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          // clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Text(widget.stationList[widget.index]), // テキストを表示
        ),
      ),
    );
  }
}
