import 'dart:io';
import 'package:eki_kuguru/displayMap.dart';
import 'package:eki_kuguru/line_station.dart';
import 'package:eki_kuguru/trainRoute.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final int state;

  const Header({super.key, required this.state}); // 引数の指定

  @override
  Size get preferredSize => Size.fromHeight(65.0); // AppBarの高さを指定

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
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
        preferredSize: Size.fromHeight(45.0),
        child: Padding(
          // 上部のパディングを減らして間隔を調整
          padding: EdgeInsets.only(bottom: 6.0),
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
                child: Container(
                  width: 130, // 固定の幅を指定
                  height: 40, // 固定の高さを指定
                  margin: const EdgeInsets.only(left: 20),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    // clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(4.0),
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
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue[300],
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Image.asset(
                    'assets/logo_image.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              InkWell(
                // タップ可能なウィジェット
                // 画像をタップしたときの処理(のちのち追加)
                onTap: () {
                  // ページへの動的遷移
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return MapApp(); // 駅詳細画面に遷移することを想定
                    }),
                  );
                },
                child: Container(
                  width: 130, // 固定の幅を指定
                  height: 40, // 固定の高さを指定
                  margin: const EdgeInsets.only(right: 20),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    // clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.map, size: 20),
                              SizedBox(width: 8),
                              Text("地図から"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
