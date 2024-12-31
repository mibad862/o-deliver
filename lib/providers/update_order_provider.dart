import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../api_handler/api_wrapper.dart';
import '../api_handler/network_constant.dart';
import '../shared_pref_helper.dart';
import '../util/snackbar_util.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';


class UpdateOrderProvider extends ChangeNotifier {
  UpdateOrderProvider() {
    fetchAllData();
  }

  bool _isLoading = false;

  XFile? multimediaPhoto;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
    final multimediaPhoto = await ImagePicker().pickImage(source: ImageSource.gallery);
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
      final response = await ApiService.getApiWithoutToken(
        NetworkConstantsUtil.getAllData,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['success']) {
          final List<dynamic> orderStatusData = responseData['data']['order_statuses'];
          _orderStatus = orderStatusData;
          notifyListeners();
        } else {
          throw Exception('Failed to load Order Status: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to load Order Status: ${response.body}');
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateOrder(BuildContext context, String currentOrderId) async {
    _isLoading = true;
    notifyListeners();

    // Check if the license number photo has been selected
    if (multimediaPhoto == null && showMultimediaPhoto) {
      showCustomSnackBar(context, "Please Multi Media photo.");
      return;
    }

    print("CURRENT ORDER ID $currentOrderId");


    try {
      // Fetch the Bearer token (replace this with your actual method for getting the token)

      final token = await SharedPrefHelper.getString("access-token");
      if (token == null) {
        throw Exception("Token not found");
      }


      final currentDriverId = await SharedPrefHelper.getInt("driver-id");
      if (currentDriverId == null) {
        throw Exception("Driver ID not found");
      }

      final Uri url = Uri.parse(
          "http://192.168.10.45:8000/api/driver/order-status/$currentOrderId");

      var request = http.MultipartRequest('POST', url);


      // Add headers with Bearer token
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'application/json';

      // Add fields to the request
      request.fields['driver_id'] = currentDriverId.toString();
      request.fields['order_status'] = selectedStatusId.toString();
      // request.fields['order_status'] = 1.toString();
      if (showReasonUpdate) {
        request.fields['reason_update'] = reasonUpdateController.text.trim();
      }

      if (showAttemptValidation) {
        request.fields['attempt_validation'] =
            attemptValidationController.text.trim();
      }

      // Add the license number photo as a multipart file (check the file type)
      if (showMultimediaPhoto) {
        var multiMediaPhoto = await http.MultipartFile.fromPath(
          'multimedia_upload', // Field name in the API
          multimediaPhoto!.path, // Path to the picked image
          contentType: MediaType(
              'image',
              multimediaPhoto!.path
                  .split('.')
                  .last), // Set content type dynamically
        );

        // Add the file to the request
        request.files.add(multiMediaPhoto);
      }

      print(request.fields);

      // Send the request
      var response = await request.send();

      print(response.statusCode);

      // Process the response
      final responseString = await response.stream.bytesToString();
      final Map<String, dynamic> responseData = jsonDecode(responseString);


      bool isSuccess = responseData['success'];
      String message = responseData['message'];


      if (isSuccess) {
        print("Hey");
        // Handle success case
        showCustomSnackBar(context, message);
      } else {
        print("HEllo");
        print(message);
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


  // Future<void> updateOrder(BuildContext context, String currentOrderId) async {
  //   _isLoading = true;
  //   notifyListeners();
  //
  //   // Check if the license number photo has been selected
  //   if (multimediaPhoto == null && showMultimediaPhoto) {
  //     showCustomSnackBar(context, "Please Multi Media photo.");
  //     return;
  //   }
  //
  //   print("CURRENT ORDER ID $currentOrderId");
  //
  //
  //   try {
  //     // final Uri url = Uri.parse(NetworkConstantsUtil.register);
  //
  //     final Uri url = Uri.parse(
  //         "http://192.168.10.45:8000/api/driver/order-status/$currentOrderId");
  //
  //     var request = http.MultipartRequest('POST', url);
  //
  //
  //     // Add fields to the request
  //     request.fields['order_status'] = selectedStatusId.toString();
  //     request.fields['reason_update'] = reasonUpdateController.text;
  //     request.fields['attempt_validation'] = attemptValidationController.text;
  //
  //     // Add the license number photo as a multipart file (check the file type)
  //
  //     if(showMultimediaPhoto){
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
  //
  //
  //     print(request.fields);
  //
  //
  //     // Send the request
  //     var response = await request.send();
  //
  //     // Process the response
  //
  //     final responseString = await response.stream.bytesToString();
  //     final Map<String, dynamic> responseData = jsonDecode(responseString);
  //
  //
  //
  //     bool isSuccess = responseData['success'];
  //     String message = responseData['message'];
  //     // String details = responseData['details'];
  //
  //     print(message);
  //     // print(details);
  //
  //     if (isSuccess) {
  //       // Handle success case
  //       showCustomSnackBar(context, message);
  //       // clearControllers();
  //
  //       // context.go('/signIn');
  //     } else {
  //       // Handle error case
  //       showCustomSnackBar(context, message);
  //     }
  //   } catch (e) {
  //     print("Error: $e");
  //     showCustomSnackBar(context, e.toString());
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

}
