import 'dart:io';
import 'package:eki_kuguru/line_station.dart';
import 'package:eki_kuguru/trainRoute.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final int state;

  const Header({super.key, required this.state}); // 引数の指定

  @override
  Size get preferredSize => Size.fromHeight(70.0); // AppBarの高さを指定

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.train_outlined, // ゲートのアイコンを追加
            color: Colors.white,
            size: 20,
          ),
          SizedBox(width: 8), // アイコンとテキストの間隔
          Text(
            '駅くぐる',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'TrainOne',
              color: Colors.white,
            ),
          ),
        ],
      ),
      centerTitle: true,
      backgroundColor: Colors.blue[300],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              // タップ可能なウィジェット
              // 画像をタップしたときの処理(のちのち追加)
              onTap: () {
                // ページへの動的遷移
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return MyTrainRoute(); // 駅詳細画面に遷移することを想定
                  }),
                );
              },
              child: SizedBox(
                // width: 200, // 幅を固定
                // height: 60, // 高さを固定
                child: Card(
                  margin: const EdgeInsets.only(
                      top: 0, bottom: 10, right: 30, left: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  // clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.search, size: 20),
                            SizedBox(width: 8),
                            Text("駅一覧から"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              // タップ可能なウィジェット
              // 画像をタップしたときの処理(のちのち追加)
              onTap: () {
                // // ページへの動的遷移
                // Navigator.of(context).push(
                //   // MaterialPageRoute(builder: (context) {
                //   //   // return AddInfoPage(); // 駅詳細画面に遷移することを想定
                //   // }),
                // );
              },
              child: Card(
                margin: const EdgeInsets.only(
                    top: 0, bottom: 10, right: 30, left: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                // clipBehavior: Clip.antiAliasWithSaveLayer,
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.map, size: 20),
                          SizedBox(width: 8),
                          Text("地図から"),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 1,
                      indent: 10,
                      endIndent: 10,
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
