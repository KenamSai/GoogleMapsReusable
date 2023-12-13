import 'package:flutter/material.dart';
import 'package:google_maps/viewmodel/marker_viewmodel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MarkerClass extends StatefulWidget {
  const MarkerClass({super.key});

  @override
  State<MarkerClass> createState() => _MarkerClassState();
}

class _MarkerClassState extends State<MarkerClass> {
  @override
  Widget build(BuildContext context) {
    final markersProvider = Provider.of<MarkerViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        title: const Text("Marker"),
        centerTitle: true,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  markersProvider.clearAll();
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
              initialCameraPosition: const CameraPosition(
                  target: LatLng(17.4401, 78.3489), zoom: 14),
              markers: markersProvider.markers,
              polylines: markersProvider.polylines,
            ),
          ),
          TextButton(
            onPressed: addMarker,
            child: const Text("ADD MARKER"),
          ),
          TextButton(
            onPressed: clearMarker,
            child: const Text("REMOVE MARKER"),
          )
        ],
      ),
    );
  }

  addMarker() async {
    final provider = Provider.of<MarkerViewModel>(context, listen: false);
    await provider.addMarkers(context);
  }

  clearMarker() async {
    final provider = Provider.of<MarkerViewModel>(context, listen: false);
    await provider.removeMarker();
  }
}
