import 'dart:io';
import 'package:eki_kuguru/service/line_station.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final int state;

  const Header({super.key, required this.state}); // 引数の指定

  @override
  Size get preferredSize => const Size.fromHeight(100.0); // AppBarの高さを指定

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Header'),
      centerTitle: true,
      backgroundColor: Colors.green,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: Row(
          children: [
            InkWell(
              // タップ可能なウィジェット
              // 画像をタップしたときの処理(のちのち追加)
              onTap: () {
                // ページへの動的遷移
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return const LineStationPage(); // 駅詳細画面に遷移することを想定
                  }),
                );
              },
              child: SizedBox(
                child: Card(
                  margin: const EdgeInsets.all(30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  // clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: const Text("駅一覧から調べる"), // テキストを表示
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
              child: SizedBox(
                child: Card(
                  margin: const EdgeInsets.all(30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  // clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: const Text("地図から調べる"), // テキストを表示
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
