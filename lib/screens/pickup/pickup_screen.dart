import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../values/app_colors.dart';  // For formatting date



class PickupScreen extends StatefulWidget {
  const PickupScreen({super.key});

  @override
  _PickupScreenState createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  TextEditingController _pickingPointController = TextEditingController();
  TextEditingController _deliveryPointController = TextEditingController();
  TextEditingController _goodsController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _loadingTimeController = TextEditingController();

  DateTime? selectedDateTime;

  Future<void> _selectDateTime(BuildContext context) async {
    // Step 1: Select Date
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (selectedDate == null) return;  // User canceled date selection

    // Step 2: Select Time
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime == null) return;  // User canceled time selection

    // Combine date and time
    final DateTime selectedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    setState(() {
      this.selectedDateTime = selectedDateTime;
      _loadingTimeController.text = DateFormat('yyyy/MM/dd, HH:mm').format(selectedDateTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Information'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        
              const Text('Shipping address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              _buildAddressSection(),
        
              const SizedBox(height: 20),
              const Text('Loading time', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextField(
                controller: _loadingTimeController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'For example: 2020/03/20, 09:00',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDateTime(context),
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Name of goods and volume', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildTextField(_goodsController, 'For example: rice, iron'),
              const SizedBox(height: 10),
              _buildTextField(_weightController, 'Enter the item weight', prefixText: 'Tons'),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Handle form submission
                  context.go('/pickupDetailScreen');
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: AppColors.appThemeColor
                ),
                child:  const Text('Continue', style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, {String? prefixText}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        //labelText: labelText,
        hintText: labelText,
        //prefixText: prefixText,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }

  Widget _buildAddressSection() {
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
               const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // First location details


                   // _buildTextField(_pickingPointController, 'Picking point'),
                    Text(
                      'Los Angeles, California, USA',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 45),
                    //_buildTextField(_deliveryPointController, 'Point of delivery'),

                    Text(
                      'Los Angeles, California, USA',
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
}


class DottedLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        5, // Number of dots
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

