import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps/viewmodel/current_location_viewmodel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class PolyLinesViewModel with ChangeNotifier {
  List<LatLng> latLng = [];
  Set<Marker> markers = {};
  Set<Polygon> polygon = HashSet<Polygon>();

  addMarkers(context) async {
    EasyLoading.show(status: "Loading...", maskType: EasyLoadingMaskType.black);
    final currentProvider =
        Provider.of<CurrentLocationViewModel>(context, listen: false);
    await currentProvider.determinePosition(context);
    try {
      if (!latLng.contains(LatLng(currentProvider.latLng?.latitude ?? 0.0,
          currentProvider.latLng?.longitude ?? 0.0))) {
        latLng.add(
          LatLng(currentProvider.latLng?.latitude ?? 0.0,
              currentProvider.latLng?.longitude ?? 0.0),
        );
        print("length :::::::: ${latLng.length}");
        markers.clear();
        polygon.clear();
        for (var element in latLng) {
          markers.add(
            Marker(
              markerId: MarkerId(
                "${element.latitude} ${element.longitude}",
              ),
              position: LatLng(element.latitude, element.longitude),
            ),
          );
        }
      }
      EasyLoading.dismiss();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error Adding marker"),
        ),
      );
      EasyLoading.dismiss();
    }
    notifyListeners();
  }

  removeMarker() {
    if (latLng.isNotEmpty) {
      if (markers.isNotEmpty) {
        print("hello");
        markers.removeWhere((element) => element.position == latLng.last);
        latLng.removeLast();
      }
    }
    notifyListeners();
  }

  drawPolygon(BuildContext context) {
    polygon.clear();
    try {
      if (markers.length >= 3) {
        polygon.add(
          Polygon(
              polygonId: const PolygonId("1"),
              points: latLng,
              fillColor: Colors.yellow,
              strokeWidth: 2),
        );
        notifyListeners();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Minimum 3 markers required"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error Adding polygon"),
        ),
      );
    }
    notifyListeners();
  }

  clearAll() {
    latLng.clear();
    markers.clear();
    polygon.clear();
  }
}
