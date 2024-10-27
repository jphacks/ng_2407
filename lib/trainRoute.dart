import 'package:eki_kuguru/header.dart';
import 'package:eki_kuguru/models/models.dart';
import 'package:eki_kuguru/page_widget/dynamic_station.dart';
import 'package:eki_kuguru/service/station_service.dart';
import 'package:eki_kuguru/stationWidget.dart';
import 'package:eki_kuguru/test_widget/station_detail.dart';
import 'package:flutter/material.dart';

class MyTrainRoute extends StatefulWidget {
  const MyTrainRoute({super.key});

  @override
  _MyTrainRoute createState() => _MyTrainRoute();
}

class _MyTrainRoute extends State<MyTrainRoute> {
  final StationService _stationService = StationService();
  String? selectedLine;
  List<Station> stations = [];
  bool isLoading = false;

  // serch
  final TextEditingController _searchController = TextEditingController();

  // 路線のリスト（これはFirestoreから取得することも可能）
  final List<String> lines = [
    "愛環",
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadStations(String lineName) async {
    setState(() {
      isLoading = true; // loading
    });
    try {
      final stationsList =
          await _stationService.getStationsByLineName(lineName);
      setState(() {
        // stationsを更新
        stations = stationsList;
        isLoading = false;
      });
    } catch (e) {
      print('駅の取得に失敗しました: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('駅の取得に失敗しました: $e')),
        );
      }
    }
  }

  // 駅名で検索する関数
  Future<void> _searchStation(String stationName) async {
    if (stationName.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    try {
      final station = await _stationService.getStationbyName(stationName);

      if (station != null) {
        // 駅が見つかった場合、StationDetailPageに遷移
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StationInfoWidget(station: station),
            ),
          );
        }
      } else {
        // 駅が見つからなかった場合
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('該当する駅が見つかりませんでした')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('駅の検索中にエラーが発生しました: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(state: 0),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              "全駅から検索",
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            color: Colors.blue[300],
            thickness: 1,
            indent: 40,
            endIndent: 40,
            height: 5,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 50,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: '駅名を入力',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.blue[300]!,
                      ),
                    ),
                  ),
                  onSubmitted: (value) {
                    _searchStation(value);
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              "路線から検索",
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            color: Colors.blue[300],
            thickness: 1,
            indent: 40,
            endIndent: 40,
            height: 5,
          ),
          // 路線選択用ドロップダウン
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0), // 上下の余白を追加
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 40, // 高さを固定
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[700]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedLine,
                  isExpanded: true,
                  isDense: true, // よりコンパクトに
                  icon: const Icon(Icons.arrow_drop_down),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  itemHeight: 48, // アイテムの高さを調整
                  items: lines.map((String line) {
                    return DropdownMenuItem<String>(
                      value: line,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center, // 中央寄せ
                        children: [
                          Icon(Icons.train,
                              size: 16, color: Colors.grey[600]), // 電車アイコン
                          const SizedBox(width: 8), // アイコンとテキストの間隔
                          Text(line),
                        ],
                      ),
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
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : stations.isEmpty
                    ? const Center(
                        child: Text('駅が見つかりません'),
                      )
                    : Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:
                                List.generate(stations.length * 2 - 1, (index) {
                              if (index % 2 == 0) {
                                return DynamicStationBox(
                                  station: stations[index ~/ 2],
                                );
                              } else {
                                return VerticalDividerLine();
                              }
                            }),
                          ),
                        ),
                      ),
          ),
          Divider(
            color: Colors.blue[300],
            thickness: 1,
            indent: 40,
            endIndent: 40,
            height: 5,
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class VerticalDividerLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.0,
      width: 3.0,
      color: Colors.black,
    );
  }
}
