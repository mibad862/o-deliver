import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:o_deliver/api_handler/api_wrapper.dart';
import '../api_handler/network_constant.dart';

class ResetPasswordProvider extends ChangeNotifier {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool passVisible = true;
  bool get passwordVisible => passVisible;

  void togglePasswordVisibility() {
    passVisible = !passVisible;
    notifyListeners();
  }

  bool confirmPassVisible = true;
  bool get confirmPasswordVisible => confirmPassVisible;

  void toggleConfirmPasswordVisibility() {
    confirmPassVisible = !confirmPassVisible;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  Future<void> resetPassword(BuildContext context, String token) async {
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> params = {
      "email": emailController.text.trim(),
      "user_type": "driver",
      "password": passwordController.text.trim(),
      "password_confirmation": confirmPasswordController.text.trim(),
      "token": token,
    };

    try {
      print('message1');
      // Call the reset password API
      final responseData = await ApiService.postApiWithoutToken(
        NetworkConstantsUtil.resetPassword,
        params,
      );

      print('message2');

      bool isSuccess = responseData['success'];
      String message = responseData['message'];

      print(message);

      if (isSuccess) {
        // Handle success case
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
        context.go('/signIn');
      } else {
        // Handle error case
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message.toString())),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


// Future<void> resetPassword(BuildContext context, String token) async {
  //   _isLoading = true;
  //
  //   notifyListeners();
  //
  //   final Map<String, dynamic> params = {
  //     "email": emailController.text.trim(),
  //     "user_type": "driver",
  //     "password": passwordController.text.trim(),
  //     "password_confirmation": confirmPasswordController.text.trim(),
  //     "token": token,
  //   };
  //
  //   try {
  //     print('message1');
  //     // Call the reset password API
  //     var response;
  //
  //      response = await _apiService.postApiWithoutToken(
  //         NetworkConstantsUtil.resetPassword,
  //         params,
  //       );
  //
  //
  //
  //
  //     print('message2');
  //
  //     final Map<String, dynamic> responseData = jsonDecode(response);
  //
  //
  //      bool isSuccess = responseData['success'];
  //     String message = responseData['message'];
  //
  //     print(message);
  //
  //
  //     if (response.statusCode == 200) {
  //       // Handle success case
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text(message)),
  //       );
  //       // Optionally navigate to another page
  //       context.go('/signIn');
  //     }
  //     else {
  //       // Handle error case
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text(message.toString())),
  //       );
  //     }
  //   } catch (e) {
  //     print("Error: $e");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('$e')),
  //     );
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

}