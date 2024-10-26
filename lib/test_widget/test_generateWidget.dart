import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'makeWidget.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override 
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  List<String> chuoLineStationList = ["名古屋駅","金山駅","鶴舞駅","千種駅","大曾根駅"];
  List<String> meijoLineStationList = ["栄駅","矢場町駅","上前津駅","東別院駅","金山駅"];

  late List<String> stationList;
  @override
  void initState() {
    super.initState();
    // 初期値を中央線の駅リストに設定
    stationList = chuoLineStationList;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('動的生成サンプル'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 5,
            childAspectRatio: 0.8,
          ),
        itemCount: chuoLineStationList.length+1,
        itemBuilder: (context, index){
          // 切り替えテスト用(else内のみを本番は想定)
          if (index>=stationList.length){
            return InkWell(
              onTap: () {
                setState( () {
                  if (stationList == chuoLineStationList){
                    stationList = meijoLineStationList;
                  } else {
                    stationList = chuoLineStationList;
                  }
                });
              },
              child: SizedBox(
                child: Card(
                  margin: const EdgeInsets.all(30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
                    child:Center(
                            child: Text("チェンジ",style: TextStyle(fontSize: 20.0)),
                          ),
                  ),
                ),
              ),
            );
          } else {
            return MakeWidget(index: index, stationList: stationList);
          }
        },
      ),
    );
  }
}