import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:o_deliver/api_handler/api_wrapper.dart';
import '../api_handler/network_constant.dart';
import '../shared_pref_helper.dart';
import '../util/snackbar_util.dart';

class SettingsProvider extends ChangeNotifier {


  bool _isLoading = false;

  void clearStoredValues() async {
    // await SharedPrefHelper.clearAll();
    await SharedPrefHelper.removeKey("access-token");
    await SharedPrefHelper.removeKey("driver-id");
  }

  Future<void> logoutUser(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    // final Map<String, dynamic> params = {
    //   "email": emailText,
    //   "otp": otpController.text,
    //   "token": fcmToken
    // };

    try {
      print('message11');
      // Call the reset password API

      final accessToken = await SharedPrefHelper.getString("access-token");

      print("ACCESS TOKEN $accessToken");

      final responseData = await ApiService.postApiWithToken(
        endpoint: NetworkConstantsUtil.logout,
        // token: accessToken ?? "",
      );

      print('message2');

      bool isSuccess = responseData['success'];
      String message = responseData['message'];

      print(message);

      if (isSuccess) {
        // // Handle success case
        //
        // final accessToken = responseData['accessToken'];
        // final driverId = responseData['userData']['id'];
        //
        // print("ACCESS TOKEN $accessToken");
        // print("DRIVER ID $driverId");

        showCustomSnackBar(context, message);
        context.go('/signIn');
        clearStoredValues();
      } else {
        // Handle error case
        showCustomSnackBar(context, message);
      }
    } catch (e) {
      print("Error: $e");
      showCustomSnackBar(context, e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
