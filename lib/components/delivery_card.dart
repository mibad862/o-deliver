import 'package:flutter/material.dart';
import 'package:o_deliver/values/app_colors.dart';

class DeliveryCard extends StatelessWidget {
  final String applicationId;
  final String status;
  final String fromCity;
  final String toCity;
  final String date;
  final String goodsType;
  final String vehicleType;
  final String weight;
  final double price;

  const DeliveryCard({
    Key? key,
    required this.applicationId,
    required this.status,
    required this.fromCity,
    required this.toCity,
    required this.date,
    required this.goodsType,
    required this.vehicleType,
    required this.weight,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #$applicationId',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: status == 'Canceled' ? Colors.blue : AppColors.appThemeColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade400, // Background color similar to the image
                borderRadius: BorderRadius.circular(30), // Rounded corners
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    fromCity,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black), // Add styling if needed
                  ),
                  const Icon(Icons.arrow_forward),
                  Text(
                    toCity,
                    style: const TextStyle(fontWeight: FontWeight.bold), // Add styling if needed
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 4),
                    Text(date),
                  ],
                ),
                SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      const Icon(Icons.local_grocery_store, size: 16),
                      const SizedBox(width: 4),
                      Text(goodsType),
                    ],
                  ),
                )

              ],
            ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const Icon(Icons.local_shipping, size: 16),
                  const SizedBox(width: 4),
                  Text(vehicleType),
                ],),
                SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      const Icon(Icons.scale, size: 16),
                      const SizedBox(width: 4),
                      Text(weight,),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Delivery Total', style: TextStyle(color: Colors.grey)),
                SizedBox(
                  width: 100,
                  child: Text(
                    '\$$price',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            /*Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Reset order',
                  style: TextStyle(color: Colors.blue),
                ),
                const Icon(Icons.arrow_forward, color: Colors.blue),
              ],
            ),*/
          ],
        ),
      ),
    );
  }
}
