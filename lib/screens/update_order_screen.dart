import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:o_deliver/providers/update_order_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class UpdateOrderScreen extends StatelessWidget {
  const UpdateOrderScreen({
    super.key,
    required this.currentOrderId,
  });

  final String currentOrderId;

  @override
  Widget build(BuildContext context) {
    final updateOrderProvider = Provider.of<UpdateOrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("ORDER UPDATE SCREEN"),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: updateOrderProvider.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("CURRENT ORDER ID: $currentOrderId"),
                _buildColumn(
                  headText: "Order Status",
                  items: updateOrderProvider.orderStatus.map((org) {
                    return DropdownMenuItem(
                      value: org['id'],
                      child: Text(org['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    updateOrderProvider.setSelectedStatus(
                      value as int?,
                      updateOrderProvider.orderStatus
                          .firstWhere((org) => org['id'] == value)['name'],
                    );
                  },
                  selectedHead: updateOrderProvider.selectedStatusName,
                ),
                const SizedBox(height: 20),
                if (updateOrderProvider.showMultimediaPhoto)
                  GestureDetector(
                    onTap: () {
                      updateOrderProvider.pickMultimediaPhoto((XFile image) {
                        updateOrderProvider.multimediaPhoto = image;
                      });
                    },
                    child: updateOrderProvider.multimediaPhoto != null
                        ? Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(updateOrderProvider.multimediaPhoto!.path),
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                        : DottedBorder(
                      color: Colors.grey,
                      // Border color
                      strokeWidth: 2,
                      // Border width
                      borderType: BorderType.RRect,
                      // Round rect border
                      radius: const Radius.circular(12),
                      // Rounded corners
                      dashPattern: const [5, 5],
                      // Do
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
                              "Upload Profile Image",
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
                if (updateOrderProvider.showReasonUpdate)
                  CustomTextField(
                    controller: updateOrderProvider.reasonUpdateController,
                    hintText: "Reason Update",
                    prefixIcon: const Icon(Icons.e_mobiledata),
                    validate: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter reason update';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 10),
                if (updateOrderProvider.showAttemptValidation)
                  CustomTextField(
                    controller: updateOrderProvider.attemptValidationController,
                    hintText: "Attempt Validation",
                    prefixIcon: const Icon(Icons.e_mobiledata),
                    validate: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter attempt validation';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 20),
                CustomButton(
                  onTap: () {
                    if (updateOrderProvider.formKey.currentState!.validate()) {
                      updateOrderProvider.updateOrder(context, currentOrderId);
                    }
                  },
                  buttonText: "Update",
                  sizeWidth: double.infinity,
                  borderRadius: 30,
                  buttonColor: const Color(0xfff34147),
                ),
              ],
            ),
          ),
        ),
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
