import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:o_deliver/api_handler/api_wrapper.dart';
import 'package:o_deliver/util/snackbar_util.dart';

import '../api_handler/network_constant.dart';

class ForgetPasswordProvider extends ChangeNotifier {

  final emailController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  Future<void> forgetPass(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> params = {
      "email": emailController.text.toString(),
      "user_type": "driver",
    };

    try {
      print('message1');
      // Call the reset password API
      final responseData = await ApiService.postApiWithoutToken(
        NetworkConstantsUtil.forgetPassword,
        params,
      );

      print('message2');

      bool isSuccess = responseData['success'];
      String message = responseData['message'];

      print(message);

      if (isSuccess) {
        // Handle success case
        showCustomSnackBar(context, message);
        clearControllers();
        context.go('/signIn');
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


  void clearControllers() {
    emailController.clear();
  }
}