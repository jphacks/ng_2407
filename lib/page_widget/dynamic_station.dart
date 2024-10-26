import 'package:eki_kuguru/models/models.dart';
import 'package:eki_kuguru/stationWidget.dart';
import 'package:flutter/material.dart';

class DynamicStationBox extends StatelessWidget {
  final Station station;

  const DynamicStationBox({
    required this.station,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                StationInfoWidget(station: station),
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
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        margin: const EdgeInsets.symmetric(vertical: 0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: Colors.orange, width: 4.0),
        ),
        child: Center(
          // Center を追加
          child: Text(
            station.name,
            style: const TextStyle(fontSize: 16.0, color: Colors.black),
            textAlign: TextAlign.center, // テキストを中央揃えに
          ),
        ),
      ),
    );
  }
}
