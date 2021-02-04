import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/gestures.dart';
import 'package:here_sdk/routing.dart';

class UsahaModel {
  final String namaUsaha;
  final String lengthInMeters;
  final String durationInSeconds;

  UsahaModel({this.namaUsaha, this.lengthInMeters, this.durationInSeconds});
}

class MyHereMap extends StatefulWidget {
  @override
  _MyHereMapState createState() => _MyHereMapState();
}

class _MyHereMapState extends State<MyHereMap> {
  GeoCoordinates _currentPosition;

  MapPolyline _mapPolyline;

  UsahaModel usahaModel;

  @override
  void initState() {
    Geolocator.getCurrentPosition().then((currloc) async {
      setState(() {
        _currentPosition = GeoCoordinates(-6.835010, 108.227674);
      });
    });
    super.initState();
  }

  Future<List> getData() async {
    // final response = await http.get("http://192.168.43.74/umkm/getdata.php");
    // return json.decode(response.body);
    final res = [
      {
        "id": "0",
        "nama_usaha": "Oak's Cafe & Resto",
        "profil": "tess",
        "alamat_usaha": "Majalengka",
        "bidang_usaha": "Pengolahan makanan",
        "latitude": "-6.835478977954564",
        "longitude": "108.23205821878568",
        "gambar": ""
      },
      {
        "id": "1",
        "nama_usaha": "BJ-Cell",
        "profil": "tess",
        "alamat_usaha": "Majalengka",
        "bidang_usaha": "Pengolahan makanan",
        "latitude": "-6.8371549056353516",
        "longitude": "108.23307097586108",
        "gambar": ""
      },
      {
        "id": "2",
        "nama_usaha": "Ijopink Cutting Sticker",
        "profil": "tess",
        "alamat_usaha": "Majalengka",
        "bidang_usaha": "Pengolahan makanan",
        "latitude": "-6.834748095178841",
        "longitude": "108.21611639877146",
        "gambar": ""
      }
    ];
    return res;
  }

  /// Membuat marker lokasi user
  Future<void> drawRedDot(
    HereMapController mapController,
    int drawOrder,
    GeoCoordinates geoCoordinates,
  ) async {
    ByteData fileData = await rootBundle.load('images/circle2.png');
    Uint8List pixelData = fileData.buffer.asUint8List();

    MapImage mapImage =
        MapImage.withPixelDataAndImageFormat(pixelData, ImageFormat.png);

    Metadata metadata = new Metadata();
    metadata.setString("key_poi", "Metadata: This is a POI.");

    MapMarker mapMarker = MapMarker(geoCoordinates, mapImage);
    mapMarker.metadata = metadata;
    mapMarker.drawOrder = drawOrder;
    mapController.mapScene.addMapMarker(mapMarker);
  }

  /// Membuat Rute
  drawRoute(
    GeoCoordinates start,
    GeoCoordinates end,
    HereMapController mapController,
    Metadata metadata,
  ) {
    RoutingEngine routingEngine = RoutingEngine();

    Waypoint startWayPoint = Waypoint.withDefaults(start);
    Waypoint endWayPoint = Waypoint.withDefaults(end);

    List<Waypoint> wayPoints = [startWayPoint, endWayPoint];

    routingEngine.calculateCarRoute(wayPoints, CarOptions.withDefaults(),
        (routingError, routes) {
      try {
        if (routingError == null) {
          if (_mapPolyline != null) {
            mapController.mapScene.removeMapPolyline(_mapPolyline);
          }
          final route = routes.first;

          GeoPolyline geoPolyline = GeoPolyline(route.polyline);
          double depth = 15;
          _mapPolyline = MapPolyline(geoPolyline, depth, Colors.blue);

          mapController.mapScene.addMapPolyline(_mapPolyline);

          if (metadata != null) {
            String message = metadata.getString("id") ?? "No message found.";
            setState(() {
              usahaModel = UsahaModel(
                  namaUsaha: message,
                  durationInSeconds: route.durationInSeconds.toString(),
                  lengthInMeters: route.lengthInMeters.toString());
            });
            return;
          }
        }
      } catch (e) {
        print(e.toString());
      }
    });
  }

  /// Membuat marker usaha
  Future<void> drawMarker(
    HereMapController mapController,
    int drawOrder,
    dynamic element,
  ) async {
    ByteData fileData = await rootBundle.load('images/poi.png');
    Uint8List pixelData = fileData.buffer.asUint8List();

    Anchor2D anchor2d = Anchor2D.withHorizontalAndVertical(0.5, 1);

    MapImage mapImage =
        MapImage.withPixelDataAndImageFormat(pixelData, ImageFormat.png);

    Metadata metadata = new Metadata();
    final id = element['id'];
    final desc = element['nama_usaha'];
    metadata.setString("id", desc);

    MapMarker mapMarker = MapMarker.withAnchor(
        GeoCoordinates(
          double.parse(element['latitude']),
          double.parse(element['longitude']),
        ),
        mapImage,
        anchor2d);
    mapMarker.metadata = metadata;
    mapMarker.drawOrder = drawOrder;
    mapController.mapScene.addMapMarker(mapMarker);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _currentPosition != null
          ? Stack(
              children: [
                HereMap(
                  onMapCreated: onMapCreated,
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                    Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer(),
                    ),
                  ].toSet(),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Visibility(
                    visible: usahaModel != null,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.all(16),
                      color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          usahaModel != null
                              ? Text("Nama Usaha: " + usahaModel.namaUsaha)
                              : Container(),
                          usahaModel != null
                              ? Text("Jarak: " +
                                  usahaModel.lengthInMeters +
                                  " Meter")
                              : Container(),
                          usahaModel != null
                              ? Text("Waktu Tempuh: " +
                                  usahaModel.durationInSeconds +
                                  " Detik")
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  /// Menampilkan MAP
  onMapCreated(HereMapController mapController) async {
    mapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay, (error) {
      if (error != null) {
        print('Error: ' + error.toString());
      }
    });

    final data = await getData();

    data.forEach((element) {
      drawMarker(
        mapController,
        1,
        element,
      );
    });

    drawRedDot(mapController, 0, _currentPosition);

    mapController.gestures.tapListener =
        TapListener.fromLambdas(lambda_onTap: (Point2D touchPoint) {
      _pickMapMarker(touchPoint, mapController);
    });

    final distanceToEartInMeters = 8000.0;
    mapController.camera
        .lookAtPointWithDistance(_currentPosition, distanceToEartInMeters);
  }

  /// Klik Marker
  void _pickMapMarker(Point2D touchPoint, HereMapController mapController) {
    double radiusInPixel = 2;
    mapController.pickMapItems(touchPoint, radiusInPixel, (pickMapItemsResult) {
      List<MapMarker> mapMarkerList = pickMapItemsResult.markers;
      if (mapMarkerList.length == 0) {
        print("No map markers found.");
        return;
      }

      MapMarker topmostMapMarker = mapMarkerList.first;
      Metadata metadata = topmostMapMarker.metadata;

      drawRoute(
        _currentPosition,
        topmostMapMarker.coordinates,
        mapController,
        metadata,
      );
    });
  }
}
