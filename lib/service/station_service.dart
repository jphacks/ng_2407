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

  Future<bool> updateFacilityState(
      {required String stationName,
      required String facilityName,
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
          .where('name', isEqualTo: facilityName)
          .get();

      if (facilitySnapshot.docs.isEmpty) {
        print('指定された駅の施設が見つかりません: $facilityName');
        return false;
      }

      // 施設のstateを更新
      await facilitySnapshot.docs.first.reference.update({'state': newState});

      return true;
    } catch (e) {
      print('エラーが発生しました: $e');
      throw e;
    }
  }
}
