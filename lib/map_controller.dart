import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/state_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:ui' as ui;

import 'package:mh_local/map.dart';

class MapScreenController extends GetxController {
  GoogleMapController? mapController;
  RxBool mapTypeIsNormal = true.obs;
  final Set<Marker> markers = {};

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getCurrentPosition();
  }

  CameraPosition initPosition = CameraPosition(
    target: LatLng(31.5204, 74.3587),
    zoom: 15,
  );

  CameraPosition damiPosition = CameraPosition(
    target: LatLng(22.5204, 22.3587),
    zoom: 15,
  );

  mapTypeChange() {
    mapTypeIsNormal.value = !mapTypeIsNormal.value;
    update();
  }

  LocationData? _locationData;
  getCurrentPosition() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    print('_locationData: ${_locationData}');

    mapController!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(
        double.parse(_locationData!.latitude.toString()),
        double.parse(_locationData!.longitude.toString()),
      ),
      zoom: 15,
    )));

    update();
  }

  addMarker() async {
    final Uint8List markerIcon =
        await getMarkerWithSizeandWithoutContedt(60, "assets/images/0.png");

    markers.add(Marker(
      markerId: MarkerId("sdf"),
      position: LatLng(
        double.parse(_locationData!.latitude.toString()),
        double.parse(_locationData!.longitude.toString()),
      ),
      icon: BitmapDescriptor.fromBytes(markerIcon),
    ));
    update();
  }

  static Future<Uint8List> getMarkerWithSizeandWithoutContedt(
      int width, String img) async {
    ByteData data = await rootBundle.load(img);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Set<Polyline> polyline = Set<Polyline>();
  List<LatLng> _polylineCoordinates = [];
  PolylinePoints _polylinePoints = PolylinePoints();

  void setPolylineOnMap(double startLat, double startLong, double destiLat,
      double destiLong) async {
    print("String Polyline..............................");
    log(startLat.toString());
    log(startLong.toString());
    log(destiLat.toString());
    log(destiLong.toString());
    PointLatLng start = PointLatLng(startLat, startLong);
    PointLatLng endLatlong = PointLatLng(destiLat, destiLong);
    PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
        googleApikey,
        PointLatLng(startLat, startLong),
        PointLatLng(destiLat, destiLong));
    log(result.errorMessage.toString());
    if (result.status == "OK") {
      result.points.forEach((PointLatLng point) {
        _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      polyline.add(Polyline(
          width: 4,
          polylineId: PolylineId('polyline'),
          color: Colors.red,
          points: _polylineCoordinates));
    } else {
      print("Polyline Not Generated!!!!!!!!!!!!!!!!");
    }
    update();
  }
}
