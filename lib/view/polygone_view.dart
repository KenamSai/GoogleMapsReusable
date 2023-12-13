import 'package:flutter/material.dart';
import 'package:google_maps/viewmodel/polygoneviewmodel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class PolyLInesVIew extends StatefulWidget {
  const PolyLInesVIew({super.key});

  @override
  State<PolyLInesVIew> createState() => _PolyLInesVIewState();
}

class _PolyLInesVIewState extends State<PolyLInesVIew> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PolyLinesViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("PolyLines"),
        backgroundColor: Colors.blue,
        centerTitle: true,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  provider.clearAll();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_sharp),
              )
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              polygons: provider.polygon,
              myLocationEnabled: true,
              initialCameraPosition: const CameraPosition(
                target: LatLng(17.4401, 78.3489),
                zoom: 10,
              ),
              markers: provider.markers,
            ),
          ),
          TextButton(
            onPressed: addMarker,
            child: const Text("ADD MARKER"),
          ),
          TextButton(
            onPressed: clearMarker,
            child: const Text("REMOVE MARKER"),
          ),
          TextButton(
            onPressed: drawPolygon,
            child: const Text("DRAW POLYGON"),
          )
        ],
      ),
    );
  }

  addMarker() async {
    final provider = Provider.of<PolyLinesViewModel>(context, listen: false);
    await provider.addMarkers(context);
  }

  clearMarker() async {
    final provider = Provider.of<PolyLinesViewModel>(context, listen: false);
    await provider.removeMarker();
  }

  drawPolygon() async {
    final provider = Provider.of<PolyLinesViewModel>(context, listen: false);
    await provider.drawPolygon(context);
  }
}
