import 'package:flutter/material.dart';
import 'package:google_maps/res/routes/app_routes.dart';
import 'package:google_maps/view/current_location.dart';
import 'package:google_maps/view/marker_view.dart';
import 'package:google_maps/view/polygone_view.dart';

class AppPages {
  static Map<String, WidgetBuilder> get routes {
    return {
      AppRoutes.currentLocation: (context) => const CurrentLocation(),
      AppRoutes.marker:(context) => const MarkerClass(),
      AppRoutes.polygon:(context) => const PolyLInesVIew()
    };
  }
}
