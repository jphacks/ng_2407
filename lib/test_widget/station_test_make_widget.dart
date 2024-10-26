import 'dart:io';
import 'package:eki_kuguru/models/models.dart';
import 'package:eki_kuguru/service/station_service.dart';
import 'package:eki_kuguru/stationWidget.dart';
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // タップ可能なウィジェット
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                StationInfoWidget(station: widget.stationList[widget.index]),
            // pageBuilder: (context, animation, secondaryAnimation) =>
            //     StationDetailPage(station: widget.stationList[widget.index]),
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
