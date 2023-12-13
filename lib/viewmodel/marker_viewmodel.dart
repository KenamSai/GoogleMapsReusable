import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps/viewmodel/current_location_viewmodel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MarkerViewModel with ChangeNotifier {
  List<LatLng> latLng = [];
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
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
        markers.clear();
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

        await addPolyLines(context);
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
    print(
        "markers length ::::::::::: ${markers.length}  list length ${latLng.length}");
    notifyListeners();
  }

  removeMarker() {
    if (latLng.isNotEmpty) {
      if (markers.isNotEmpty) {
        markers.removeWhere((element) => element.position == latLng.last);
        latLng.removeLast();
      }
    }
    notifyListeners();
    print(
        "markers length at  ::::::::::: ${markers.length}  list length at${latLng.length}");
  }

  addPolyLines(context) {
    try {
      polylines.clear();
      for (LatLng element in latLng) {
        polylines.add(
          Polyline(
              polylineId: PolylineId(
                "${element.latitude} ${element.longitude}",
              ),
              points: latLng,
              color: Colors.red,
              width: 5),
        );
        notifyListeners();
        EasyLoading.dismiss();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error in drawing polylines"),
        ),
      );
      EasyLoading.dismiss();
    }
  }

  clearAll() {
    latLng.clear();
    markers.clear();
    polylines.clear();
  }
}
