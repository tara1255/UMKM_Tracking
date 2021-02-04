import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PetaUsaha extends StatefulWidget {
  @override
  _PetaUsahaState createState() => _PetaUsahaState();
}

class _PetaUsahaState extends State<PetaUsaha> {
  final Set<Marker> _markers = Set<Marker>();
  final Set<Polyline> polylineRoute = Set<Polyline>();
  LatLng _currentPosition;
  GoogleMapPolyline _googleMapPolyline;

  @override
  void initState() {
    _googleMapPolyline =
        GoogleMapPolyline(apiKey: "AIzaSyBPkpFfRXYyP0dtXS4msxZ4ym2MFEp_Om0");

    Geolocator.getCurrentPosition().then((currloc) async {
      setState(() {
        _currentPosition = LatLng(currloc.latitude, currloc.longitude);
      });
      final data = await getData();
      data.forEach((element) {
        _markers.add(
          Marker(
            markerId: MarkerId(element['id']),
            position: LatLng(
              double.parse(element['latitude']),
              double.parse(element['longitude']),
            ),
            infoWindow: InfoWindow(title: element['nama_usaha']),
            onTap: () {
              print(_currentPosition.latitude);
              print(element['latitude']);
              getRoutePoint(
                  _currentPosition,
                  LatLng(
                    double.parse(element['latitude']),
                    double.parse(element['longitude']),
                  ));
            },
          ),
        );
      });
      setState(() {});
    });
    super.initState();
  }

  getRoutePoint(LatLng currentPosition, LatLng destination) async {
    List<LatLng> routeLatLng =
        await _googleMapPolyline.getCoordinatesWithLocation(
            origin: currentPosition,
            destination: destination,
            mode: RouteMode.driving);

    polylineRoute.clear();
    polylineRoute.add(Polyline(
        polylineId: PolylineId('route1'),
        visible: true,
        points: routeLatLng,
        width: 4,
        color: Color(0xFFf52a09),
        startCap: Cap.roundCap,
        endCap: Cap.buttCap));
    setState(() {});
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

  // void initState() {
  // _markers.add(
  //   Marker(
  //     markerId: MarkerId("-6.835010, 108.227674"),
  //     position: _currentPosition,
  //     // icon: BitmapDescriptor.defaultMarker,
  //   ),
  // );
  // _markers.add(
  //   Marker(
  //     markerId: MarkerId("-6.837030, 108.253637"),
  //     position: LatLng(-6.837030, 108.253637),
  //     // icon: BitmapDescriptor.defaultMarker,
  //   ),
  // );
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _currentPosition != null
          ? GoogleMap(
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              initialCameraPosition: CameraPosition(
                target: _currentPosition,
                zoom: 14,
              ),
              myLocationEnabled: true,
              markers: _markers,
              polylines: polylineRoute,
              onTap: (position) {
                _markers.add(
                  Marker(
                    markerId:
                        MarkerId("${position.latitude}, ${position.longitude}"),
                    position: position,
                  ),
                );
                setState(() {});
              },
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              ].toSet(),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
