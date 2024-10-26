import 'dart:io';
import 'package:eki_kuguru/models/models.dart';
import 'package:eki_kuguru/service/station_service.dart';
import 'package:eki_kuguru/test_widget/station_detail.dart';
import 'package:flutter/material.dart';

class StationTestMakeWidget extends StatefulWidget {
  final int index;
  final List<Station> stationList;

  const StationTestMakeWidget(
      {super.key, required this.index, required this.stationList}); // 引数の指定

  @override
  _StationTestMakeWidgetState createState() => _StationTestMakeWidgetState();
}

// ウィジェットの動的生成を行うモジュール
class _StationTestMakeWidgetState extends State<StationTestMakeWidget> {
  final StationService _stationService = StationService();

  // Future<void> _onStationTap(Station station) async {
  //   try {
  //     // 駅詳細情報を取得
  //     final stationDetail = await _stationService.getStationDetailBystationId(
  //         station.stationId, station.name);

  //     if (stationDetail != null) {
  //       // 駅詳細画面に遷移
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) =>
  //               StationDetailPage(stationDetail: stationDetail),
  //         ),
  //       );
  //     } else {
  //       print('駅詳細の取得に失敗しました');
  //     }
  //   } catch (e) {
  //     print('駅の詳細情報の取得に失敗しました: $e');
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('駅の詳細情報の取得に失敗しました: $e')),
  //       );
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // タップ可能なウィジェット
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                StationDetailPage(station: widget.stationList[widget.index]),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOutCubic;
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      },

      child: SizedBox(
        child: Card(
          margin: const EdgeInsets.all(30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          // clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Text(widget.stationList[widget.index].name), // テキストを表示
        ),
      ),
    );
  }
}
