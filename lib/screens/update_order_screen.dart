import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:o_deliver/main.dart';
import 'package:o_deliver/providers/successAndUnsuccessScreen.dart';
import 'package:o_deliver/providers/update_order_provider.dart';
import 'package:provider/provider.dart';
import '../values/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class UpdateOrderScreen extends StatelessWidget {
  const UpdateOrderScreen({
    super.key,
    required this.currentOrderId,
    required this.currentItem,
  });

  final String currentOrderId;
  final Map<String, dynamic> currentItem;

  @override
  Widget build(BuildContext context) {
    final updateOrderProvider = Provider.of<UpdateOrderProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        updateOrderProvider.clearControllersAndStatus();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("ORDER UPDATE SCREEN"),
        ),
        body: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("ORDER ID: ${currentItem["order_id"]}"),
                  SizedBox(height: 5),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Align(
                          child: const Text(
                            "CUSTOMER INFORMATION",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "Name: ",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(currentItem["to_name"]),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Country: ",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(currentItem["to_country"]),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Area: ",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(currentItem["to_area"]),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Address 1: ",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(currentItem["to_address_1"]),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Address 2: ",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(currentItem["to_address_2"]),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Phone Number: ",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(currentItem["to_phone"]),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),

                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Align(
                          child: const Text(
                            "CONSIGNEE INFORMATION",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "Name: ",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(currentItem["from_name"]),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Country: ",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(currentItem["from_country"]),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Area: ",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(currentItem["from_area"]),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Address 1: ",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(currentItem["from_address_1"]),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Address 2: ",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(currentItem["from_address_2"]),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Phone Number: ",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(currentItem["from_phone"]),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildAddressSection(currentItem),
                  // _buildColumn(
                  //   headText: "Order Status",
                  //   items: updateOrderProvider.orderStatus.map((org) {
                  //     return DropdownMenuItem(
                  //       value: org['id'],
                  //       child: Text(org['name']),
                  //     );
                  //   }).toList(),
                  //   onChanged: (value) {
                  //     updateOrderProvider.setSelectedStatus(
                  //       value as int?,
                  //       updateOrderProvider.orderStatus
                  //           .firstWhere((org) => org['id'] == value)['name'],
                  //     );
                  //   },
                  //   selectedHead: updateOrderProvider.selectedStatusName,
                  // ),
                  // const SizedBox(height: 20),
                  // if (updateOrderProvider.showMultimediaPhoto)
                  //   GestureDetector(
                  //     onTap: () {
                  //       updateOrderProvider
                  //           .pickMultimediaPhoto((XFile image) {
                  //         updateOrderProvider.multimediaPhoto = image;
                  //       });
                  //     },
                  //     child: updateOrderProvider.multimediaPhoto != null
                  //         ? Center(
                  //             child: ClipRRect(
                  //               borderRadius: BorderRadius.circular(10),
                  //               child: Image.file(
                  //                 File(updateOrderProvider
                  //                     .multimediaPhoto!.path),
                  //                 height: 150,
                  //                 width: 150,
                  //                 fit: BoxFit.cover,
                  //               ),
                  //             ),
                  //           )
                  //         : DottedBorder(
                  //             color: Colors.grey,
                  //             // Border color
                  //             strokeWidth: 2,
                  //             // Border width
                  //             borderType: BorderType.RRect,
                  //             // Round rect border
                  //             radius: const Radius.circular(12),
                  //             // Rounded corners
                  //             dashPattern: const [5, 5],
                  //             // Do
                  //             child: const SizedBox(
                  //               width: double.infinity,
                  //               height: 80,
                  //               child: Column(
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 children: [
                  //                   Icon(
                  //                     Icons.add_photo_alternate_outlined,
                  //                     size: 40,
                  //                     color: Colors.grey,
                  //                   ),
                  //                   SizedBox(height: 8),
                  //                   Text(
                  //                     "Upload Profile Image",
                  //                     style: TextStyle(
                  //                       fontSize: 16,
                  //                       color: Colors.grey,
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //   ),
                  // const SizedBox(height: 20),
                  // if (updateOrderProvider.showReasonUpdate)
                  //   CustomTextField(
                  //     controller: updateOrderProvider.reasonUpdateController,
                  //     hintText: "Reason Update",
                  //     prefixIcon: const Icon(Icons.e_mobiledata),
                  //     validate: (value) {
                  //       if (value!.isEmpty) {
                  //         return 'Please enter reason update';
                  //       }
                  //       return null;
                  //     },
                  //   ),
                  // const SizedBox(height: 10),
                  // if (updateOrderProvider.showAttemptValidation)
                  //   CustomTextField(
                  //     controller:
                  //         updateOrderProvider.attemptValidationController,
                  //     hintText: "Attempt Validation",
                  //     prefixIcon: const Icon(Icons.e_mobiledata),
                  //     validate: (value) {
                  //       if (value!.isEmpty) {
                  //         return 'Please enter attempt validation';
                  //       }
                  //       return null;
                  //     },
                  //   ),
                  const SizedBox(height: 20),
                  if (currentItem["has_order_status"]["id"] == 2)
                    CustomButton(
                      onTap: () {
                        updateOrderProvider.updateOrder(
                            context, currentOrderId, "3");
                      },
                      buttonText: "Picked Up",
                      sizeWidth: double.infinity,
                      borderRadius: 30,
                      buttonColor: const Color(0xfff34147),
                    ),
                  if (currentItem["has_order_status"]["id"] == 3)
                    CustomButton(
                      onTap: () {
                        updateOrderProvider.updateOrder(
                            context, currentOrderId, "4");
                      },
                      buttonText: "On My Way",
                      sizeWidth: double.infinity,
                      borderRadius: 30,
                      buttonColor: const Color(0xfff34147),
                    ),
                  if (currentItem["has_order_status"]["id"] == 4)
                    CustomButton(
                      onTap: () {
                        updateOrderProvider.updateOrder(
                          context,
                          currentOrderId,
                          "5",
                        );
                      },
                      buttonText: "Arrived",
                      sizeWidth: double.infinity,
                      borderRadius: 30,
                      buttonColor: const Color(0xfff34147),
                    ),

                  if (currentItem["has_order_status"]["id"] == 5)
                    Column(
                      children: [
                        CustomButton(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SuccessAndUnsuccessfulScreen(
                                      currentOrderStatus: "6",
                                      currentOrderId: currentOrderId,
                                    ),
                              ),
                            );
                            // if (updateOrderProvider.formKey.currentState!.validate()) {
                            //   updateOrderProvider.updateOrder(
                            //     context,
                            //     currentOrderId,
                            //     "6", // Update status to 6 for Successful
                            //   );
                            // }
                          },
                          buttonText: "Successful",
                          sizeWidth: double.infinity,
                          borderRadius: 30,
                          buttonColor:
                          const Color(0xff28a745), // Green for Successful
                        ),
                        const SizedBox(height: 10),
                        CustomButton(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SuccessAndUnsuccessfulScreen(
                                      currentOrderStatus: "7",
                                      currentOrderId: currentOrderId,
                                    ),
                              ),
                            );
                            // if (updateOrderProvider.formKey.currentState!
                            //     .validate()) {
                            //   updateOrderProvider.updateOrder(
                            //     context,
                            //     currentOrderId,
                            //     "7", // Update status to 7 for Unsuccessful
                            //   );
                            // }
                          },
                          buttonText: "Unsuccessful",
                          sizeWidth: double.infinity,
                          borderRadius: 30,
                          buttonColor:
                          const Color(0xffdc3545), // Red for Unsuccessful
                        ),
                      ],
                    ),
                ],
              ),
            )
          ),
        ),
      ),
    );
  }

  Widget _buildAddressSection(Map<String, dynamic> currentItem) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  const Icon(Icons.location_on, color: Colors.orange),
                  DottedLine(), // Custom DottedLine widget
                  const Icon(Icons.location_on, color: AppColors.appThemeColor),
                ],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // First location details

                    // _buildTextField(_pickingPointController, 'Picking point'),
                    Text(
                      "${currentItem["from_city"]}, ${currentItem["from_area"]}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 45),

                    Text(
                      "${currentItem["to_city"]}, ${currentItem["to_area"]}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColumn({
    required String headText,
    required List<DropdownMenuItem> items,
    required void Function(dynamic)? onChanged,
    required String? selectedHead,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          headText,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Color(0xfff34147),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              hint: Text(selectedHead ?? "Select $headText"),
              items: items,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class DottedLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        6, // Number of dots
        (index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Container(
            width: 2,
            height: 5,
            color: Colors.grey[400],
          ),
        ),
      ),
    );
  }
}
