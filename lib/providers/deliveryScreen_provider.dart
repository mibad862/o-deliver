import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../api_handler/api_wrapper.dart';
import '../api_handler/network_constant.dart';
import '../shared_pref_helper.dart';
import '../util/snackbar_util.dart';

class DeliveryScreenProvider extends ChangeNotifier {
  DeliveryScreenProvider(){
    _initializeDriverStatus();
  }

  bool? isSwitched = false;
  bool _isLoading = false;

  final _apiService = ApiService();

  void changeDriverStatus(bool value){
    isSwitched = value;
    notifyListeners();
  }

  Future<void> _initializeDriverStatus() async {
    isSwitched = await SharedPrefHelper.getBool("user-online") ?? false;
    notifyListeners(); // Notify UI after fetching the value
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
      final responseData = await _apiService.postApiWithToken(
        "${NetworkConstantsUtil.updateDriverStatus}/$driverId", // API endpoint
        params, // Request parameters
        accessToken,
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