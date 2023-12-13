import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentLocationViewModel with ChangeNotifier {
  LatLng? latLng;
  String? currentAddress;
  isServiceEnabled(context) async {
    bool serviceEnabled;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Location Services Disabled'),
          content: const Text(
              'Please enable location services to use this feature.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Geolocator
                    .openLocationSettings(); // Open device settings to enable location
              },
              child: const Text('Open Settings'),
            ),
          ],
        ),
      );
      return Future.error('Location services are disabled.');
    }
  }

  determinePosition(context) async {
    LocationPermission permission;

    //isLocationService enabled
    isServiceEnabled(context);
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Location Permissions Denied'),
            content: const Text(
                'This app needs location access to provide accurate information.\nPlease enable location permissions in your app settings.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: const Text('OK'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Geolocator.openAppSettings(); // Open app settings
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );
      } else if (permission == LocationPermission.deniedForever) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Location Permissions Denied forever'),
            content: const Text(
                'This app needs location access to provide accurate information.\nPlease enable location permissions in your app settings.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: const Text('OK'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Geolocator.openAppSettings(); // Open app settings
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );
      }
    } else {
      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        latLng = LatLng(position.latitude, position.longitude);
        getAddressFromLatLong(position, context);
        notifyListeners();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("error getting location"),
          ),
        );
      }
    }
  }

  getAddressFromLatLong(Position? position, context) async {
    if (position != null) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);
        Placemark placemark = placemarks[0];
        currentAddress =
            "${placemark.subLocality},${placemark.locality},${placemark.administrativeArea},${placemark.country}";
        notifyListeners();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("error getting location"),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    print("dispose");
    latLng = const LatLng(0.0, 0.0);
    currentAddress = "";
    super.dispose();
  }
}
