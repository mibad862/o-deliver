import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:o_deliver/util/snackbar_util.dart';
import '../api_handler/api_wrapper.dart';
import '../api_handler/network_constant.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class SignUpProvider with ChangeNotifier {
  SignUpProvider() {
    fetchAllData();
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController licenseNumberController = TextEditingController();
  final TextEditingController licensePlateController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final loaderQuantityController = TextEditingController();
  final dobController = TextEditingController();
  final licenseExpiryController = TextEditingController();
  final vehicleInsuranceExpiryController = TextEditingController();
  final addressController = TextEditingController();
  final drivingExperienceController = TextEditingController();
  final deliveryRadiusController = TextEditingController();
  final bankNameController = TextEditingController();
  final accountTitleController = TextEditingController();
  final accountNumberController = TextEditingController();

  bool driverAgreementChecked = false;
  bool cashLiabilityChecked = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  XFile? licenseNumberPhoto;
  XFile? verificationAddressPhoto;
  XFile? proofAddressPhoto;
  XFile? profileImagePhoto;
  XFile? certificateCharacterPhoto;
  XFile? vehicleInsurancePhoto;
  XFile? reference1Photo;
  XFile? reference2Photo;
  XFile? reference3Photo;
  XFile? selectedVideo;

  // void removePhoto(int index) {
  //   uploadedPhotos.removeAt(index);
  //   notifyListeners();
  // }

  // void pickImage() async {
  //   print('function hit');
  //   final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
  //   if (pickedImage != null) {
  //     uploadedPhoto = pickedImage;
  //     notifyListeners();
  //   }
  // }

  void setDriverAgreement(bool value) {
    driverAgreementChecked = value;
    notifyListeners(); // Notify listeners to rebuild UI
  }

  void setCashLiability(bool value) {
    cashLiabilityChecked = value;
    notifyListeners(); // Notify listeners to rebuild UI
  }

  bool get driverAgreementValue => driverAgreementChecked ? true : false;

  bool get cashLiabilityValue => cashLiabilityChecked ? true : false;

  Future<void> pickImage(Function(XFile) assignImage) async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      assignImage(pickedImage); // Call the callback with the picked image
      notifyListeners();
    }
  }

  Future<void> pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      selectedVideo = video;
      notifyListeners();
    }
  }

  Future<void> selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      final String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      controller.text = formattedDate;
      // You may want to trigger validation immediately
      notifyListeners();
    }
  }

  String? selectedTailgateOption; // Yes or No
  String? selectedLoaderOption; // Yes or No

  void setSelectedTailgateOption(String? value) {
    selectedTailgateOption = value;
    notifyListeners();
  }

  void setSelectedLoaderOption(String? value) {
    selectedLoaderOption = value;
    notifyListeners();
  }

  int get loaderValue => selectedLoaderOption == "Yes" ? 1 : 0;
  int get tailgateValue => selectedTailgateOption == "Yes" ? 1 : 0;


  void clearLoaderQuantity() {
    loaderQuantityController.clear();
    notifyListeners();
  }

  final _apiService = ApiService();

  int? selectedCityId;
  String? selectedCityName;

  int? selectedOrganizationId;
  String? selectedOrganizationName;

  int? selectedVehicleId;
  String? selectedVehicleName;

  int? selectedServiceId;
  String? selectedServiceName;

  int? selectedShiftId;
  String? selectedShiftName;

  int? selectedColorId;
  String? selectedColorName;

  String? selectedTruckOption;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool passVisible = true;

  bool get passwordVisible => passVisible;

  List<dynamic> _cities = [];

  List<dynamic> get cities => _cities;

  List<dynamic> _organizations = [];

  List<dynamic> get organizations => _organizations;

  List<dynamic> _vehicles = [];

  List<dynamic> get vehicles => _vehicles;

  List<dynamic> _services = [];

  List<dynamic> get services => _services;

  List<dynamic> _shifts = [];

  List<dynamic> get shifts => _shifts;

  List<dynamic> _areas = [];

  List<dynamic> get areas => _areas;

  List<dynamic> _days = [];

  List<dynamic> get days => _days;

  List<dynamic> _colors = [];

  List<dynamic> get colors => _colors;

  List<int> selectedAreas = []; // List of selected area IDs
  List<int> selectedDays = []; // List of selected area IDs
  List<int> selectedServices = []; // List of selected area IDs

  void toggleAreaSelection(List<int> updatedAreas) {
    selectedAreas = updatedAreas; // Update the list with the new selection
    notifyListeners();
  }

  void toggleDaysSelection(List<int> updatedDays) {
    selectedDays = updatedDays; // Update the list with the new selection
    notifyListeners();
  }

  void toggleServicesSelection(List<int> updatedShifts) {
    selectedServices = updatedShifts; // Update the list with the new selection
    notifyListeners();
  }

  void setSelectedTruckOption(String? value) {
    selectedTruckOption = value;
    notifyListeners();
  }

  // void setSelectedVehicle(int? id, String? name) {
  //   selectedVehicleId = id;
  //   selectedVehicleName = name;
  //
  //   if (isTonTruck(name)) {
  //     // Show radio buttons for truck options
  //   } else {
  //     selectedTruckOption = null; // Reset if not a ton truck
  //   }
  //   print(
  //       "Selected ORG ID: $selectedOrganizationId"); // Print the selected city ID
  //   print(
  //       "Selected ORG Name: $selectedOrganizationName"); // Print the selected city ID
  //   notifyListeners();
  // }

  void setSelectedVehicle(int? id, String? name) {
    selectedVehicleId = id;
    selectedVehicleName = name;

    if (isTonTruck(name)) {
      // Reset truck option if a ton truck is selected
      selectedTruckOption = null;
    } else {
      selectedTruckOption = null; // Reset if not a ton truck
    }
    notifyListeners();
  }

  // void setSelectedVehicle(int? id, String? name) {
  //   selectedVehicleId = id;
  //   selectedVehicleName = name;
  //
  //   // Check if the selected vehicle name indicates a ton truck
  //   if (isTonTruck(name)) {
  //     // Show radio buttons for truck options
  //   } else {
  //     selectedTruckOption = null; // Reset if not a ton truck
  //   }
  //
  //   notifyListeners();
  // }

  bool isTonTruck(String? vehicleName) {
    return vehicleName != null && (vehicleName.contains("Ton Truck"));
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    passVisible = !passVisible;
    notifyListeners();
  }

  void setSelectedCity(int? id, String? name) {
    selectedCityId = id;
    selectedCityName = name;
    print("Selected City ID: $selectedCityId"); // Print the selected city ID
    print(
        "Selected City Name: $selectedCityName"); // Print the selected city ID
    notifyListeners();
  }

  void setSelectedService(int? id, String? name) {
    selectedServiceId = id;
    selectedServiceName = name;
    print("Selected City ID: $selectedServiceId"); // Print the selected city ID
    print(
        "Selected City Name: $selectedServiceName"); // Print the selected city ID
    notifyListeners();
  }

  void setSelectedOrganization(int? id, String? name) {
    selectedOrganizationId = id;
    selectedOrganizationName = name;
    print(
        "Selected ORG ID: $selectedOrganizationId"); // Print the selected city ID
    print(
        "Selected ORG Name: $selectedOrganizationName"); // Print the selected city ID
    notifyListeners();
  }

  void setSelectedShift(int? id, String? name) {
    selectedShiftId = id;
    selectedShiftName = name;
    print("Selected ORG ID: $selectedShiftId"); // Print the selected city ID
    print(
        "Selected ORG Name: $selectedShiftName"); // Print the selected city ID
    notifyListeners();
  }

  void setSelectedColor(int? id, String? name) {
    selectedColorId = id;
    selectedColorName = name;
    print("Selected COLOR ID: $selectedColorId"); // Print the selected city ID
    print(
        "Selected COLOR Name: $selectedColorName"); // Print the selected city ID
    notifyListeners();
  }

  // Fetch cities from the API

  Future<void> fetchAllData() async {
    // _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.getApiWithoutToken(
        NetworkConstantsUtil.getAllData,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Check if the response indicates success
        if (responseData['success']) {
          // Extract cities from the response
          final List<dynamic> cityData = responseData['data']['cities'];
          _cities = cityData;

          final List<dynamic> organizationData =
              responseData['data']['organizations'];
          _organizations = organizationData;

          final List<dynamic> vehiclesData =
              responseData['data']['vehicle_types'];
          _vehicles = vehiclesData;

          final List<dynamic> servicesData =
              responseData['data']['service_types'];
          _services = servicesData;

          final List<dynamic> shiftsData = responseData['data']['shifts'];
          _shifts = shiftsData;

          final List<dynamic> areasData = responseData['data']['areas'];
          _areas = areasData;

          final List<dynamic> daysData = responseData['data']['days'];
          _days = daysData;

          final List<dynamic> colorsData = responseData['data']['colors'];
          _colors = colorsData;

          print(_cities);
          print("VEHICLES $_vehicles");
          print("SERVICES $_services");
          print("AREAS $_areas");
          print("COLORS $_colors");
          notifyListeners();
        } else {
          throw Exception('Failed to load cities: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to load cities: ${response.body}');
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      // _isLoading = false;
      notifyListeners();
    }
  }

  // Add a function to calculate age based on the date of birth
  int _calculateAge(DateTime birthDate) {
    final DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  // Validate if the user is at least 18 years old
  String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date of Birth is required';
    }
    try {
      final DateTime birthDate =
          DateTime.parse(value); // Assuming the date format is YYYY-MM-DD
      final int age = _calculateAge(birthDate);
      if (age < 18) {
        return 'You must be at least 18 years old';
      }
    } catch (e) {
      return 'Invalid date format';
    }
    return null; // No error
  }

  Future<void> signUp(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    // Check if the license number photo has been selected
    if (licenseNumberPhoto == null) {
      showCustomSnackBar(context, "Please select a license number photo.");
      return;
    }

    if (selectedVideo == null) {
      showCustomSnackBar(context, "Please select a video first.");
      return;
    }

    try {
      // final Uri url = Uri.parse(NetworkConstantsUtil.register);

      final Uri url = Uri.parse(
          "https://driverapp.staging.pegasync.com/api/driver/register");

      var request = http.MultipartRequest('POST', url);

      debugPrint("SELECTED SERVICES ${selectedServices.toString()}");

      // Add fields to the request
      request.fields['name'] = nameController.text;
      request.fields['display_name'] = displayNameController.text;
      request.fields['email'] = emailController.text;
      request.fields['password'] = passwordController.text;
      request.fields['phone_number'] = phoneNumberController.text;
      request.fields['status'] = "3";
      request.fields['city_id'] = selectedCityId.toString();
      request.fields['organization_id'] = selectedOrganizationId.toString();
      request.fields['address'] = addressController.text;
      request.fields['experience'] = drivingExperienceController.text;
      request.fields['dob'] = dobController.text;
      request.fields['delivery_radius'] = deliveryRadiusController.text;
      request.fields['driver_agreement_contract'] = driverAgreementValue.toString();
      request.fields['cash_liability_agreement'] = cashLiabilityValue.toString();
      request.fields['available_days'] = selectedDays.join(','); // Convert list to comma-separated string
      request.fields['bank_name'] = bankNameController.text;
      request.fields['account_title'] = accountTitleController.text;
      request.fields['account_number'] = accountNumberController.text;
      request.fields['driver_service_area_id'] = selectedAreas.join(','); // Convert list to comma-separated string
      request.fields['shift_id'] = selectedShiftId.toString();
      request.fields['service_type_id'] = selectedServices.join(',');
      request.fields['license_plate'] = licensePlateController.text;
      // request.fields['color'] = colorController.text;
      request.fields['loader_value'] = loaderValue.toString();
      request.fields['tail_gate_value'] = tailgateValue.toString();
      request.fields['loader_quantity'] = loaderQuantityController.text;
      request.fields['color'] = selectedColorId.toString();
      request.fields['description'] = descriptionController.text;
      request.fields['vehicle_type_id'] = selectedVehicleId.toString();
      // request.fields['service_type_id'] = "1";
      request.fields['license_expiry_date'] = licenseExpiryController.text;
      request.fields['vehicle_insurance_expiry_date'] =
          vehicleInsuranceExpiryController.text;

      // Add the license number photo as a multipart file (check the file type)
      var licenseNumberFile = await http.MultipartFile.fromPath(
        'license_number', // Field name in the API
        licenseNumberPhoto!.path, // Path to the picked image
        contentType: MediaType(
            'image',
            licenseNumberPhoto!.path
                .split('.')
                .last), // Set content type dynamically
      );

      var vehicleVideoFile = await http.MultipartFile.fromPath(
        'vehicle_video', // Field name in the API
        selectedVideo!.path, // Path to the picked image
        contentType: MediaType(
          'video',
          selectedVideo!.path,
        ), // Set content type dynamically
      );

      var verificationAddressFile = await http.MultipartFile.fromPath(
        'verification_address', // Field name in the API
        verificationAddressPhoto!.path, // Path to the picked image
        contentType: MediaType(
            'image',
            verificationAddressPhoto!.path
                .split('.')
                .last), // Set content type dynamically
      );

      var proofAddressFile = await http.MultipartFile.fromPath(
        'proof_address', // Field name in the API
        proofAddressPhoto!.path, // Path to the picked image
        contentType: MediaType(
            'image',
            proofAddressPhoto!.path
                .split('.')
                .last), // Set content type dynamically
      );

      var profileImageFile = await http.MultipartFile.fromPath(
        'profileImage', // Field name in the API
        profileImagePhoto!.path, // Path to the picked image
        contentType: MediaType(
            'image',
            profileImagePhoto!.path
                .split('.')
                .last), // Set content type dynamically
      );

      var certificateCharacterImageFile = await http.MultipartFile.fromPath(
        'certificateCharacterImage', // Field name in the API
        certificateCharacterPhoto!.path, // Path to the picked image
        contentType: MediaType(
            'image',
            certificateCharacterPhoto!.path
                .split('.')
                .last), // Set content type dynamically
      );

      var vehicleInsuranceDetailFile = await http.MultipartFile.fromPath(
        'vehicle_insurance_detail', // Field name in the API
        vehicleInsurancePhoto!.path, // Path to the picked image
        contentType: MediaType(
            'image',
            vehicleInsurancePhoto!.path
                .split('.')
                .last), // Set content type dynamically
      );

      var reference1File = await http.MultipartFile.fromPath(
        'reference_1', // Field name in the API
        reference1Photo!.path, // Path to the picked image
        contentType: MediaType(
            'image',
            reference1Photo!.path
                .split('.')
                .last), // Set content type dynamically
      );

      var reference2File = await http.MultipartFile.fromPath(
        'reference_2', // Field name in the API
        reference2Photo!.path, // Path to the picked image
        contentType: MediaType(
            'image',
            reference2Photo!.path
                .split('.')
                .last), // Set content type dynamically
      );

      var reference3File = await http.MultipartFile.fromPath(
        'reference_3', // Field name in the API
        reference3Photo!.path, // Path to the picked image
        contentType: MediaType(
            'image',
            reference3Photo!.path
                .split('.')
                .last), // Set content type dynamically
      );

      // Add the file to the request
      request.files.add(licenseNumberFile);
      request.files.add(verificationAddressFile);
      request.files.add(proofAddressFile);
      request.files.add(profileImageFile);
      request.files.add(certificateCharacterImageFile);
      request.files.add(vehicleInsuranceDetailFile);
      request.files.add(reference1File);
      request.files.add(reference2File);
      request.files.add(reference3File);
      request.files.add(vehicleVideoFile);

      print(request.fields);
      print(request.files);
      print(request.files);

      // Send the request
      var response = await request.send();

      // Process the response

      final responseString = await response.stream.bytesToString();
      final Map<String, dynamic> responseData = jsonDecode(responseString);

      bool isSuccess = responseData['success'];
      String message = responseData['message'];
      // String details = responseData['details'];

      print(message);
      // print(details);

      if (isSuccess) {
        // Handle success case
        showCustomSnackBar(context, message);
        clearControllers();

        context.go('/signIn');
      } else {
        // Handle error case
        showCustomSnackBar(context, message);
      }

      // if (response.statusCode == 201) {
      //   final responseString = await response.stream.bytesToString();
      //   final Map<String, dynamic> responseData = jsonDecode(responseString);
      //
      //   bool isSuccess = responseData['success'];
      //   String message = responseData['message'];
      //
      //   if (isSuccess) {
      //     showCustomSnackBar(context, message);
      //     clearControllers();  // Clear input fields
      //     context.go('/signIn');  // Navigate to sign-in page
      //   } else {
      //     showCustomSnackBar(context, message);
      //   }
      // } else {
      //   showCustomSnackBar(context, "Failed to upload license photo.");
      //   print('Response Status Code: ${response.statusCode}');
      //
      //   final responseString = await response.stream.bytesToString();
      //   final Map<String, dynamic> responseData = jsonDecode(responseString);
      //
      //   print('Response Status Code: $responseData');
      // }
    } catch (e) {
      print("Error: $e");
      showCustomSnackBar(context, e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clean up controllers
  void clearControllers() {
    nameController.clear();
    dobController.clear();
    addressController.clear();
    licenseExpiryController.clear();
    displayNameController.clear();
    drivingExperienceController.clear();
    emailController.clear();
    passwordController.clear();
    deliveryRadiusController.clear();
    phoneNumberController.clear();
    licenseNumberController.clear();
    licensePlateController.clear();
    selectedCityName = "Select City";
    selectedOrganizationName = "Select Organization";
    selectedOrganizationName = "Select Vehicle";
    bankNameController.clear();
    accountTitleController.clear();
    descriptionController.clear();
    vehicleInsuranceExpiryController.clear();
    accountNumberController.clear();
    selectedAreas.clear();
    selectedDays.clear();
    selectedServices.clear();
    selectedShiftId = null;
    selectedShiftName = null;
    selectedVehicleId = null;
    selectedVehicleName = null;
    selectedColorId = null;
    selectedColorName = null;
    driverAgreementChecked = false;
    cashLiabilityChecked = false;

    licenseNumberPhoto = null;
    verificationAddressPhoto = null;
    proofAddressPhoto = null;
    profileImagePhoto = null;
    certificateCharacterPhoto = null;
    vehicleInsurancePhoto = null;
    reference1Photo = null;
    reference2Photo = null;
    reference3Photo = null;
  }
}
