import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:o_deliver/values/app_colors.dart';

class DeliveryDetailScreen extends StatelessWidget {
  const DeliveryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order 30528'),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //     context.goNamed('/mainScreen');
        //   },
        // ),
        backgroundColor: AppColors.appThemeColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Row with Cancel Button
            /*Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    // Handle cancel action
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
*/
            // Address of Order Section
            const Text(
              'Address of order',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildAddressSection(),
            const SizedBox(height: 16),

            // Loading time and sectors
            _buildOrderInfo(),
            const SizedBox(height: 16),

            // Truck Info Section
            _buildTruckInfo(context),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Complete button functionality
                  context.push('/deliveryCompleteScreen');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.appThemeColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Tap to Complete',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
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
                    Text(
                      'Los Angeles, California, USA',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.person, color: Colors.grey),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Push Puttichai',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.phone, color: Colors.grey),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '0123 456 789',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.message, color: Colors.grey),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Hopefully you will deliver to the delivery location on time and safely.',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
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

  Widget _buildOrderInfo() {
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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.calendar_today, color: AppColors.appThemeColor),
              SizedBox(width: 8),
              //  Text('Loading time', style: TextStyle(color: Colors.grey)),
              Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Loading time', style: TextStyle(color: Colors.grey)),
                  Text('2020/03/20 - 09:00', style: TextStyle(fontSize: 14)),
                ],
              )
            ],
          ),
          //Text('2020/03/20 - 09:00', style: TextStyle(fontSize: 14)),
          SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.view_list, color: AppColors.appThemeColor),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sectors', style: TextStyle(color: Colors.grey)),
                  Text('Vegetable', style: TextStyle(fontSize: 14)),
                ],
              )
            ],
          ),
          SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.local_shipping, color: AppColors.appThemeColor),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Volume of goods', style: TextStyle(color: Colors.grey)),
                  Text('12 Tons', style: TextStyle(fontSize: 14)),
                ],
              )
            ],
          ),
          SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.aspect_ratio, color: AppColors.appThemeColor),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Row size', style: TextStyle(color: Colors.grey)),
                  Text('14m x 2m x 2m', style: TextStyle(fontSize: 14)),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTruckInfo(BuildContext context) {
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
          const Text('Type of truck',
              style: TextStyle(color: Colors.grey, fontSize: 14)),

          const Text('Trucks with awnings', style: TextStyle(fontSize: 14)),
          SizedBox(
            height: 20,
            width: MediaQuery.of(context).size.width,
          ),

          const Text('Number of vehicles',
              style: TextStyle(color: Colors.grey, fontSize: 14)),

          const Text('1', style: TextStyle(fontSize: 14)),
          SizedBox(
            height: 20,
            width: MediaQuery.of(context).size.width,
          ),
          const Text('Type of contract',
              style: TextStyle(color: Colors.grey, fontSize: 14)),

          const Text('Complete car', style: TextStyle(fontSize: 14)),
          SizedBox(
            height: 20,
            width: MediaQuery.of(context).size.width,
          ),
          const Text('Request by car',
              style: TextStyle(color: Colors.grey, fontSize: 14)),

          const Text('30.0 Ton | 14m x 2m x 2m',
              style: TextStyle(fontSize: 14)),
          SizedBox(
            height: 20,
            width: MediaQuery.of(context).size.width,
          ),
          // GestureDetector(
          //   onTap: () {
          //     // Handle See details click
          //   },
          //   child: const Text(
          //     'See details',
          //     style: TextStyle(
          //         color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),
          //   ),
          // ),
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
        15, // Number of dots
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
