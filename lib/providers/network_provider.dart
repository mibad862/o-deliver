import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:o_deliver/util/snackbar_util.dart';

class NetworkProvider with ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  String _connectStatus = '';
  bool isDialogOpen = false;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription; // Change to List<ConnectivityResult>

  String get connectStatus => _connectStatus;

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Initializes the connectivity listener
  void initialize() {
    // Listen for List<ConnectivityResult> and handle accordingly
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(updateConnectionStatus);
  }

  // Updates the connection status based on the connectivity result
  void updateConnectionStatus(List<ConnectivityResult> result) {  // Expecting a List<ConnectivityResult>
    if (result.contains(ConnectivityResult.mobile)) {
      print("Mobile Connection");
      _connectStatus = "Mobile Connection";
    } else if (result.contains(ConnectivityResult.wifi)) {
      print("Wifi Connection");
      _connectStatus = "Wifi Connection";
    } else if (result.contains(ConnectivityResult.none)) {
      print("No Connection");
      _connectStatus = "No Connection";
      // This method now requires context to show the snackbar
      // You can pass context from the widget when calling showNoConnectionSnackbar()
    } else {
      _connectStatus = "Something is Wrong";
    }
    notifyListeners();  // Notify listeners for UI update
  }

  // Shows a snackbar when there is no internet connection
  void showNoConnectionSnackbar(BuildContext context) {
    // Show snackbar using the passed context
    showCustomSnackBar(context, "You are not connected to the internet. Please check your connection.");
  }
}
