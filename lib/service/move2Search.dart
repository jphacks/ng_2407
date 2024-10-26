import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../page/searchPage.dart';

class MoveToSearchPage extends StatelessWidget {
  final GoogleMapController mapController;
  const MoveToSearchPage({super.key, required this.mapController});

  Future<void> searchLocation(List result) async {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(result[0], result[1]), // CameraPositionのtargetに経度・緯度の順で指定します。
          zoom: 15,
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return  InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const SearchPage();
                    },
                  ),
                ).then((value) async {
                  // valueに配列に格納された経度・緯度が格納されています
                  await searchLocation(value);
                });
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text('駅を検索'),
              ),
            );
  }
}