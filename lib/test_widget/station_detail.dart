import 'package:eki_kuguru/models/models.dart';
import 'package:eki_kuguru/service/station_service.dart';
import 'package:flutter/material.dart';

class StationDetailPage extends StatefulWidget {
  final Station station;

  const StationDetailPage({
    Key? key,
    required this.station,
  }) : super(key: key);

  @override
  State<StationDetailPage> createState() => _StationDetailPageState();
}

class _StationDetailPageState extends State<StationDetailPage> {
  final StationService _stationService = StationService();
  StationDetail? _stationDetail;
  bool _isLoading = true;

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

  // 対応
  String _getFacilityStatusText(int state) {
    switch (state) {
      case 3:
        return "改札外";
      case 2:
        return "改札内";
      case 1:
        return "ある(情報求む)";
      case 0:
        return "わからない";
      default:
        return "なし";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.station.name),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _stationDetail == null
              ? const Center(child: Text('情報を取得できませんでした'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 駅の基本情報
                      _buildStationInfoCard(),
                      const SizedBox(height: 20),
                      // 路線情報
                      _buildLinesSection(),
                      const SizedBox(height: 20),
                      // 施設情報
                      _buildFacilitiesSection(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildStationInfoCard() {
    return Card(
      child: ListTile(
        title: Text(widget.station.name),
        subtitle: Text('駅名: ${widget.station.name}'),
      ),
    );
  }

  Widget _buildLinesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('路線一覧', style: Theme.of(context).textTheme.titleLarge),
        Card(
          child: Column(
            children: _stationDetail!.lines
                .map((line) => ListTile(
                      title: Text(line.name),
                      subtitle: Text('路線名: ${line.name}'),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFacilitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('施設一覧', style: Theme.of(context).textTheme.titleLarge),
        ..._stationDetail!.facilities
            .map((facility) => _buildFacilityCard(facility))
            .toList(),
      ],
    );
  }

  Widget _buildFacilityCard(Facility facility) {
    final statusColor = facility.state > 0 ? Colors.green : Colors.red;
    final statusText = _getFacilityStatusText(facility.state);

    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        title: Text(facility.name),
        subtitle: Text('施設名: ${facility.name}'),
        trailing: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: statusColor.shade100,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            statusText,
            style: TextStyle(color: statusColor.shade700),
          ),
        ),
      ),
    );
  }
}
