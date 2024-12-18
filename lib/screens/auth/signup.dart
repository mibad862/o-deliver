import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:o_deliver/components/area_dropdown.dart';
import 'package:o_deliver/util/snackbar_util.dart';
import 'package:provider/provider.dart';
import '../../providers/signup_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Consumer<SignUpProvider>(
              builder: (context, provider, child) {
                return Form(
                  key: provider.formKey,
                  // Assign formKey here
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xfff34147),
                        ),
                      ),
                      SizedBox(height: screenHeight * .02),
                      const Text(
                        "Driver Information",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                          color: Color(0xfff34147),
                        ),
                      ),
                      SizedBox(height: screenHeight * .01),
                      const Text(
                        "Name",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xfff34147),
                        ),
                      ),
                      // Name Field
                      CustomTextField(
                        controller: provider.nameController,
                        hintText: "John Doe",
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Name is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * .01),
                      const Text(
                        "Display Name",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xfff34147),
                        ),
                      ),
                      // Display Name Field
                      CustomTextField(
                        controller: provider.displayNameController,
                        hintText: "Johnny",
                        prefixIcon: const Icon(Icons.person_outline),
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Display name is required';
                          }
                          if (value.length < 2) {
                            return 'Display name must be at least 2 characters';
                          }

                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * .01),
                      const Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xfff34147),
                        ),
                      ),

                      CustomTextField(
                        controller: provider.emailController,
                        hintText: "john@example.com",
                        prefixIcon: const Icon(Icons.mail),
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Email is required';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * .01),

                      const Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xfff34147),
                        ),
                      ),
                      CustomTextField(
                        controller: provider.passwordController,
                        hintText: "Enter your password",
                        obscureText: provider.passwordVisible,
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(provider.passwordVisible
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: provider.togglePasswordVisibility,
                        ),
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters long';
                          }
                          // if (!value.contains(RegExp(r'[A-Z]'))) {
                          //   return 'Password must contain at least one uppercase letter';
                          // }
                          // if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                          //   return 'Password must contain at least one special character';
                          // }
                          return null;
                        },
                        maxLines: 1,
                      ),
                      SizedBox(height: screenHeight * .01),

                      const Text(
                        "Date of Birth",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xfff34147),
                        ),
                      ),

                      TextFormField(
                        controller: provider.dobController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: provider.validateAge,
                        decoration: InputDecoration(
                          hintText: "YYYY-MM-DD",
                          suffixIcon: IconButton(
                            onPressed: () {
                              provider.selectDate(
                                  context, provider.dobController);
                            },
                            icon: const Icon(Icons.calendar_month),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 2.0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        readOnly:
                            true, // Make the TextField read-only to prevent manual input
                      ),

                      SizedBox(height: screenHeight * .01),

                      const Text(
                        "Phone Number",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xfff34147),
                        ),
                      ),
                      CustomTextField(
                        controller: provider.phoneNumberController,
                        hintText: "+1 (123) 456-7890",
                        prefixIcon: const Icon(Icons.phone),
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your phone number';
                          }

                          if (value.length < 10 || value.length > 11) {
                            return 'Phone Number must be between 10 to 11 characters long';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * .01),
                      // _buildColumn(provider, "Organization"),

                    _buildColumn(
                      selectedHead: provider.selectedOrganizationName,
                      headText: "Organization",
                      items: provider.organizations.map((org) {
                        return DropdownMenuItem(
                          value: org['id'],
                          child: Text(org['name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        provider.setSelectedOrganization(
                          value as int?,
                          provider.organizations.firstWhere((org) => org['id'] == value)['name'],
                        );
                      },
                    ),


                    SizedBox(height: screenHeight * .01),

                      _buildColumn(
                        selectedHead: provider.selectedCityName,
                        headText: "City",
                        items: provider.cities.map((city) {
                          return DropdownMenuItem(
                            value: city['id'],
                            child: Text(city['name']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          provider.setSelectedCity(
                              value as int?,
                              provider.cities.firstWhere(
                                      (city) => city['id'] == value)['name']);
                        },
                      ),

                      SizedBox(height: screenHeight * .01),

                      const Text(
                        "Address",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xfff34147),
                        ),
                      ),

                      CustomTextField(
                        controller: provider.addressController,
                        hintText: "215 E Tasman Dr",
                        prefixIcon: const Icon(Icons.mail),
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your address';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: screenHeight * .02),

                      GestureDetector(
                        onTap: () {
                          provider.pickImage((XFile image) {
                            provider.proofAddressPhoto = image;
                          });
                        },
                        child: provider.proofAddressPhoto != null
                            ? Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(provider.proofAddressPhoto!.path),
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
                                dashPattern: [5, 5],
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
                                        "Upload Proof of Address",
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

                      SizedBox(height: screenHeight * .02),

                      GestureDetector(
                        onTap: () {
                          provider.pickImage((XFile image) {
                            provider.verificationAddressPhoto = image;
                          });
                        },
                        child: provider.verificationAddressPhoto != null
                            ? Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(provider
                                        .verificationAddressPhoto!.path),
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
                                dashPattern: [5, 5],
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
                                        "Upload Verification of Address",
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
                      SizedBox(height: screenHeight * .02),

                      GestureDetector(
                        onTap: () {
                          provider.pickImage((XFile image) {
                            provider.licenseNumberPhoto = image;
                          });
                        },
                        child: provider.licenseNumberPhoto != null
                            ? Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(provider.licenseNumberPhoto!.path),
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
                                dashPattern: [5, 5],
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
                                        "Upload License Number",
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

                      SizedBox(height: screenHeight * .02),

                      const Text(
                        "License Expiry Date",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xfff34147),
                        ),
                      ),

                      TextFormField(
                        controller: provider.licenseExpiryController,
                        //autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          hintText: "YYYY/MM/DD",
                          suffixIcon: IconButton(
                            onPressed: () {
                              provider.selectDate(
                                  context, provider.licenseExpiryController);
                            },
                            icon: const Icon(Icons.calendar_month),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 2.0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        readOnly:
                            true, // Make the TextField read-only to prevent manual input
                      ),

                      SizedBox(height: screenHeight * .01),

                      const Text(
                        "Years of Driving Experience",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xfff34147),
                        ),
                      ),

                      CustomTextField(
                        controller: provider.drivingExperienceController,
                        hintText: "5",
                        prefixIcon: const Icon(Icons.phone),
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your driving experience';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * .01),

                      const Text(
                        "Delivery Radius",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xfff34147),
                        ),
                      ),

                      CustomTextField(
                        controller: provider.deliveryRadiusController,
                        hintText: "Enter Delivery Radius in KM",
                        prefixIcon: const Icon(Icons.phone),
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your Delivery Radius';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: screenHeight * .01),

                      const Text(
                        "Service Areas",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xfff34147),
                        ),
                      ),
                      FieldDropdown(
                        dropDownName: "Service Area",
                        fields: List<Map<String, dynamic>>.from(provider.areas),
                        selectedFields: provider.selectedAreas,
                        onFieldSelectionChanged: (updatedSelectedAreas) {
                          provider.toggleAreaSelection(
                              updatedSelectedAreas); // Pass the updated list to the provider
                        },
                      ),
                      SizedBox(height: screenHeight * .01),
                      const Text(
                        "Available Days",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xfff34147),
                        ),
                      ),
                      FieldDropdown(
                        dropDownName: "Available Days",
                        fields: List<Map<String, dynamic>>.from(provider.days),
                        selectedFields: provider.selectedDays,
                        onFieldSelectionChanged: (updatedSelected) {
                          provider.toggleDaysSelection(
                            updatedSelected,
                          ); // Pass the updated list to the provider
                        },
                      ),

                      SizedBox(height: screenHeight * .01),

                      _buildColumn(
                        selectedHead: provider.selectedShiftName,
                        headText: "Shift",
                        items: provider.shifts.map((shift) {
                          return DropdownMenuItem(
                            value: shift['id'],
                            child: Text(shift['name']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          provider.setSelectedShift(
                              value as int?,
                              provider.shifts.firstWhere((shift) =>
                              shift['id'] == value)['name']);
                        },
                      ),

                      // const Text(
                      //   "Shift",
                      //   style: TextStyle(
                      //     fontSize: 15,
                      //     fontWeight: FontWeight.w400,
                      //     color: Color(0xfff34147),
                      //   ),
                      // ),
                      // Container(
                      //   padding: const EdgeInsets.symmetric(horizontal: 5),
                      //   width: double.infinity,
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(8),
                      //     border: Border.all(color: Colors.grey.shade400),
                      //   ),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text(provider.selectedShiftName ??
                      //           "Select Shift Type"),
                      //       DropdownButtonHideUnderline(
                      //         child: DropdownButton(
                      //           items: provider.shifts.map((shift) {
                      //             return DropdownMenuItem(
                      //               value: shift['id'],
                      //               child: Text(shift['name']),
                      //             );
                      //           }).toList(),
                      //           onChanged: (value) {
                      //             provider.setSelectedShift(
                      //                 value as int?,
                      //                 provider.shifts.firstWhere((shift) =>
                      //                     shift['id'] == value)['name']);
                      //           },
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      SizedBox(height: screenHeight * .04),

                      GestureDetector(
                        onTap: () {
                          provider.pickImage((XFile image) {
                            provider.profileImagePhoto = image;
                          });
                        },
                        child: provider.profileImagePhoto != null
                            ? Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(provider.licenseNumberPhoto!.path),
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
                                dashPattern: [5, 5],
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
                      SizedBox(height: screenHeight * .02),
                      GestureDetector(
                        onTap: () {
                          provider.pickImage((XFile image) {
                            provider.certificateCharacterPhoto = image;
                          });
                        },
                        child: provider.certificateCharacterPhoto != null
                            ? Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(provider
                                        .certificateCharacterPhoto!.path),
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
                                dashPattern: [5, 5],
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
                                        "Upload Certificate Character",
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
                      SizedBox(height: screenHeight * .02),
                      GestureDetector(
                        onTap: () {
                          provider.pickImage((XFile image) {
                            provider.reference1Photo = image;
                          });
                        },
                        child: provider.reference1Photo != null
                            ? Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(provider.reference1Photo!.path),
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
                                dashPattern: [5, 5],
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
                                        "Upload Reference 1",
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
                      SizedBox(height: screenHeight * .02),
                      GestureDetector(
                        onTap: () {
                          provider.pickImage((XFile image) {
                            provider.reference2Photo = image;
                          });
                        },
                        child: provider.reference2Photo != null
                            ? Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(provider.reference2Photo!.path),
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
                                dashPattern: [5, 5],
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
                                        "Upload Reference 2",
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
                      SizedBox(height: screenHeight * .02),
                      GestureDetector(
                        onTap: () {
                          provider.pickImage((XFile image) {
                            provider.reference3Photo = image;
                          });
                        },
                        child: provider.reference3Photo != null
                            ? Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(provider.reference3Photo!.path),
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
                                dashPattern: [5, 5],
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
                                        "Upload Reference 3",
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

                      SizedBox(height: screenHeight * .02),

                      CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text("Driver Agreement Contract"),
                        value: provider.driverAgreementChecked,
                        onChanged: (value) {
                          provider.setDriverAgreement(value!);
                        },
                      ),

                      CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text("Cash Liability Agreement"),
                        value: provider.cashLiabilityChecked,
                        onChanged: (value) {
                          provider.setCashLiability(value!);
                        },
                      ),


                      const SizedBox(height: 20),

                      const Text(
                        "Vehicle Information",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                          color: Color(0xfff34147),
                        ),
                      ),

                      SizedBox(height: screenHeight * .04),

                      _buildColumn(
                        selectedHead: provider.selectedVehicleName,
                        headText: "Vehicle",
                        items: provider.vehicles.map((org) {
                          return DropdownMenuItem(
                            value: org['id'],
                            child: Text(org['name']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          provider.setSelectedVehicle(
                            value as int?,
                            provider.vehicles.firstWhere(
                                    (org) => org['id'] == value)['name'],
                          );
                        },
                      ),

                      SizedBox(height: screenHeight * .01),

                      const Text(
                        "Service Type",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xfff34147),
                        ),
                      ),
                      FieldDropdown(
                        dropDownName: "Service Type",
                        fields:
                            List<Map<String, dynamic>>.from(provider.services),
                        selectedFields: provider.selectedServices,
                        onFieldSelectionChanged: (updatedSelected) {
                          provider.toggleServicesSelection(
                            updatedSelected,
                          ); // Pass the updated list to the provider
                        },
                      ),

                      if (provider
                          .isTonTruck(provider.selectedVehicleName)) ...[
                        const SizedBox(height: 20),
                        const Text('Select Tailgate Option:'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'Yes',
                                  groupValue: provider.selectedTailgateOption,
                                  onChanged: provider.setSelectedTailgateOption,
                                ),
                                const Text('Yes'),
                              ],
                            ),
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'No',
                                  groupValue: provider.selectedTailgateOption,
                                  onChanged: provider.setSelectedTailgateOption,
                                ),
                                const Text('No'),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        const Text('Select Loader Option:'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'Yes',
                                  groupValue: provider.selectedLoaderOption,
                                  onChanged: (value) {
                                    provider.setSelectedLoaderOption(value);
                                    if (value == 'Yes') {
                                      // Clear loader quantity if switching back to Yes
                                      provider.loaderQuantityController.clear();
                                    }
                                  },
                                ),
                                const Text('Yes'),
                              ],
                            ),
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'No',
                                  groupValue: provider.selectedLoaderOption,
                                  onChanged: (value) {
                                    provider.setSelectedLoaderOption(value);
                                    // Clear loader quantity if switching to No
                                    if (value == 'No') {
                                      provider.loaderQuantityController.clear();
                                    }
                                  },
                                ),
                                const Text('No'),
                              ],
                            ),
                          ],
                        ),

                        // Conditionally display loader quantity input if Loader is selected as Yes
                        if (provider.selectedLoaderOption == 'Yes') ...[
                          const SizedBox(height: 20),
                          CustomTextField(
                            controller: provider.loaderQuantityController,
                            hintText: "Enter loader quantity",
                            prefixIcon: const Icon(Icons.format_list_numbered),
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter loader quantity';
                              }
                              if (int.tryParse(value) == null ||
                                  int.parse(value) <= 0) {
                                return 'Please enter a valid quantity';
                              }
                              return null;
                            },
                          ),
                        ],
                      ],

                      SizedBox(height: screenHeight * .01),

                      const Text(
                        "License Plate",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xfff34147),
                        ),
                      ),
                      CustomTextField(
                        controller: provider.licensePlateController,
                        hintText: "HCY 185",
                        prefixIcon: const Icon(Icons.card_membership),
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your license plate';
                          }
                          if (value.length > 10) {
                            return 'License Plate cannot be greater than 10';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: screenHeight * .01),

                      _buildColumn(
                        selectedHead: provider.selectedColorName,
                        headText: "Color",
                        items: provider.colors.map((color) {
                          return DropdownMenuItem(
                            value: color['id'],
                            child: Text(color['name']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          provider.setSelectedColor(
                              value as int?,
                              provider.colors.firstWhere((color) =>
                              color['id'] == value)['name']);
                        },
                      ),




                      SizedBox(height: screenHeight * .01),

                      const Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xfff34147),
                        ),
                      ),
                      CustomTextField(
                        controller: provider.descriptionController,
                        hintText: "Enter the description",
                        prefixIcon: const Icon(Icons.card_membership),
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the description';
                          }
                          if (value.length > 255) {
                            return 'Description cannot be greater than 255';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      GestureDetector(
                        onTap: () {
                          provider.pickImage((XFile image) {
                            provider.vehicleInsurancePhoto = image;
                          });
                        },
                        child: provider.vehicleInsurancePhoto != null
                            ? Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(provider.vehicleInsurancePhoto!.path),
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
                                dashPattern: [5, 5],
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
                                        "Upload Vehicle Insurance Detail",
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
                      SizedBox(height: screenHeight * .02),

                      GestureDetector(
                        onTap: () {
                          provider.pickVideo();
                        },
                        child: provider.selectedVideo != null
                            ? Text(provider.selectedVideo!.path.toString())
                            : DottedBorder(
                                color: Colors.grey,
                                // Border color
                                strokeWidth: 2,
                                // Border width
                                borderType: BorderType.RRect,
                                // Round rect border
                                radius: const Radius.circular(12),
                                // Rounded corners
                                dashPattern: [5, 5],
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
                                        "Upload Vehicle Video",
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

                      SizedBox(height: screenHeight * .04),

                      const Text(
                        "Vehicle Insurance Expiry Date",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xfff34147),
                        ),
                      ),

                      TextFormField(
                        controller: provider.vehicleInsuranceExpiryController,
                        //autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          hintText: "YYYY/MM/DD",
                          suffixIcon: IconButton(
                            onPressed: () {
                              provider.selectDate(context,
                                  provider.vehicleInsuranceExpiryController);
                            },
                            icon: const Icon(Icons.calendar_month),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 2.0),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        readOnly:
                            true, // Make the TextField read-only to prevent manual input
                      ),

                      const SizedBox(height: 20),

                      // Conditionally display radio buttons if a ton truck is selected
                      // Conditionally display options if a ton truck is selected

                      const SizedBox(height: 20),

                      const Text(
                        "Bank Information",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                          color: Color(0xfff34147),
                        ),
                      ),

                      const SizedBox(height: 15),

                      CustomTextField(
                        controller: provider.bankNameController,
                        hintText: "Enter your bank name",
                        prefixIcon: const Icon(Icons.card_membership),
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the bank name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      CustomTextField(
                        controller: provider.accountTitleController,
                        hintText: "Enter the name on the account",
                        prefixIcon: const Icon(Icons.card_membership),
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the account title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      CustomTextField(
                        textInputType: TextInputType.phone,
                        controller: provider.accountNumberController,
                        hintText: "Enter your account number",
                        prefixIcon: const Icon(Icons.card_membership),
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the account number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      // Sign Up Button
                      provider.isLoading
                          ? const Align(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator())
                          : CustomButton(
                              onTap: () {
                                if (provider.formKey.currentState!.validate()) {
                                  if (provider.selectedCityName == null) {
                                    showCustomSnackBar(
                                        context, "Please Select City");
                                    return;
                                  }
                                  if (provider.selectedOrganizationName ==
                                      null) {
                                    showCustomSnackBar(
                                        context, "Please Select Organization");
                                    return;
                                  } else {
                                    provider.signUp(context);
                                  }
                                }
                              },
                              buttonText: "Sign Up",
                              sizeWidth: double.infinity,
                              borderRadius: 30,
                              buttonColor: const Color(0xfff34147),
                            ),
                    ],
                  ),
                );
              },
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
