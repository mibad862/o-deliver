import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:o_deliver/shared_pref_helper.dart';
import '../api_handler/api_wrapper.dart'; // Ensure this is correct
import '../api_handler/network_constant.dart';
import '../util/snackbar_util.dart';

class SignInProvider with ChangeNotifier {

  SignInProvider(){
    loadCredentials();
  }

  // Text controllers to capture user inputs
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool rememberMe = false;

  bool passVisible = true;
  bool get passwordVisible => passVisible;

  void passwordVisibility() {
    passVisible = !passVisible;
    notifyListeners();
  }

  void updateRememberMe(bool value) {
    rememberMe = value;
    notifyListeners();
  }


  // Method to sign in the user

  Future<void> saveCredentials() async {
    if (rememberMe) {
      await SharedPrefHelper.saveString("savedEmail", emailController.text);
      await SharedPrefHelper.saveString("savedPassword", passwordController.text);
      rememberMe = false;
    }
  }

  Future<void> loadCredentials() async {
    emailController.text = await SharedPrefHelper.getString("savedEmail") ?? "";

    print("EMAIL ${emailController.text}");

    passwordController.text =
        await SharedPrefHelper.getString("savedPassword") ?? "";

    print("PASS ${passwordController.text}");
    notifyListeners();
  }

  Future<void> signIn(BuildContext context) async {
    EasyLoading.show(
      status: "Signing in..."
    );

    final Map<String, dynamic> params = {
      "email": emailController.text.toString(),
      "password": passwordController.text.toString(),
    };

    try {
      // Call the reset password API
      final responseData = await ApiService.postApiWithoutToken(
        NetworkConstantsUtil.login,
        params,
      );

      bool isSuccess = responseData['success'];
      String message = responseData['message'];

      print(message);

      if (isSuccess) {
        if (rememberMe) {
          await saveCredentials();
        }

        // Handle success case
        final int otp = responseData['otp'] ?? 'Login successful!';
        print(otp);
        showCustomSnackBar(context, message);
        // context.go("/verifyOtp/${emailController.text.toString()}");
        context.go("/verifyOtp/${emailController.text.toString()}/$otp");

        clearControllers();
      } else {
        // Handle error case
        showCustomSnackBar(context, message);
      }
    } catch (e) {
      print("Error: $e");
      showCustomSnackBar(context, e.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }

  void clearControllers(){
    emailController.clear();
    passwordController.clear();
  }
}
