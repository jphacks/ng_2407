import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eki_kuguru/models/models.dart';

class StationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 路線名から駅のリストを取得する
  Future<List<Station>> getStationsByLineName(String lineName) async {
    try {
      // 路線名から該当するlineのドキュメントを取得
      final lineSnapshot = await _firestore
          .collection('lines')
          .where('name', isEqualTo: lineName)
          .get();

      if (lineSnapshot.docs.isEmpty) {
        throw Exception('路線が見つかりません: $lineName');
      }

      final lineRef = lineSnapshot.docs.first.reference;

      // stationLinesから該当する路線の情報を取得（numberの順でソート）
      final stationLinesSnapshot = await _firestore
          .collection('stationLines')
          .where('lineRef', isEqualTo: lineRef)
          .orderBy('number')
          .get();

      // 駅情報を格納するリスト
      List<Station> stations = [];

      // 各stationLineに対して、対応する駅の情報を取得
      for (var stationLine in stationLinesSnapshot.docs) {
        DocumentReference stationRef = stationLine.data()['stationRef'];
        final stationDoc = await stationRef.get();

        if (stationDoc.exists) {
          stations.add(Station.fromMap(
            stationDoc.data() as Map<String, dynamic>,
            stationDoc.id,
          ));
        }
      }

      return stations;
    } catch (e) {
      print('エラーが発生しました: $e');
      throw e;
    }
  }

  // 駅名から駅の情報を取得する(Stationを返す)
  Future<Station?> getStationbyName(String stationName) async {
    try {
      final stationSnapshot = await _firestore
          .collection('stations')
          .where('name', isEqualTo: stationName)
          .get();

      if (stationSnapshot.docs.isEmpty) {
        return null;
      }

      final stationDoc = stationSnapshot.docs.first;
      return Station.fromMap(stationDoc.data() as Map<String, dynamic>,
          stationDoc.id); // Stationを返す
    } catch (e) {
      print('エラーが発生しました: $e');
      throw e;
    }
  }

  // 駅名から施設と路線情報を取得する(StationDetailを返す)
  Future<StationDetail?> getStationDetailByName(String stationName) async {
    try {
      // 駅名から駅を検索
      final stationSnapshot = await _firestore
          .collection('stations')
          .where('name', isEqualTo: stationName)
          .get();

      if (stationSnapshot.docs.isEmpty) {
        return null;
      }

      final stationDoc = stationSnapshot.docs.first;
      final station = Station.fromMap(stationDoc.data(), stationDoc.id);

      // 施設情報の取得
      final facilitiesSnapshot = await _firestore
          .collection('facilities')
          .where('stationRef', isEqualTo: stationDoc.reference)
          .get();

      List<Facility> facilities = facilitiesSnapshot.docs
          .map((doc) => Facility.fromMap(doc.data(), doc.id))
          .toList();

      // stationLinesから路線情報を取得
      final stationLinesSnapshot = await _firestore
          .collection('stationLines')
          .where('stationRef', isEqualTo: stationDoc.reference)
          .get();

      List<Line> lines = [];
      for (var stationLine in stationLinesSnapshot.docs) {
        DocumentReference lineRef = stationLine.data()['lineRef'];
        final lineDoc = await lineRef.get();
        if (lineDoc.exists) {
          lines.add(Line.fromMap(
            lineDoc.data() as Map<String, dynamic>,
            lineDoc.id,
          ));
        }
      }

      return StationDetail(
        station: station,
        facilities: facilities,
        lines: lines,
      );
    } catch (e) {
      print('エラーが発生しました: $e');
      throw e;
    }
  }

  // stationid, stationNameから施設と路線情報を取得する
  Future<StationDetail?> getStationDetailBystationId(
      String stationid, String stationName) async {
    try {
      DocumentReference stationRef =
          _firestore.collection('stations').doc(stationid);

      Station station = Station.fromIdName(stationName, stationid);
      // 施設情報の取得
      final facilitiesSnapshot = await _firestore
          .collection('facilities')
          .where('stationRef', isEqualTo: stationRef)
          .get();

      List<Facility> facilities = facilitiesSnapshot.docs
          .map((doc) => Facility.fromMap(doc.data(), doc.id))
          .toList();

      // stationLinesから路線情報を取得
      final stationLinesSnapshot = await _firestore
          .collection('stationLines')
          .where('stationRef', isEqualTo: stationRef)
          .get();

      List<Line> lines = [];
      for (var stationLine in stationLinesSnapshot.docs) {
        DocumentReference lineRef = stationLine.data()['lineRef'];
        final lineDoc = await lineRef.get();
        if (lineDoc.exists) {
          lines.add(Line.fromMap(
            lineDoc.data() as Map<String, dynamic>,
            lineDoc.id,
          ));
        }
      }

      return StationDetail(
        station: station,
        facilities: facilities,
        lines: lines,
      );
    } catch (e) {
      print('エラーが発生しました: $e');
      throw e;
    }
  }

  // 施設名から駅を検索する(駅のすべての情報を返す)
  Future<List<StationDetail>> getStationsByFacilityName(
      String facilityName) async {
    try {
      // 施設名から施設を検索し、stateが正の値のものだけを取得
      final facilitiesSnapshot = await _firestore
          .collection('facilities')
          .where('name', isEqualTo: facilityName)
          .where('state', isGreaterThan: 0)
          .get();

      List<StationDetail> stations = [];

      // 各施設に対して駅の詳細情報を取得
      for (var facilityDoc in facilitiesSnapshot.docs) {
        DocumentReference stationRef = facilityDoc.data()['stationRef'];
        final stationDoc = await stationRef.get();

        if (stationDoc.exists) {
          final station = Station.fromMap(
              stationDoc.data() as Map<String, dynamic>, stationDoc.id);

          // その駅の全施設を取得
          final allFacilitiesSnapshot = await _firestore
              .collection('facilities')
              .where('stationRef', isEqualTo: stationRef)
              .get();

          List<Facility> facilities = allFacilitiesSnapshot.docs
              .map((doc) => Facility.fromMap(doc.data(), doc.id))
              .toList();

          // 駅の路線情報を取得
          final stationLinesSnapshot = await _firestore
              .collection('stationLines')
              .where('stationRef', isEqualTo: stationRef)
              .get();

          List<Line> lines = [];
          for (var stationLine in stationLinesSnapshot.docs) {
            DocumentReference lineRef = stationLine.data()['lineRef'];
            final lineDoc = await lineRef.get();
            if (lineDoc.exists) {
              lines.add(Line.fromMap(
                lineDoc.data() as Map<String, dynamic>,
                lineDoc.id,
              ));
            }
          }

          stations.add(StationDetail(
            station: station,
            facilities: facilities,
            lines: lines,
          ));
        }
      }

      return stations;
    } catch (e) {
      print('エラーが発生しました: $e');
      throw e;
    }
  }

  // 施設のstateを更新する
  Future<bool> updateFacilityState(
      {required String stationName,
      required List<String> facilityNames,
      required int newState}) async {
    try {
      // まず駅を検索
      final stationSnapshot = await _firestore
          .collection('stations')
          .where('name', isEqualTo: stationName)
          .get();

      if (stationSnapshot.docs.isEmpty) {
        print('指定された駅が見つかりません: $stationName');
        return false;
      }

      final stationRef = stationSnapshot.docs.first.reference;

      // 駅と施設名で施設を検索
      final facilitySnapshot = await _firestore
          .collection('facilities')
          .where('stationRef', isEqualTo: stationRef)
          .where('name', whereIn: facilityNames)
          .get();

      if (facilitySnapshot.docs.isEmpty) {
        print('指定された駅の施設が見つかりません: $facilityNames');
        return false;
      }

      // 施設のstateを更新
      WriteBatch batch = _firestore.batch();

      for (var doc in facilitySnapshot.docs) {
        batch.update(doc.reference, {'state': newState});
      }

      await batch.commit();

      return true;
    } catch (e) {
      print('エラーが発生しました: $e');
      throw e;
    }
  }

  // 施設のvoteを更新する
  // 1. vote_inside_gate, 2. vote_outside_gate, 3. vote_no, 4. vote_both
  // 期待する入力
  // [{
  //   "facilityName": str,
  //   "add_vote": int,
  //},...]
  // facilityNameで指定された施設のvoteを増やす(1だったら、vote_inside_gateを1増やすなど)
  Future<bool> updateFacilityVote(
      {required String stationName,
      required List<Map<String, dynamic>> voteUpdates}) async {
    try {
      print("stationName: $stationName");
      // まず駅を検索
      final stationSnapshot = await _firestore
          .collection('stations')
          .where('name', isEqualTo: stationName)
          .get();

      if (stationSnapshot.docs.isEmpty) {
        print('指定された駅が見つかりません: $stationName');
        return false;
      }

      final stationRef = stationSnapshot.docs.first.reference;

      // 施設名のリストを作成
      final facilityNames = voteUpdates
          .map((update) => update['facilityName'] as String)
          .toList();

      // 駅と施設名で施設を検索
      final facilitySnapshot = await _firestore
          .collection('facilities')
          .where('stationRef', isEqualTo: stationRef)
          .where('name', whereIn: facilityNames)
          .get();

      if (facilitySnapshot.docs.isEmpty) {
        print('指定された駅の施設が見つかりません: $facilityNames');
        return false;
      }

      // 施設のvoteを更新
      WriteBatch batch = _firestore.batch();

      for (var facilityDoc in facilitySnapshot.docs) {
        final facilityData = facilityDoc.data();
        final facilityName = facilityData['name'] as String;
        final currentState = facilityData['state'] as int;

        // 対応するvote更新データを検索
        final voteUpdate = voteUpdates.firstWhere(
          (update) => update['facilityName'] == facilityName,
          orElse: () => {'facilityName': facilityName, 'add_vote': 0},
        );

        final addVote = voteUpdate['add_vote'] as int;

        // 現在の投票数を取得
        int voteInsideGate = facilityData['vote_inside_gate'] ?? 0;
        int voteOutsideGate = facilityData['vote_outside_gate'] ?? 0;
        int voteNo = facilityData['vote_no'] ?? 0;
        int voteBoth = facilityData['vote_both'] ?? 0;

        // addVoteの値に応じて適切なフィールドを更新
        Map<String, dynamic> updateData = {};
        if (addVote == 1) {
          voteInsideGate += 1;
          updateData['vote_inside_gate'] = voteInsideGate;
        } else if (addVote == 2) {
          voteOutsideGate += 1;
          updateData['vote_outside_gate'] = voteOutsideGate;
        } else if (addVote == 3) {
          voteNo += 1;
          updateData['vote_no'] = voteNo;
        } else if (addVote == 4) {
          voteBoth += 1;
          updateData['vote_both'] = voteBoth;
        }

        // 投票結果に基づいてstateを決定
        int newState = -1;
        List<int> votes = [voteInsideGate, voteOutsideGate, voteNo, voteBoth];
        int maxVotes = votes.reduce(max);

        // 最大票数を持つ選択肢の数を数える
        List<int> maxIndices = [];
        for (int i = 0; i < votes.length; i++) {
          if (votes[i] == maxVotes) {
            maxIndices.add(i);
          }
        }

        // 同票の組み合わせに基づいてstateを設定
        if (maxIndices.length == 1) {
          // 一つの選択肢が最大の場合
          if (maxVotes == voteInsideGate)
            newState = 2;
          else if (maxVotes == voteOutsideGate)
            newState = 3;
          else if (maxVotes == voteNo)
            newState = 0;
          else if (maxVotes == voteBoth) newState = 4;
        } else if (maxIndices.length == 2) {
          // 2つの選択肢が同票の場合
          if (voteInsideGate == voteOutsideGate && voteInsideGate == maxVotes) {
            newState = 1;
          } else if (voteOutsideGate == voteBoth &&
              voteOutsideGate == maxVotes) {
            newState = 3;
          } else if (voteInsideGate == voteBoth && voteInsideGate == maxVotes) {
            newState = 2;
          } else {
            newState = (currentState == 1) ? 1 : -1;
          }
        } else if (maxIndices.length == 3) {
          // 3つの選択肢が同票の場合
          if (voteInsideGate == voteOutsideGate &&
              voteOutsideGate == voteBoth &&
              voteInsideGate == maxVotes) {
            newState = 4;
          } else {
            newState = (currentState == 1) ? 1 : -1;
          }
        } else {
          // その他の場合
          newState = (currentState == 1) ? 1 : -1;
        }

        updateData['state'] = newState;
        batch.update(facilityDoc.reference, updateData);
      }

      await batch.commit();
      print('投票数の更新が完了しました');

      return true;
    } catch (e) {
      print('エラーが発生しました: $e');
      throw e;
    }
  }

  // Stationを受け取ってトイレの情報を返す
  Future<int?> getToiletState(Station station) async {
    try {
      // DocumentReferenceを直接作成
      final stationRef =
          _firestore.collection('stations').doc(station.stationId);

      // トイレの施設情報のみを取得
      final toiletSnapshot = await _firestore
          .collection('facilities')
          .where('stationRef', isEqualTo: stationRef)
          .where('name', isEqualTo: 'toilet')
          .limit(1) // トイレは1つのみ取得
          .get();

      // トイレが見つからない場合はnullを返す
      if (toiletSnapshot.docs.isEmpty) {
        return null;
      }

      // トイレのstateを返す
      return toiletSnapshot.docs.first.data()['state'] as int;
    } catch (e) {
      print('トイレの状態取得中にエラーが発生しました: $e');
      throw e;
    }
  }
}
