import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';

class EasyLoadingHelper {

  // Show a loading indicator with custom color configuration
  static void showLoading({String message = 'Loading...', Color backgroundColor = Colors.blueAccent, Color indicatorColor = Colors.white}) {
    EasyLoading.instance
      ..backgroundColor = backgroundColor
      ..indicatorColor = indicatorColor
      ..textColor = Colors.white
      ..maskColor = Colors.black.withOpacity(0.5);

    EasyLoading.show(
      status: message,
      maskType: EasyLoadingMaskType.black,
    );
  }

  // Show success message with custom color configuration
  static void showSuccess(String message, {Color backgroundColor = Colors.green, Color textColor = Colors.white}) {
    EasyLoading.instance
      ..backgroundColor = backgroundColor
      ..indicatorColor = Colors.white
      ..textColor = textColor
      ..maskColor = Colors.black.withOpacity(0.5);

    EasyLoading.showSuccess(
      message,
      duration: const Duration(seconds: 2),
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: true,
    );
  }

  // Show error message with custom color configuration
  static void showError(String message, {Color backgroundColor = Colors.red, Color textColor = Colors.white}) {
    EasyLoading.instance
      ..backgroundColor = backgroundColor
      ..indicatorColor = Colors.white
      ..textColor = textColor
      ..maskColor = Colors.black.withOpacity(0.5);

    EasyLoading.showError(
      message,
      duration: const Duration(seconds: 2),
      dismissOnTap: true,
    );
  }

  // Show information message with custom color configuration
  static void showInfo(String message, {Color backgroundColor = Colors.blue, Color textColor = Colors.white}) {
    EasyLoading.instance
      ..backgroundColor = backgroundColor
      ..indicatorColor = Colors.white
      ..textColor = textColor
      ..maskColor = Colors.black.withOpacity(0.5);

    EasyLoading.showInfo(
      message,
      duration: const Duration(seconds: 2),
      dismissOnTap: true,
    );
  }

  // Show a toast with custom color configuration
  static void showToast(String message, {Color backgroundColor = Colors.grey, Color textColor = Colors.white}) {
    EasyLoading.instance
      ..backgroundColor = backgroundColor
      ..indicatorColor = Colors.white
      ..textColor = textColor
      ..maskColor = Colors.black.withOpacity(0.5);

    EasyLoading.showToast(
      message,
      toastPosition: EasyLoadingToastPosition.bottom,
      duration: const Duration(seconds: 2),
      dismissOnTap: true,
    );
  }

  // Dismiss the EasyLoading indicator
  static void dismiss() {
    EasyLoading.dismiss();
  }
}
