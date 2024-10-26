import 'package:eki_kuguru/makeWidget.dart';
import 'package:eki_kuguru/models/models.dart';
import 'package:eki_kuguru/service/station_service.dart';
import 'package:flutter/material.dart';

class LineStationPage extends StatefulWidget {
  const LineStationPage({super.key});

  @override
  _LineStationState createState() => _LineStationState();
}

class _LineStationState extends State<LineStationPage> {
  final StationService _stationService = StationService();
  String? selectedLine;
  List<Station> stations = [];

  // 路線のリスト（これはFirestoreから取得することも可能）
  final List<String> lines = [
    "太多線",
    "瀬戸線",
    "三河線（知立～猿投）",
    "武豊線",
    "犬山線",
    "JR東海道本線",
    "紀勢本線",
    "常滑線・空港線",
    "広見線",
    "名城線",
    "名松線",
    "関西本線",
    "愛環",
    "三河線（知立～碧南）",
    "西尾線",
    "蒲郡線",
    "豊川線",
    "小牧線",
    "桜通線",
    "飯田線",
    "鶴舞線",
    "豊田線",
    "竹鼻線・羽島線",
    "津島線・尾西線（津島～弥富）",
    "尾西線（玉ノ井方面）",
    "尾西線（津島方面）",
    "名港線",
    "築港線",
    "中央本線",
    "東山線",
    "上飯田線",
    "名古屋本線",
    "参宮線",
    "各務原線",
    "高山本線",
    "河和線",
    "知多新線"
  ];

  @override
  void initState() {
    super.initState();
    selectedLine = lines.first;
    _loadStations(selectedLine!);
  }

  Future<void> _loadStations(String lineName) async {
    try {
      final stationsList =
          await _stationService.getStationsByLineName(lineName);
      setState(() {
        stations = stationsList;
      });
    } catch (e) {
      print('駅の取得に失敗しました: $e');
      // エラー処理（必要に応じてユーザーに通知）
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('駅情報'),
      ),
      body: Column(
        children: [
          // 路線選択用ドロップダウン
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              value: selectedLine,
              isExpanded: true,
              items: lines.map((String line) {
                return DropdownMenuItem<String>(
                  value: line,
                  child: Text(line),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedLine = newValue;
                  });
                  _loadStations(newValue);
                }
              },
            ),
          ),
          // 駅のグリッド表示
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 5,
                childAspectRatio: 0.8,
              ),
              itemCount: stations.length,
              itemBuilder: (context, index) {
                return MakeWidget(
                  index: index,
                  stationList: stations.map((s) => s.name).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
