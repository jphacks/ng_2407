import 'package:eki_kuguru/makeWidget.dart';
import 'package:eki_kuguru/models/models.dart';
import 'package:eki_kuguru/service/station_service.dart';
import 'package:eki_kuguru/test_widget/station_detail.dart';
import 'package:eki_kuguru/test_widget/station_test_make_widget.dart';
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
              builder: (context) => StationDetailPage(station: station),
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

  Future<void> _loadStations(String lineName) async {
    setState(() {
      isLoading = true; // loading
    });
    try {
      final stationsList =
          await _stationService.getStationsByLineName(lineName);
      setState(() {
        stations = stationsList;
        isLoading = false;
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
          // 検索バー
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '駅名を入力してください',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onSubmitted: (value) {
                _searchStation(value);
              },
            ),
          ),
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
            child: isLoading
                ? const Center(
                    // loading
                    child: CircularProgressIndicator(),
                  )
                : stations.isEmpty
                    ? const Center(
                        // データが空の場合の表示
                        child: Text('駅が見つかりません'),
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 5,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: stations.length,
                        itemBuilder: (context, index) {
                          return StationTestMakeWidget(
                            index: index,
                            stationList: stations,
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
