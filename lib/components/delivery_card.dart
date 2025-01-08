// import 'package:flutter/material.dart';
// import 'package:o_deliver/values/app_colors.dart';
// import 'package:o_deliver/widgets/custom_button.dart';
//
// class DeliveryCard extends StatelessWidget {
//   final String orderId;
//   final String status;
//   final String fromCity;
//   final String toCity;
//   final String date;
//   final String goodsType;
//   final String fromName;
//   final String toName;
//   final String weight;
//   final double price;
//
//   const DeliveryCard({
//     super.key,
//     required this.orderId,
//     required this.status,
//     required this.fromCity,
//     required this.toCity,
//     required this.date,
//     required this.goodsType,
//     required this.fromName,
//     required this.toName,
//     required this.weight,
//     required this.price,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       color: Colors.white,
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Order #$orderId',
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: status == 'Canceled'
//                         ? Colors.blue
//                         : AppColors.appThemeColor,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     status,
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Container(
//               padding: EdgeInsets.all(5),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade400,
//                 // Background color similar to the image
//                 borderRadius: BorderRadius.circular(30), // Rounded corners
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     fromCity,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black), // Add styling if needed
//                   ),
//                   const Icon(Icons.arrow_forward),
//                   Text(
//                     toCity,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold), // Add styling if needed
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("Date: $date"),
//                 Text("Type: $goodsType"),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("From: $fromName"),
//                 Text("To: $toName"),
//               ],
//             ),
//             const SizedBox(height: 5),
//             Text("Weight: $weight"),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('Delivery Total',
//                     style: TextStyle(color: Colors.grey)),
//                 SizedBox(
//                   width: 100,
//                   child: Text(
//                     '\$$price',
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, fontSize: 20),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 5),
//             CustomButton(
//               sizeHeight: 30,
//               onTap: (){},
//               buttonText: "Direction",
//               sizeWidth: 100,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:o_deliver/values/app_colors.dart';
import 'package:o_deliver/widgets/custom_button.dart';

class DeliveryCard extends StatelessWidget {
  final String orderId;
  final String status;
  final String fromCity;
  final String toCity;
  final String date;
  final String goodsType;
  final String organizationName;
  final String deliveryType;
  final String itemCost;
  final String weight;
  final double price;
  final double orderLat;
  final double orderLng;

  const DeliveryCard({
    super.key,
    required this.orderId,
    required this.itemCost,
    required this.status,
    required this.fromCity,
    required this.toCity,
    required this.date,
    required this.goodsType,
    required this.organizationName,
    required this.deliveryType,
    required this.weight,
    required this.price,
    required this.orderLat,
    required this.orderLng,
  });

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied. Enable them in settings.');
    }

    // Get current location
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> _openMapLauncher() async {
    try {
      // Fetch current location
      Position position = await _getCurrentLocation();
      double driverLat = position.latitude;
      double driverLng = position.longitude;

      if (await MapLauncher.isMapAvailable(MapType.google) ?? false) {
        await MapLauncher.showDirections(
          mapType: MapType.google,
          // origin: Coords(driverLat, driverLng),
          origin: Coords(10.6552566, -61.5042452),
          destination: Coords(orderLat, orderLng),
          //destination: Coords(24.86226886600727, 67.06396208672919),
          directionsMode: DirectionsMode.driving,
        );
      } else {
        debugPrint("Google Maps is not available on this device.");
      }
    } catch (e) {
      debugPrint('Error opening map: $e');
    }
  }

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
                  'Order ID: $orderId',
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
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    fromCity,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const Icon(Icons.arrow_forward),
                  Text(
                    toCity,
                    style: const TextStyle(fontWeight: FontWeight.bold),
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
            Text("Organization Name: $organizationName"),
            const SizedBox(height: 5),
            Text("Delivery Type: $deliveryType"),
            const SizedBox(height: 5),
            Text("Item Cost: $itemCost"),
            const SizedBox(height: 5),
            Text("Weight: $weight"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Package Amount: '),
                Text(
                  '\$$price',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: 30,
              width: 130,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.appThemeColor
                ),
                onPressed: _openMapLauncher,
                label: Text("Direction", style: TextStyle(color: Colors.white)),
                icon: Icon(Icons.directions, color: Colors.white),
              ),
            ),
            // CustomButton(
            //   sizeHeight: 30,
            //   onTap: _openMapLauncher,
            //   buttonText: "Direction",
            //   sizeWidth: 100,
            // ),
          ],
        ),
      ),
    );
  }
}
