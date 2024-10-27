import 'package:eki_kuguru/header.dart';
import 'package:eki_kuguru/models/models.dart';
import 'package:eki_kuguru/service/station_service.dart';
import 'package:flutter/material.dart';
import 'questionariePage.dart';

class StationInfoWidget extends StatefulWidget {
  final Station station;

  const StationInfoWidget({
    super.key,
    required this.station,
  });

  @override
  State<StationInfoWidget> createState() => _StationInfoWidgetState();
}

class _StationInfoWidgetState extends State<StationInfoWidget> {
  final StationService _stationService = StationService();
  StationDetail? _stationDetail;
  bool _isLoading = true;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _loadStationDetail();
  }

  Future<void> _loadStationDetail() async {
    try {
      final detail = await _stationService.getStationDetailBystationId(
        widget.station.stationId,
        widget.station.name,
      );
      if (mounted) {
        setState(() {
          _stationDetail = detail;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('駅の詳細情報の取得に失敗しました: $e')),
        );
      }
    }
  }

  // 施設の状態によって振り分けたリストを取得
  Map<String, List<String>> _getFacilitiesByState() {
    final insideFacilities = <String>[];
    final outsideFacilities = <String>[];
    final otherFacilities = <String>[];
    final noFacilities = <String>[];
    final unknownFacilities = <String>[];

    if (_stationDetail != null) {
      for (var facility in _stationDetail!.facilities) {
        // print(facility.name);
        // print(facility.state);
        switch (facility.state) {
          case 4: // 改札内、改札外両方ある
            insideFacilities.add(facility.name);
            outsideFacilities.add(facility.name);
            break;
          case 2: // 改札内
            insideFacilities.add(facility.name);
            break;
          case 3: // 改札外
            outsideFacilities.add(facility.name);
            break;
          case 1: // あり(情報求む)
            otherFacilities.add(facility.name);
            break;
          case 0: // わからない
            unknownFacilities.add(facility.name);
            break;
          default: // なし
            noFacilities.add(facility.name);
        }
      }
    }

    return {
      'inside': insideFacilities,
      'outside': outsideFacilities,
      'other': otherFacilities,
      'no': noFacilities,
      'unknown': unknownFacilities,
    };
  }

  // 英語と日本語の対応マップを作成
  final Map<String, String> facilityNameMap = {
    'wheelchair_accessible_elevator': '車いす対応エレベータ',
    'elevator': 'エレベータ',
    'escalator': 'エスカレータ',
    'wheelchair_accessible_toilet': '車いす対応トイレ',
    'toilet': 'トイレ',
    'ostomate_friendly_toilet': 'オストメイト対応トイレ',
    'baby_seat_toilet': 'ベビーシート対応トイレ',
    'wheelchair_accessible_slope': '車いす対応スロープ',
    'wheelchair_accessible_chairmate': '車いす対応チェアメイト',
    'guidance_blocks': '誘導ブロック',
    'braille_fare_chart': '点字運賃表',
    'braille_ticket_machine': '点字券売機',
    'staff_present': '駅員配置',
    'multi_purpose_toilet': '多目的トイレ',
    'elevator_service': 'エレベーターサービス',
    'transportation_bureau_gallery': '交通局ギャラリー',
    'coin_locker': 'コインロッカー',
    'atm': 'ATM',
    'service_center': 'サービスセンター',
    'proxy_for_resident_certificate_application': '住民票の写し等の申請・交付取次',
    'automatic_ticket_machine_ic_card_recharge': '自動券売機・ICカードチャージ'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(state: 0),
      body: Stack(alignment:const Alignment(1, 1),children:[Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 駅駅
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              widget.station.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(
            color: Colors.black,
            thickness: 1,
            indent: 40,
            endIndent: 40,
            height: 5,
          ),
          const SizedBox(height: 10),
          // 改札内と改札外
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 改札内
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            '改札内設備',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const Divider(
                            color: Colors.black,
                            thickness: 1,
                            indent: 30,
                            endIndent: 30,
                            height: 10,
                          ),
                          SizedBox(
                            height: 100, // 高さを固定値で指定
                            child: SingleChildScrollView(
                              child: Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                alignment: WrapAlignment.center,
                                children: (_getFacilitiesByState()['inside'] ??
                                        [])
                                    .map((facility) => Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 2),
                                          margin: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: Colors.green[50],
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                                color: Colors.green[200]!),
                                          ),
                                          child: Text(
                                            facilityNameMap[facility] ??
                                                facility,
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 改札外
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            '改札外設備',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const Divider(
                            color: Colors.black,
                            thickness: 1,
                            indent: 30,
                            endIndent: 30,
                            height: 10,
                          ),
                          SizedBox(
                            height: 100, // 高さを固定値で指定
                            child: SingleChildScrollView(
                              child: Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                alignment: WrapAlignment.center,
                                children: (_getFacilitiesByState()['outside'] ??
                                        [])
                                    .map((facility) => Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 2),
                                          margin: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: Colors.green[50],
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                                color: Colors.green[200]!),
                                          ),
                                          child: Text(
                                            facilityNameMap[facility] ??
                                                facility,
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 10),
          Expanded(
            child: Column(
              children: [
                // 固定ヘッダー部分
                const Column(
                  children: [
                    Text(
                      '設備あり',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '情報求め中',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 1,
                      indent: 40,
                      endIndent: 30,
                    ),
                  ],
                ),
                // スクロール可能なリスト部分
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      alignment: WrapAlignment.center,
                      children: [
                        if ((_getFacilitiesByState()['other'] ?? [])
                            .isNotEmpty) ...[
                          ...(_getFacilitiesByState()['other'] ?? [])
                              .map((facility) {
                            final japaneseText =
                                facilityNameMap[facility] ?? facility;
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.blue[200]!),
                              ),
                              child: Text(
                                japaneseText,
                                style: const TextStyle(fontSize: 14),
                              ),
                            );
                          }),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Column(
              children: [
                // 固定ヘッダー部分
                const Column(
                  children: [
                    Text(
                      '設備無し',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 1,
                      indent: 40,
                      endIndent: 30,
                    ),
                  ],
                ),
                // スクロール可能なリスト部分
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      alignment: WrapAlignment.center,
                      children: [
                        if ((_getFacilitiesByState()['no'] ?? [])
                            .isNotEmpty) ...[
                          ...(_getFacilitiesByState()['no'] ?? [])
                              .map((facility) {
                            final japaneseText = facilityNameMap[facility];
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Text(
                                '$japaneseText',
                                style: const TextStyle(fontSize: 14),
                              ),
                            );
                          }),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Column(
              children: [
                // 固定ヘッダー部分
                const Column(
                  children: [
                    Text(
                      '不明',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '情報求め中',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 1,
                      indent: 40,
                      endIndent: 30,
                    ),
                  ],
                ),
                // スクロール可能なリスト部分
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      alignment: WrapAlignment.center,
                      children: [
                        if ((_getFacilitiesByState()['unknown'] ?? [])
                            .isNotEmpty) ...[
                          ...(_getFacilitiesByState()['unknown'] ?? [])
                              .map((facility) {
                            final japaneseText = facilityNameMap[facility];
                            facility;
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.orange[50],
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.orange[200]!),
                              ),
                              child: Text(
                                '$japaneseText',
                                style: const TextStyle(fontSize: 14),
                              ),
                            );
                          }),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      (_isVisible)?Align(
        alignment: Alignment.bottomRight,
        child: InkWell(
          onTap: () async {
            final facilitiesByState = _getFacilitiesByState();
            final facilitiesOt = facilitiesByState['other'] ?? [];
            final facilitiesUn = facilitiesByState['unknown'] ?? [];
            
            List<String> facilityNamesOt = [];
            List<String> facilityNamesUn = [];
            
            if (facilitiesOt.isNotEmpty) {
              facilityNamesOt = facilitiesOt.map((facility) {
                return facilityNameMap[facility] ?? '不明な施設';
              }).toList();
            }
            
            if (facilitiesUn.isNotEmpty) {
              facilityNamesUn = facilitiesUn.map((facility) {
                return facilityNameMap[facility] ?? '不明な施設';
              }).toList();
            }
            
            List<List<String>> facilitiesJP = [
              facilityNamesOt,
              facilityNamesUn,
            ];
            List<List<String>> facilitiesName = [
              facilitiesOt,
              facilitiesUn,
            ];
            
            
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Questionarie(
                stationName: widget.station.name,
                questions: facilitiesJP,
                id: facilitiesName,
              ),
            ));
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(bottom: 20, right: 20),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height:15),
                Icon(
                  Icons.question_mark,
                  color: Colors.white,
                ),
                SizedBox(height: 15), // アイコンとテキストの間にスペースを追加
                Text(
                  '情報を追加する',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ):Align(
        alignment: Alignment.bottomRight,
        child: Container(),
      ),
      (_isVisible)?InkWell(
        onTap: () {
          setState((){
            _isVisible = false;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.only(bottom: 90, right: 10),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
          child:const Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
      ):Container(),
      ]
      ),
    );
  }
}
