import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const int BATCH_SIZE = 20; // バッチサイズを制限

  // JSONFileを読み込んでFirestoreにデータをインポート(lines)
  Future<void> importLinesData() async {
    try {
      // linesコレクションの存在確認
      final collectionRef = _db.collection('lines');
      final snapshot = await collectionRef.limit(1).get();

      if (snapshot.docs.isEmpty) {
        print('linesコレクションが存在しないため、新規作成します');

        // JSONファイルを読み込む
        String jsonString = await rootBundle.loadString('assets/lines.json');
        Map<String, dynamic> jsonData = json.decode(jsonString);
        List<dynamic> lines = jsonData['lines'];

        // バッチ処理の初期化
        WriteBatch batch = _db.batch();

        // linesコレクションに路線データを追加
        for (String lineName in lines) {
          DocumentReference lineRef = _db.collection('lines').doc();
          batch.set(lineRef, {
            'lineId': lineRef.id,
            'name': lineName,
          });
        }

        // バッチ処理を実行
        await batch.commit();
        print('路線データのインポートが完了しました');
      } else {
        print('linesコレクションは既に存在します');
      }
    } catch (e) {
      print('エラーが発生しました: $e');
      rethrow;
    }
  }

  Future<void> importStationData() async {
    try {
      // JSONファイルを読み込む
      String jsonString =
          await rootBundle.loadString('assets/add_station_number.json');
      List<dynamic> stationDatas = json.decode(jsonString);

      // データを小さなバッチに分割して処理
      for (var i = 0; i < stationDatas.length; i += BATCH_SIZE) {
        final int end = (i + BATCH_SIZE < stationDatas.length)
            ? i + BATCH_SIZE
            : stationDatas.length;

        await _processBatch(stationDatas.sublist(i, end));
        print('$i 件/ ${stationDatas.length} 件の駅データをインポートしました');

        // バッチ間で待機
        await Future.delayed(Duration(milliseconds: 500));
      }

      print('全ての駅データのインポートが完了しました');
    } catch (e) {
      print('エラーが発生しました: $e');
    }
  }

  // JSONFileを読み込んでFirestoreにデータをインポート(stations)
  Future<void> _processBatch(List<dynamic> batchData) async {
    WriteBatch batch = _db.batch();
    try {
      for (var stationData in batchData) {
        // 1. 駅の追加
        DocumentReference stationRef = _db.collection('stations').doc();
        batch.set(stationRef, {
          'stationId': stationRef.id,
          'name': stationData['station'],
        });

        // 2. 路線と駅の関連付け
        List<dynamic> lineNames = stationData['line_name'];
        for (var lineData in lineNames) {
          String lineName = lineData.keys.first;
          int lineNumber = lineData[lineName];

          QuerySnapshot lineQuery = await _db
              .collection('lines')
              .where('name', isEqualTo: lineName)
              .limit(1)
              .get();

          if (lineQuery.docs.isNotEmpty) {
            DocumentReference lineRef = lineQuery.docs.first.reference;
            DocumentReference stationLineRef =
                _db.collection('stationLines').doc();
            batch.set(stationLineRef, {
              'stationLineId': stationLineRef.id,
              'stationRef': stationRef,
              'lineRef': lineRef,
              'number': lineNumber,
            });
          }
        }

        // 3. 施設情報の追加
        List<String> facilities = [
          'wheelchair_accessible_elevator',
          'elevator',
          'escalator',
          'wheelchair_accessible_toilet',
          'toilet',
          'ostomate_friendly_toilet',
          'baby_seat_toilet',
          'wheelchair_accessible_slope',
          'wheelchair_accessible_chairmate',
          'guidance_blocks',
          'braille_fare_chart',
          'braille_ticket_machine',
          'staff_present',
          'coin_locker',
          'multi_purpose_toilet',
          'automatic_ticket_machine_ic_card_recharge',
          'service_center',
          'proxy_for_resident_certificate_application',
          'transportation_bureau_gallery',
          'elevator_service',
          'atm'
        ];

        for (String facilityName in facilities) {
          if (stationData[facilityName] != null) {
            DocumentReference facilityRef = _db.collection('facilities').doc();
            batch.set(facilityRef, {
              'facilityId': facilityRef.id,
              'name': facilityName,
              'state': stationData[facilityName],
              'stationRef': stationRef,
            });
          }
        }
      }

      await batch.commit();
    } catch (e) {
      print('バッチ処理中にエラーが発生しました: $e');
      rethrow;
    }
  }

  // facility　collecitionにvoteのnumを追加
  Future<void> batchddVoteNumToFacilities() async {
    try {
      await _db.runTransaction((transaction) async {
        final facilitiesSnapshot = await _db.collection('facilities').get();
        print(
            "facilitiesSnapshot.docs.length: ${facilitiesSnapshot.docs.length}");

        final allDocs = facilitiesSnapshot.docs;
        final int totalDocs = allDocs.length;
        int processedDocs = 0;

        // 500件ずつ処理
        for (var i = 0; i < allDocs.length; i += 100) {
          WriteBatch batch = _db.batch();

          // 現在のバッチで処理する範囲を計算
          final int end = (i + 100 < allDocs.length) ? i + 100 : allDocs.length;
          final currentBatch = allDocs.sublist(i, end);

          // バッチ更新を準備
          for (var facilityDoc in currentBatch) {
            batch.update(facilityDoc.reference,
                {'vote_inside_gate': 0, 'vote_outside_gate': 0, 'vote_no': 0});
          }

          await batch.commit();
          processedDocs = end;
          print('${processedDocs}/${totalDocs} ドキュメントを処理しました');
          // バッチ間で待機
          await Future.delayed(Duration(milliseconds: 500));
        }
        print('投票数の追加が完了しました');
      });
    } catch (e) {
      print('エラーが発生しました: $e');
      rethrow;
    }
  }
}
