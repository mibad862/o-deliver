import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:o_deliver/values/app_colors.dart';

class PickUpDetailScreen extends StatefulWidget {
  const PickUpDetailScreen({super.key});

  @override
  _PickUpDetailScreenState createState() => _PickUpDetailScreenState();
}

class _PickUpDetailScreenState extends State<PickUpDetailScreen> {
  TextEditingController notesVehicleCtrl = TextEditingController();

  // Text controllers for length, width, and height
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  String rowSize = '';
  Set<int> selectedCards = {};

  int selectedVehicleCount = 1;
  List<String> vehicleTypes = [
    'Trucks with awnings',
    'Container vehicles',
    'Refrigerated trucks',
    'Flatbed trucks',
  ];

  String selectedVehicleType = 'Trucks with awnings';

  List<XFile> _uploadedPhotos = [];

  final ImagePicker _picker = ImagePicker();

  void _pickImage() async {
    print('function hit');
    final List<XFile>? pickedImages = await _picker.pickMultiImage();
    if (pickedImages != null) {
      setState(() {
        _uploadedPhotos.addAll(pickedImages);
      });
    }
  }

  void _removePhoto(int index) {
    setState(() {
      _uploadedPhotos.removeAt(index);
    });
  }

  // Function to open the bottom sheet
  void _showRowSizeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      enableDrag: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context)
                .viewInsets
                .bottom, // Adjusts for the keyboard
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Row size',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //_buildTextField(_lengthController, 'Length', 1),
                  _buildInputField('Length', _lengthController),
                  const Text('-', style: TextStyle(fontSize: 20)),
                  _buildInputField('Width', _widthController),
                  const Text('-', style: TextStyle(fontSize: 20)),
                  _buildInputField('Height', _heightController),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the bottom sheet
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        rowSize =
                            '${_lengthController.text} - ${_widthController.text} - ${_heightController.text}';
                      });
                      Navigator.pop(context); // Close the bottom sheet
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.appThemeColor,
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper method to build input fields
  Widget _buildInputField(String label, TextEditingController controller) {
    return SizedBox(
      width: 100,
      child: TextField(
        //maxLines: maxLines,
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          filled: true,
          hintText: label,
          fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String labelText, int maxLines,
      {String? prefixText}) {
    return TextField(
      maxLines: maxLines,
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        hintText: labelText,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }

  List<Widget> _buildRowWithHyphens(String rowSize) {
    List<String> values =
        rowSize.split('-').map((value) => value.trim()).toList();
    List<Widget> widgets = [];

    for (int i = 0; i < values.length; i++) {
      widgets.add(Text(
        values[i],
        style: const TextStyle(fontSize: 16, color: Colors.black),
      ));
      // Add hyphen after each value except the last one
      if (i < values.length - 1) {
        widgets.add(const Text(
          ' - ',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ));
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order information'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back action
            context.goNamed('/mainScreen');
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Number of vehicles dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  //border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Number of vehicles',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    DropdownButton<int>(
                      value: selectedVehicleCount,
                      items: List.generate(
                        10,
                        (index) => DropdownMenuItem(
                          value: index + 1,
                          child: Text('${index + 1}'),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          selectedVehicleCount = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Row Size',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              GestureDetector(
                onTap: () {
                  _showRowSizeBottomSheet(context);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: rowSize.isEmpty
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Length (m)',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey)),
                            Text('-',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey)),
                            Text('Width (m)',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey)),
                            Text('-',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey)),
                            Text('Height (m)',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey)),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: _buildRowWithHyphens(rowSize),
                        ),
                ),
              ),

              const SizedBox(height: 10),
              _buildTextField(notesVehicleCtrl, 'Notes for vehicle owners', 4),
              const SizedBox(height: 20),

              // Add Photos section
              const Text(
                'Add photos',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              /*GestureDetector(
                onTap: () {
                  // Handle photo addition
                },
                child: Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text('Add photos'),
                  ),
                ),
              ),*/

              Column(children: [
                if (_uploadedPhotos.isNotEmpty)
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(_uploadedPhotos.length, (index) {
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(_uploadedPhotos[index].path),
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => _removePhoto(index),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _pickImage,
                  child: DottedBorder(
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
                            "Add photos",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ]),

              const SizedBox(height: 20),

              // Type of vehicle service section
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Type of vehicle service',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle distinguish action
                    },
                    child: const Text(
                      'Distinguish the car?',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              const SizedBox(height: 20),
              /*SizedBox(
                height: MediaQuery.of(context).size.width *.9, // Define a fixed height for the horizontal list

                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 10, // Number of cards
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width, // Define a fixed width for each card
                        child: Card(
                          color: Colors.grey.shade400,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/img/truck.png',
                                height: 250,
                                //scale: 1,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Trucks with Awnings',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Friendly with all types of goods',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),*/

              SizedBox(
                height: MediaQuery.of(context).size.width *
                    1.1, // Fixed height for the horizontal list
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 5, // Number of cards
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    bool isSelected = selectedCards
                        .contains(index); // Check if card is selected
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            // Toggle selection
                            if (isSelected) {
                              selectedCards.remove(index);
                            } else {
                              selectedCards.add(index);
                            }
                          });
                        },
                        child: SizedBox(
                          width: MediaQuery.of(context)
                              .size
                              .width, // Fixed width for each card
                          child: Card(
                            color: isSelected
                                ? AppColors.appThemeColor
                                : Colors.grey.shade200,
                            // Change color based on selection
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/img/truck.png',
                                  height: 250,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Trucks with Awnings',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Friendly with all types of goods',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Get a quote button
              ElevatedButton(
                onPressed: () {
                  // Handle get a quote action
                  context.go("/mainScreen");
                },
                child: const Text(
                  'Pickup',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.appThemeColor,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
