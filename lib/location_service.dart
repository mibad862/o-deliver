import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {

  Future<bool> requestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false ;
    }

    return true ;
  }

  // Function to check and request permissions
  Future<bool> checkLocationPermissions() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      return true;
    }
    if (status.isDenied) {
      await Permission.location.request();
      return false;
    }
    return false;
  }

  // Function to get current location
  Future<Position> getCurrentLocation() async {
    bool hasPermission = await checkLocationPermissions();
    if (!hasPermission) {
      throw Exception("Location permission denied");
    }
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  // Function to start location updates
  void startLocationUpdates(ServiceInstance service) {
    // Start periodic updates for location in the background
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      Position position = await getCurrentLocation();
      if (service is AndroidServiceInstance && await service.isForegroundService()) {
        // Set foreground notification with updated location
        service.setForegroundNotificationInfo(
          title: 'Location Service Running',
          content: 'Lat: ${position.latitude}, Long: ${position.longitude}',
        );
      }
      print('Updated Location: Lat: ${position.latitude}, Long: ${position.longitude}');

      service.invoke('update');
    });
  }


}
