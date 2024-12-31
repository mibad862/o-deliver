import 'package:flutter/material.dart';
import '../api_handler/api_wrapper.dart';
import '../api_handler/network_constant.dart';
import '../shared_pref_helper.dart';
import '../util/snackbar_util.dart';

class DeliveryScreenProvider extends ChangeNotifier {
  DeliveryScreenProvider() {
    _initializeDriverStatus();
    driverAssignedOrders();
    driverPickedUpOrders();
  }

  bool? isSwitched = false;
  bool _isLoading = false;

  List<dynamic> _pickedUpOrders = [];
  List<dynamic> get pickedUpOrders => _pickedUpOrders;

  List<dynamic> _assignedOrders = [];
  List<dynamic> get assignedOrders => _assignedOrders;


  void changeDriverStatus(bool value) {
    isSwitched = value;
    notifyListeners();
  }

  Future<void> _initializeDriverStatus() async {
    isSwitched = await SharedPrefHelper.getBool("user-online") ?? false;
    notifyListeners(); // Notify UI after fetching the value
  }

  Future<void> driverPickedUpOrders() async {
    _isLoading = true;
    notifyListeners();

    // Retrieve the Bearer token from shared preferences
    String? accessToken = await SharedPrefHelper.getString('access-token');
    int? driverId = await SharedPrefHelper.getInt('driver-id');

    if (accessToken == null || driverId == null) {
      print("Access token or driver ID is null");
      print("Error: Missing authentication data");
      return;
    }

    try {
      print('Sending request to update driver status...');

      // Call the API with the Bearer token in the headers
      final responseData = await ApiService.getApiWithToken(
        "${NetworkConstantsUtil.pickedUpOrders}/$driverId", // API endpoint
        accessToken,
      );

      // print('Sending request to update driver status...');

      bool isSuccess = responseData['success'];
      String message = responseData['message'];
      // String orders = responseData['orders'];

      if (isSuccess) {
        print("DRIVER ID $driverId");

        _pickedUpOrders = responseData['orders'];

        print(_pickedUpOrders);
        print(message);

        // changeDriverStatus(true);

        // print(orders);
        // print(isSuccess);
        // context.go('/mainScreen');
      } else {
        // changeDriverStatus(false);
        // Handle error case
        print(message);
      }
    } catch (e) {
      // changeDriverStatus(false);
      print("Error: $e");
      // print(e.toString());
    } finally {
      // changeDriverStatus(false);
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> driverAssignedOrders() async {
    _isLoading = true;
    notifyListeners();

    // Retrieve the Bearer token from shared preferences
    String? accessToken = await SharedPrefHelper.getString('access-token');
    int? driverId = await SharedPrefHelper.getInt('driver-id');

    if (accessToken == null || driverId == null) {
      print("Access token or driver ID is null");
      print("Error: Missing authentication data");
      return;
    }

    try {
      print('Sending request to update driver status...');

      // Call the API with the Bearer token in the headers
      final responseData = await ApiService.getApiWithToken(
        "${NetworkConstantsUtil.assignedOrders}/$driverId", // API endpoint
        accessToken,
      );

      // print('Sending request to update driver status...');

      bool isSuccess = responseData['success'];
      String message = responseData['message'];
      // String orders = responseData['orders'];

      if (isSuccess) {
        print("DRIVER ID $driverId");

        _assignedOrders = responseData['orders'];

        print(_assignedOrders);
        print(message);

        // changeDriverStatus(true);

        // print(orders);
        // print(isSuccess);
        // context.go('/mainScreen');
      } else {
        // changeDriverStatus(false);
        // Handle error case
        print(_assignedOrders);
        print(message);
      }
    } catch (e) {
      // changeDriverStatus(false);
      print("Error: $e");
      // print(e.toString());
    } finally {
      // changeDriverStatus(false);
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateDriverStatus(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    // Retrieve the Bearer token from shared preferences
    String? accessToken = await SharedPrefHelper.getString('access-token');
    int? driverId = await SharedPrefHelper.getInt('driver-id');

    if (accessToken == null || driverId == null) {
      print("Access token or driver ID is null");
      showCustomSnackBar(context, "Error: Missing authentication data");
      return;
    }

    final Map<String, dynamic> params = {
      "on_duty": isSwitched! ? 1 : 0,
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

        // changeDriverStatus(true);

        showCustomSnackBar(context, message);
        // context.go('/mainScreen');
      } else {
        // changeDriverStatus(false);
        // Handle error case
        showCustomSnackBar(context, message);
      }
    } catch (e) {
      // changeDriverStatus(false);
      print("Error: $e");
      showCustomSnackBar(context, e.toString());
    } finally {
      // changeDriverStatus(false);
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateOrderStatus(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    // Retrieve the Bearer token from shared preferences
    String? accessToken = await SharedPrefHelper.getString('access-token');
    int? driverId = await SharedPrefHelper.getInt('driver-id');

    if (accessToken == null || driverId == null) {
      print("Access token or driver ID is null");
      showCustomSnackBar(context, "Error: Missing authentication data");
      return;
    }

    final Map<String, dynamic> params = {
      "on_duty": isSwitched! ? 1 : 0,
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

        // changeDriverStatus(true);

        showCustomSnackBar(context, message);
        // context.go('/mainScreen');
      } else {
        // changeDriverStatus(false);
        // Handle error case
        showCustomSnackBar(context, message);
      }
    } catch (e) {
      // changeDriverStatus(false);
      print("Error: $e");
      showCustomSnackBar(context, e.toString());
    } finally {
      // changeDriverStatus(false);
      _isLoading = false;
      notifyListeners();
    }
  }
}
