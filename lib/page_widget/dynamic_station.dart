import 'package:eki_kuguru/models/models.dart';
import 'package:eki_kuguru/service/station_service.dart';
import 'package:eki_kuguru/stationWidget.dart';
import 'package:flutter/material.dart';

class DynamicStationBox extends StatefulWidget {
  final Station station;

  const DynamicStationBox({
    required this.station,
    Key? key,
  }) : super(key: key);

  @override
  State<DynamicStationBox> createState() => _DynamicStationBoxState();
}

class _DynamicStationBoxState extends State<DynamicStationBox> {
  int? toiletState;
  final StationService _stationService = StationService();
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _isDisposed = false;
    _loadToiletState();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> _loadToiletState() async {
    try {
      if (!_isDisposed) {
        final state = await _stationService.getToiletState(widget.station);
        // disposeされていない場合のみsetStateを呼び出す
        setState(() {
          toiletState = state;
        });
      }
    } catch (e) {
      if (!_isDisposed) {
        print('トイレの状態読み込み中にエラーが発生しました: $e');
      }
    }
  }

  Widget _buildToiletIconWithLabel(bool isVisible, String label) {
    return SizedBox(
      width: 40.0, // アイコンの幅と同じ
      height: 35.0, // アイコン + ラベルの高さ
      child: isVisible
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10.0,
                    color: Colors.grey,
                  ),
                ),
                const Icon(
                  Icons.wc,
                  size: 19.0,
                  color: Colors.grey,
                ),
              ],
            )
          : Container(), // 透明なコンテナでスペースを確保
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                StationInfoWidget(station: widget.station),
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
        height: 55.0,
        margin: const EdgeInsets.symmetric(vertical: 0),
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: Colors.orange, width: 4.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 改札内トイレアイコン（状態が2または4の場合）
            _buildToiletIconWithLabel(
              toiletState == 2 || toiletState == 4,
              '改札内',
            ),

            SizedBox(width: 6.0),
            // 駅名
            Flexible(
              child: Text(
                widget.station.name,
                style: const TextStyle(fontSize: 16.0, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(width: 6.0),
            // 改札外トイレアイコン
            _buildToiletIconWithLabel(
              toiletState == 3 || toiletState == 4,
              '改札外',
            ),
          ],
        ),
      ),
    );
  }
}
