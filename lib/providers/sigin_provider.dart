import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:o_deliver/shared_pref_helper.dart';
import '../api_handler/api_wrapper.dart'; // Ensure this is correct
import '../api_handler/network_constant.dart';
import '../util/snackbar_util.dart';

class SignInProvider with ChangeNotifier {
  final ApiService _apiService = ApiService(); // Correct instantiation

  // Text controllers to capture user inputs
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool rememberMe = false;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool passVisible = true;
  bool get passwordVisible => passVisible;

  void passwordVisibility() {
    passVisible = !passVisible;
    notifyListeners();
  }

  void updateRememberMe(bool value){
    rememberMe = value;
    notifyListeners();
  }

  Future<void> saveRememberMe() async {
    await SharedPrefHelper.saveBool("logged-in", rememberMe);
  }

  // Method to sign in the user

  Future<void> signIn(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> params = {
      "email": emailController.text.toString(),
      "password": passwordController.text.toString(),
    };

    try {
      print('message11');
      // Call the reset password API
      final responseData = await _apiService.postApiWithoutToken(
        NetworkConstantsUtil.login,
        params,
      );

      print('message2');

      bool isSuccess = responseData['success'];
      String message = responseData['message'];

      print(message);

      if (isSuccess) {

        if(rememberMe){
          await saveRememberMe();
        }

        final current = await SharedPrefHelper.getBool("logged-in");

        print("Logged ID $current");

        // Handle success case
        final int otp = responseData['otp'] ?? 'Login successful!';
        print(otp);
        showCustomSnackBar(context, message);
        context.go("/verifyOtp/${emailController.text.toString()}");
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
