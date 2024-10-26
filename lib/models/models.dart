// 駅の情報を格納するモデルクラス
class Station {
  final String stationId;
  final String name;

  Station({
    required this.stationId,
    required this.name,
  });

  factory Station.fromMap(Map<String, dynamic> map, String id) {
    return Station(
      stationId: id,
      name: map['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'stationId': stationId,
      'name': name,
    };
  }
}

// 路線の情報を格納するモデルクラス
class Line {
  final String lineId;
  final String name;

  Line({
    required this.lineId,
    required this.name,
  });

  factory Line.fromMap(Map<String, dynamic> map, String id) {
    return Line(
      lineId: id,
      name: map['name'] ?? '',
    );
  }
}

// 施設情報を格納するモデルクラス
class Facility {
  final String facilityId;
  final String name;
  final int state;

  Facility({
    required this.facilityId,
    required this.name,
    required this.state,
  });

  factory Facility.fromMap(Map<String, dynamic> map, String id) {
    return Facility(
      facilityId: id,
      name: map['name'] ?? '',
      state: map['state'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'facilityId': facilityId,
      'name': name,
      'state': state,
    };
  }
}

// 駅の詳細情報を格納するクラス
class StationDetail {
  final Station station;
  final List<Facility> facilities;
  final List<Line> lines;

  StationDetail({
    required this.station,
    required this.facilities,
    required this.lines,
  });
}