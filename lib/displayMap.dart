import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:async';

import 'searchPage.dart';
import 'header.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
  await FlutterConfig.loadEnvVariables();
  runApp(const MapApp());
}

class MapApp extends StatefulWidget {
  const MapApp({super.key});

  @override
  _MapAppState createState() => _MapAppState();
}

class _MapAppState extends State<MapApp> {
  late GoogleMapController _mapController;
  Position? currentPosition;
  late StreamSubscription<Position> positionStream;

  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high, //正確性:highはAndroid(0-100m),iOS(10m)
    distanceFilter: 100,
  );
  

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentPosition = position;
    });

    // カメラ位置を現在位置に移動
    _mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14,
      ),
    ));
  }
  Future<void> searchLocation(List result) async {
    _mapController.animateCamera(
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
    CameraPosition initialCameraPosition = currentPosition == null
        ? const CameraPosition(
            target: LatLng(35.68, 139.76),
            zoom: 14,
          )
        : CameraPosition(
            target: LatLng(currentPosition!.latitude, currentPosition!.longitude),
            zoom: 14,
          );

    return Scaffold(
      appBar: const Header(state: 0),
      body: Stack(alignment: Alignment.topCenter,
        children:[
          GoogleMap(
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController mapController) {
              _mapController = mapController;
              if (currentPosition != null) {
                _mapController.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(currentPosition!.latitude, currentPosition!.longitude),
                    zoom: 14,
                  ),
                ));
              }
            },
            initialCameraPosition: initialCameraPosition,
            myLocationEnabled: true,
          ),Container(
            margin: const EdgeInsets.only(top: 6),
            height: 50,
            width:300,
            child:InkWell(
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
            child:
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(right:20, left:20, top:5, bottom:5),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.black),
                ),
                child: const Row(children:[
                  Icon(Icons.search),
                  Text('駅を検索')],
                ),
              ),
            ),
          ),
        ]),
      );
  }

  @override
  void dispose() {
    positionStream.cancel();
    super.dispose();
  }
}