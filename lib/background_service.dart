

import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:o_deliver/shared_pref_helper.dart';

import 'api_handler/api_wrapper.dart';
import 'api_handler/network_constant.dart';
import 'location_service.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: false,
      foregroundServiceTypes: [AndroidForegroundType.location],
    ),
  );
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  final locationService = LocationService();

  String? currentToken = await SharedPrefHelper.getString("access-token");
  int? currentDriverId = await SharedPrefHelper.getInt("driver-id");

  print(currentToken);
  print(currentDriverId);

  if (currentToken == null || currentToken.isEmpty) {
    print("Error: Missing or invalid bearer token");
  }

  if (currentDriverId == null) {
    print("Error: Missing or invalid driver ID");
  }

  // Start location updates
  locationService.startLocationUpdates(service);

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });

    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (await service.isForegroundService()) {
        // Fetch the current location
        Position position = await locationService.getCurrentLocation();

        // Set foreground notification with updated location
        service.setForegroundNotificationInfo(
          title: 'Foreground Service Running',
          content: 'Lat: ${position.latitude}, Long: ${position.longitude}',
        );

        // Make the API call to update the driver location

        final Map<String, dynamic> params = {
          "lat": position.latitude,
          "lng": position.longitude,
        };

        print("PARAMS $params");
        print("CURRENT TOKEN $currentToken");
        print("CURRENT DRIVER ID $currentDriverId");

        try {
          final responseData = await ApiService.postApiWithToken(
            endpoint:
                "${NetworkConstantsUtil.updateDriverLocation}/$currentDriverId",
            body: params,
            // token: currentToken ?? "",
          );
          print("Full Response: $responseData");
          bool isSuccess = responseData['success'];
          String message = responseData['message'];

          print(message);
          print(currentToken);
          print(currentDriverId);

          if (isSuccess) {
            print('Location updated successfully. $message');
          } else {
            print(
                'Failed to update location. Status code: ${responseData["success"]}');
          }
        } catch (e) {
          print('Error while updating location: $e');
        }
      }
    });
  }

  if (service is ServiceInstance) {
    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    Timer.periodic(Duration(seconds: 10), (timer) async {
      Position position = await locationService.getCurrentLocation();
      print(
          'Uppdated Location: Lat: ${position.latitude}, Long: ${position.longitude}');

      final Map<String, dynamic> params = {
        "lat": position.latitude,
        "lng": position.longitude,
      };

      // Make the API call for iOS
      try {
        final responseData = await ApiService.postApiWithToken(
          endpoint:
              "${NetworkConstantsUtil.updateDriverLocation}/$currentDriverId",
          body: params,
          // token: currentToken ?? "",
        );

        bool isSuccess = responseData['success'];
        String message = responseData['message'];

        if (isSuccess) {
          print('Location updated successfully (iOS). $message');
        } else {}
      } catch (e) {
        //print('Error while updating location (iOS): $e');
      }
    });
  }
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  print("Background service running...");

  final locationService = LocationService();
  locationService.startLocationUpdates(service);

  return true;
}
