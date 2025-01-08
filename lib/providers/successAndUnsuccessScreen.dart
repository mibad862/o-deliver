import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:o_deliver/screens/main_screen.dart';
import 'package:provider/provider.dart';

import '../api_handler/network_constant.dart';
import '../shared_pref_helper.dart';
import '../util/snackbar_util.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'deliveryScreen_provider.dart';

class SuccessAndUnsuccessfulScreen extends StatefulWidget {
  const SuccessAndUnsuccessfulScreen({
    super.key,
    required this.currentOrderStatus,
    required this.currentOrderId,
  });

  final String currentOrderStatus;
  final String currentOrderId;

  @override
  State<SuccessAndUnsuccessfulScreen> createState() =>
      _SuccessAndUnsuccessfulScreenState();
}

class _SuccessAndUnsuccessfulScreenState
    extends State<SuccessAndUnsuccessfulScreen> {
  XFile? multimediaPhoto;
  final reasonUpdateController = TextEditingController();
  final attemptValidationController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Pick multimedia photo (either from camera or gallery)
  Future<void> pickMultimediaPhoto(void Function(XFile) onImagePicked) async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      onImagePicked(image);
      setState(() {});
    }
  }

  // Clear text controllers and reset the state
  void clearControllersAndStatus() {
    reasonUpdateController.clear();
    attemptValidationController.clear();
    multimediaPhoto = null;
    setState(() {});
  }

  // Update order by making an API request
  Future<void> updateOrder(
      BuildContext context, String currentOrderId, String orderStatus) async {
    EasyLoading.show(status: 'Updating the order');

    // Check if multimedia photo has been selected
    if (multimediaPhoto == null) {
      showCustomSnackBar(context, "Please upload the image.");
      EasyLoading.dismiss();
      return;
    }

    try {
      // Fetch token and driver ID from shared preferences
      final token = await SharedPrefHelper.getString("access-token");
      final currentDriverId = await SharedPrefHelper.getInt("driver-id");

      if (token == null || currentDriverId == null) {
        throw Exception("Token or Driver ID not found");
      }

      final Uri url = Uri.parse(
        "${NetworkConstantsUtil.baseUrl}${NetworkConstantsUtil.updateOrder}/$currentOrderId",
      );

      var request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = 'Bearer $token'
        ..headers['Content-Type'] = 'application/json'
        ..fields['driver_id'] = currentDriverId.toString()
        ..fields['order_status'] = orderStatus;

      // Add extra fields if current order status is "7"
      if (widget.currentOrderStatus == "7") {
        request.fields['reason_update'] = reasonUpdateController.text.trim();
        request.fields['attempt_validation'] =
            attemptValidationController.text.trim();
      }

      // Add the multimedia photo if applicable
      if (widget.currentOrderStatus == "6" ||
          widget.currentOrderStatus == "7") {
        var multiMediaPhoto = await http.MultipartFile.fromPath(
          'multimedia_upload',
          multimediaPhoto!.path,
          contentType: MediaType(
            'image',
            multimediaPhoto!.path.split('.').last,
          ),
        );
        request.files.add(multiMediaPhoto);
      }

      // Send the request
      var response = await request.send();
      final responseString = await response.stream.bytesToString();
      final responseData = jsonDecode(responseString);

      // Handle the response
      bool isSuccess = responseData['success'];
      String message = responseData['message'];

      if (isSuccess) {
        final deliveryScreenProvider =
            Provider.of<DeliveryScreenProvider>(context, listen: false);
        await deliveryScreenProvider.fetchAllOrders();
        showCustomSnackBar(context, message);
        clearControllersAndStatus();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
      } else {
        showCustomSnackBar(context, message);
      }
    } catch (e) {
      showCustomSnackBar(context, e.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Form(
          key: formKey,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
              // Show multimedia photo picker if the order status is "6" or "7"
              if (widget.currentOrderStatus == "6" ||
                  widget.currentOrderStatus == "7")
                GestureDetector(
                  onTap: () => pickMultimediaPhoto((XFile image) {
                    multimediaPhoto = image;
                  }),
                  child: multimediaPhoto != null
                      ? Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(multimediaPhoto!.path),
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : DottedBorder(
                          color: Colors.grey,
                          strokeWidth: 2,
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(12),
                          dashPattern: const [5, 5],
                          child: const SizedBox(
                            width: double.infinity,
                            height: 80,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Upload Image",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              const SizedBox(height: 20),

              // Show text fields for "Reason Update" and "Attempt Validation" if order status is "7"
              if (widget.currentOrderStatus == "7")
                CustomTextField(
                  controller: reasonUpdateController,
                  hintText: "Reason Update",
                  prefixIcon: const Icon(Icons.e_mobiledata),
                  validate: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the reason';
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 10),
              if (widget.currentOrderStatus == "7")
                CustomTextField(
                  controller: attemptValidationController,
                  hintText: "Attempt Validation",
                  prefixIcon: const Icon(Icons.e_mobiledata),
                  validate: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the attempt validation';
                    }
                    return null;
                  },
                ),
              SizedBox(height: 10),

              // "Arrived" button to update the order
              CustomButton(
                onTap: () {
                  if(widget.currentOrderStatus == "7"){
                    if (formKey.currentState!.validate()) {
                      updateOrder(context, widget.currentOrderId, widget.currentOrderStatus);
                    }
                  }else{
                    updateOrder(context, widget.currentOrderId, widget.currentOrderStatus);
                  }
                },
                buttonText: widget.currentOrderStatus == "6"
                    ? "Successful"
                    : "Unsuccessful",
                sizeWidth: double.infinity,
                borderRadius: 30,
                buttonColor: const Color(0xfff34147),
              ),
                        ],
                      ),
            )),
      ),
    );
  }
}
