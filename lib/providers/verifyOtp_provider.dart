import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:o_deliver/api_handler/api_wrapper.dart';
import 'package:o_deliver/shared_pref_helper.dart';
import 'package:o_deliver/util/snackbar_util.dart';
import '../api_handler/network_constant.dart';

class VerifyOtpProvider extends ChangeNotifier {

  VerifyOtpProvider(){
    getDeviceToken();
  }
  // Text controllers to capture user inputs
  final TextEditingController otpController = TextEditingController();
  final _apiService = ApiService();

  String? fcmToken = "";

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getDeviceToken() async {
    fcmToken = await FirebaseMessaging.instance.getToken();
    print("FCM TOKEN $fcmToken");
  }

  Future<void> verifyOTP(String emailText, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    print(emailText);
    print(otpController.text);

      final Map<String, dynamic> params = {
        "email": emailText,
        "otp": otpController.text,
        "token": fcmToken
      };

    try {
      print('message11');
      // Call the reset password API
      final responseData = await _apiService.postApiWithoutToken(
        NetworkConstantsUtil.verifyOtp,
        params,
      );

      print('message2');

      bool isSuccess = responseData['success'];
      String message = responseData['message'];

      print(message);

      if (isSuccess) {
        // Handle success case

        final accessToken = responseData['accessToken'];
        final driverId = responseData['userData']['id'];

        print("ACCESS TOKEN $accessToken");
        print("DRIVER ID $driverId");

        await SharedPrefHelper.saveString("access-token", accessToken);
        await SharedPrefHelper.saveInt("driver-id", driverId);

        showCustomSnackBar(context, message);
        context.go('/mainScreen');
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