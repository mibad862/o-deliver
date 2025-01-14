import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:o_deliver/helpers/easyloading_helper.dart';
import '../api_handler/api_wrapper.dart';
import '../api_handler/network_constant.dart';
import '../shared_pref_helper.dart';
import '../util/snackbar_util.dart';

class DeliveryScreenProvider extends ChangeNotifier {
  DeliveryScreenProvider() {
    _initializeDriverStatus();
    fetchAllOrders();
    // driverAssignedOrders();
    // driverPickedUpOrders();
  }

  bool? isSwitched = false;

  String orderStatus = "No Order Found";

  List<dynamic> _hubAndSpokeOrders = [];

  List<dynamic> get hubAndSpokeOrders => _hubAndSpokeOrders;

  List<dynamic> _instantDeliveryOrders = [];

  List<dynamic> get instantDeliveryOrders => _instantDeliveryOrders;

  void changeDriverStatus(bool value) {
    isSwitched = value;
    notifyListeners();
  }

  Future<void> _initializeDriverStatus() async {
    isSwitched = await SharedPrefHelper.getBool("user-online") ?? false;
    notifyListeners(); // Notify UI after fetching the value
  }

  Future<void> fetchAllOrders() async {

    EasyLoading.show(status: "Loading...");

    // Retrieve the Bearer token from shared preferences
    String? accessToken = await SharedPrefHelper.getString('access-token');
    int? driverId = await SharedPrefHelper.getInt('driver-id');

    if (accessToken == null || driverId == null) {
      print("Access token or driver ID is null");
      print("Error: Missing authentication data");
      return;
    }

    try {
      print('Fetching Driver All Orders');

      // Call the API with the Bearer token in the headers
      final responseData = await ApiService.getApiWithToken(
        "${NetworkConstantsUtil.fetchAllOrders}/$driverId", // API endpoint
        accessToken,
      );

      // print('Sending request to update driver status...');

      bool isSuccess = responseData['success'];
      String message = responseData['message'];
      // String orders = responseData['orders'];
      print('fetchAllOrders_message22222 ${responseData['message']}');

      if (isSuccess) {
        print("DRIVER ID $driverId");

        _hubAndSpokeOrders = responseData['orders']["HubAndSpoke"];
        _instantDeliveryOrders = responseData['orders']["InstantDelivery"];

        print(_hubAndSpokeOrders);
        print('_instantDeliveryOrders $_instantDeliveryOrders');
        print('fetchAllOrders_message $message');

        notifyListeners();
      } else {
        // Handle error case
        print(message);
      }
    } catch (e) {
      // changeDriverStatus(false);
      print("Error: $e");
      // print(e.toString());
    } finally {
      EasyLoading.dismiss();
      // changeDriverStatus(false);
      // _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateDriverStatus(
    BuildContext context,
    bool currentStatus,
  ) async {
    int? driverId = await SharedPrefHelper.getInt('driver-id');

    final service = FlutterBackgroundService();

    if (driverId == null) {
      print("Access token or driver ID is null");
      showCustomSnackBar(context, "Error: Missing authentication data");
      return;
    }

    final Map<String, dynamic> params = {
      "on_duty": isSwitched! ? 1 : 0,
      // "on_duty": 5.0,
    };

    try {
      print('Sending request to update driver status...');

      // Call the API with the Bearer token in the headers
      final responseData = await ApiService.postApiWithToken(
        endpoint:
            "${NetworkConstantsUtil.updateDriverStatus}/$driverId", // API endpoint
        body: params, // Request parameters
        // token: accessToken,
      );

      bool isSuccess = responseData['success'];
      String message = responseData['message'];

      print(message);

      if (isSuccess) {
        print("STATUS $isSwitched");
        print("DRIVER ID $driverId");

        if (currentStatus) {
          // Start the background service only if not already running
          if (!(await service.isRunning())) {
            await service.startService(); // Explicitly start the service
          }
        } else {
          // Stop the background service
          service.invoke('stopService');
        }

        EasyLoadingHelper.showSuccess(message);
      } else {
        EasyLoadingHelper.showError(message);
      }
    } catch (e) {
      EasyLoadingHelper.showError(e.toString());
      print("Error:mm $e");
    } finally {
      // changeDriverStatus(false);
    }
  }
}
