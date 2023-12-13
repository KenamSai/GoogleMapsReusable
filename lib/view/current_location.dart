import 'package:flutter/material.dart';
import 'package:google_maps/res/routes/app_routes.dart';
import 'package:google_maps/viewmodel/current_location_viewmodel.dart';
import 'package:provider/provider.dart';

class CurrentLocation extends StatefulWidget {
  const CurrentLocation({super.key});

  @override
  State<CurrentLocation> createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CurrentLocationViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        title: const Text("currentLocation"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
              "latitude::::::: ${provider.latLng?.latitude ?? ""}  longitude :::::::::: ${provider.latLng?.longitude ?? ""}"),
          Text("Address:::::::::::::::: ${provider.currentAddress ?? ""}"),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.marker);
            },
            child: const Text("go to marker"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.polygon);
            },
            child: const Text("Add Polygon"),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      asyncMethod();
    });
  }

  asyncMethod() async {
    final provider =
        Provider.of<CurrentLocationViewModel>(context, listen: false);
    await provider.determinePosition(context);
  }
}
