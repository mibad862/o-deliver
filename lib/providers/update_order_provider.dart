import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:o_deliver/main.dart';
import 'package:provider/provider.dart';
import '../api_handler/api_wrapper.dart';
import '../api_handler/network_constant.dart';
import '../shared_pref_helper.dart';
import '../util/snackbar_util.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'deliveryScreen_provider.dart';

class UpdateOrderProvider extends ChangeNotifier {
  UpdateOrderProvider() {
    fetchAllData();
  }

  XFile? multimediaPhoto;

  int? selectedStatusId;
  String? selectedStatusName;

  final reasonUpdateController = TextEditingController();
  final attemptValidationController = TextEditingController();

  List<dynamic> _orderStatus = [];

  List<dynamic> get orderStatus => _orderStatus;

  // Flags for UI fields visibility
  bool showMultimediaPhoto = false;
  bool showReasonUpdate = false;
  bool showAttemptValidation = false;

  Future<void> pickMultimediaPhoto(void Function(XFile) onImagePicked) async {
    final multimediaPhoto =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (multimediaPhoto != null) {
      onImagePicked(multimediaPhoto);
      notifyListeners();
    }
  }

  void setSelectedStatus(int? id, String? name) {
    selectedStatusId = id;
    selectedStatusName = name;

    // Update field visibility based on selected status ID
    if (id == 7 || id == 8) {
      showMultimediaPhoto = true;
      showReasonUpdate = true;
      showAttemptValidation = true;
    } else if (id == 6) {
      showMultimediaPhoto = true;
      showReasonUpdate = false;
      showAttemptValidation = false;
    } else {
      showMultimediaPhoto = false;
      showReasonUpdate = false;
      showAttemptValidation = false;
    }

    notifyListeners();
  }

  Future<void> fetchAllData() async {
    notifyListeners();

    try {
      final responseData = await ApiService.getApiWithoutToken(
        NetworkConstantsUtil.getAllData,
      );

      bool isSuccess = responseData['success'];
      // String message = responseData['message'];

      if (isSuccess) {
        final List<dynamic> orderStatusData =
            responseData['data']['order_statuses'];
        _orderStatus = orderStatusData;
        notifyListeners();
        // print(message);
      } else {
        throw Exception('Failed to load Order Status: ');
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateOrder(
      BuildContext context, String currentOrderId, String orderStatus) async {
    EasyLoading.show(status: "Updating the order");

    final currentDriverId = await SharedPrefHelper.getInt("driver-id");
        if (currentDriverId == null) {
          throw Exception("Driver ID not found");
        }

        print("Current Order ID $currentOrderId");
        print("Order Status $orderStatus");


    final Map<String, dynamic> params = {
      "order_status": orderStatus,
      "driver_id": currentDriverId
    };

    try {
      print('message11');
      // Call the reset password API
      final responseData = await ApiService.postApiWithToken(
        body: params,
        endpoint: "${NetworkConstantsUtil.updateOrder}/$currentOrderId",
      );


      bool isSuccess = responseData['success'];
      String message = responseData['message'];

      print(message);

      if (isSuccess) {
        final deliveryScreenProvider =
            Provider.of<DeliveryScreenProvider>(context, listen: false);
        await deliveryScreenProvider.fetchAllOrders();

        // Handle success case
        showCustomSnackBar(context, message);
        Navigator.pop(context);

        notifyListeners();
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

  // Future<void> updateOrder(BuildContext context, String currentOrderId, String orderStatus) async {
  //
  //   EasyLoading.show(status: 'Updating Order');
  //   // _isLoading = true;
  //   // notifyListeners();
  //
  //   // Check if the license number photo has been selected
  //   if (multimediaPhoto == null && showMultimediaPhoto) {
  //     showCustomSnackBar(context, "Please Multi Media photo.");
  //     EasyLoading.dismiss();
  //     return;
  //   }
  //
  //   print("CURRENT ORDER ID $currentOrderId");
  //
  //   try {
  //     // Fetch the Bearer token (replace this with your actual method for getting the token)
  //
  //     final token = await SharedPrefHelper.getString("access-token");
  //     if (token == null) {
  //       throw Exception("Token not found");
  //     }
  //
  //     final currentDriverId = await SharedPrefHelper.getInt("driver-id");
  //     if (currentDriverId == null) {
  //       throw Exception("Driver ID not found");
  //     }
  //
  //     final Uri url = Uri.parse(
  //       "${NetworkConstantsUtil.baseUrl}${NetworkConstantsUtil.updateOrder}/$currentOrderId",
  //     );
  //
  //
  //     var request = http.MultipartRequest('POST', url);
  //
  //     // Add headers with Bearer token
  //     request.headers['Authorization'] = 'Bearer $token';
  //     request.headers['Content-Type'] = 'application/json';
  //
  //     // Add fields to the request
  //     request.fields['driver_id'] = currentDriverId.toString();
  //     // request.fields['order_status'] = selectedStatusId.toString();
  //     request.fields['order_status'] = orderStatus.toString();
  //     // request.fields['order_status'] = 1.toString();
  //     if (showReasonUpdate) {
  //       request.fields['reason_update'] = reasonUpdateController.text.trim();
  //     }
  //
  //     if (showAttemptValidation) {
  //       request.fields['attempt_validation'] =
  //           attemptValidationController.text.trim();
  //     }
  //
  //     // Add the license number photo as a multipart file (check the file type)
  //     if (showMultimediaPhoto) {
  //       var multiMediaPhoto = await http.MultipartFile.fromPath(
  //         'multimedia_upload', // Field name in the API
  //         multimediaPhoto!.path, // Path to the picked image
  //         contentType: MediaType(
  //             'image',
  //             multimediaPhoto!.path
  //                 .split('.')
  //                 .last), // Set content type dynamically
  //       );
  //
  //       // Add the file to the request
  //       request.files.add(multiMediaPhoto);
  //     }
  //
  //     print(request.fields);
  //
  //     // Send the request
  //     var response = await request.send();
  //
  //     print(response.statusCode);
  //
  //     // Process the response
  //     final responseString = await response.stream.bytesToString();
  //     final Map<String, dynamic> responseData = jsonDecode(responseString);
  //
  //     bool isSuccess = responseData['success'];
  //     String message = responseData['message'];
  //
  //     if (isSuccess) {
  //
  //       final deliveryScreenProvider =
  //       Provider.of<DeliveryScreenProvider>(context, listen: false);
  //       await deliveryScreenProvider.fetchAllOrders();
  //
  //       // Handle success case
  //       showCustomSnackBar(context, message);
  //       clearControllersAndStatus();
  //       Navigator.pop(context);
  //     } else {
  //       showCustomSnackBar(context, message);
  //     }
  //   } catch (e) {
  //     print("Error: $e");
  //     showCustomSnackBar(context, e.toString());
  //   } finally {
  //     EasyLoading.dismiss();
  //     notifyListeners();
  //   }
  // }

  void clearControllersAndStatus() {
    multimediaPhoto = null;
    selectedStatusId = null;
    selectedStatusName = null;
    reasonUpdateController.clear();
    attemptValidationController.clear();

    showMultimediaPhoto = false;
    showReasonUpdate = false;
    showAttemptValidation = false;

    notifyListeners();
  }
}
