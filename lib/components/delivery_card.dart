import 'package:flutter/material.dart';
import 'package:o_deliver/values/app_colors.dart';
import 'package:o_deliver/widgets/custom_button.dart';

class DeliveryCard extends StatelessWidget {
  final String orderId;
  final String status;
  final String fromCity;
  final String toCity;
  final String date;
  final String goodsType;
  final String fromName;
  final String toName;
  final String weight;
  final double price;

  const DeliveryCard({
    super.key,
    required this.orderId,
    required this.status,
    required this.fromCity,
    required this.toCity,
    required this.date,
    required this.goodsType,
    required this.fromName,
    required this.toName,
    required this.weight,
    required this.price,
  });

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
                  'Order #$orderId',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: status == 'Canceled'
                        ? Colors.blue
                        : AppColors.appThemeColor,
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
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                // Background color similar to the image
                borderRadius: BorderRadius.circular(30), // Rounded corners
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    fromCity,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black), // Add styling if needed
                  ),
                  const Icon(Icons.arrow_forward),
                  Text(
                    toCity,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold), // Add styling if needed
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Date: $date"),
                Text("Type: $goodsType"),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("From: $fromName"),
                Text("To: $toName"),
              ],
            ),
            const SizedBox(height: 5),
            Text("Weight: $weight"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Delivery Total',
                    style: TextStyle(color: Colors.grey)),
                SizedBox(
                  width: 100,
                  child: Text(
                    '\$$price',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            CustomButton(
              sizeHeight: 30,
              onTap: (){},
              buttonText: "Direction",
              sizeWidth: 100,
            ),
          ],
        ),
      ),
    );
  }
}
