import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mh_local/map_controller.dart';
import 'package:get/get.dart';

var googleApikey = "AIzaSyDhAWhuusfBwKiDLM47Oto6pEnNcakn-Ds";

class MapScreen extends StatelessWidget {
  MapScreen({Key? key}) : super(key: key);

  MapScreenController mapScreenController = Get.put(MapScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          GetBuilder<MapScreenController>(builder: ((controller) {
            return GoogleMap(
              initialCameraPosition: mapScreenController.initPosition,
              rotateGesturesEnabled: false,
              myLocationEnabled: true,
              trafficEnabled: true,
              markers: mapScreenController.markers,
              mapType: mapScreenController.mapTypeIsNormal.value
                  ? MapType.normal
                  : MapType.satellite,
              onMapCreated: (controller) {
                mapScreenController.mapController = controller;
              },
            );
          })),
          // Obx((() => GoogleMap(
          //       initialCameraPosition: mapScreenController.initPosition,
          //       rotateGesturesEnabled: false,
          //       myLocationEnabled: true,
          //       trafficEnabled: true,
          //       markers: mapScreenController.markers,
          //       mapType: mapScreenController.mapTypeIsNormal.value
          //           ? MapType.normal
          //           : MapType.satellite,
          //       onMapCreated: (controller) {
          //         mapScreenController.mapController = controller;
          //       },
          //     ))),
          ElevatedButton(
              onPressed: () {
                mapScreenController.addMarker();
                // mapScreenController.mapController!.animateCamera(
                //     CameraUpdate.newCameraPosition(
                //         CameraPosition(target: LatLng(22.013214, 36.565123))));
              },
              child: Text("btn")),
          Positioned(
            top: 50,
            child: ElevatedButton(
                onPressed: () {
                  mapScreenController.mapTypeChange();
                },
                child: Text("Map Type")),
          ),
        ],
      ),
    );
  }
}
