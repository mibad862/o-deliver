import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:o_deliver/api_handler/api_wrapper.dart';
import '../api_handler/network_constant.dart';
import '../shared_pref_helper.dart';
import '../util/snackbar_util.dart';

class SettingsProvider extends ChangeNotifier {


  void clearStoredValues() async {
    // await SharedPrefHelper.clearAll();
    await SharedPrefHelper.removeKey("access-token");
    await SharedPrefHelper.removeKey("driver-id");
    await SharedPrefHelper.removeKey("user-online");
  }

  Future<void> logoutUser(BuildContext context) async {
    EasyLoading.show(
      status: "Logging Out..."
    );
    // _isLoading = true;
    // notifyListeners();

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

        final service = FlutterBackgroundService();
        if (await service.isRunning()) {
          service.invoke('stopService');
        }

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
      EasyLoading.dismiss();
      // _isLoading = false;
      // notifyListeners();
    }
  }
}
