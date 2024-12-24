import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:go_router/go_router.dart';
import 'package:o_deliver/providers/deliveryScreen_provider.dart';
import 'package:o_deliver/shared_pref_helper.dart';
import 'package:provider/provider.dart';

import '../../background_service.dart';
import '../../components/delivery_card.dart';
import '../../location_service.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  @override
  // void initState() {
  //   // TODO: implement initState
  //
  //   Provider.of<DeliveryScreenProvider>(context, listen: false)
  //       .driverPickedUpOrders();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    String? text = 'Start Service';
    print("Rebuilding");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery'),
        actions: [
          Consumer<DeliveryScreenProvider>(
            builder: (context, provider, child) {
              return Switch(
                value: provider.isSwitched ?? false,
                onChanged: (value) async {
                  provider.changeDriverStatus(value);
                  await SharedPrefHelper.saveBool("user-online", value);

                  // if (value) {
                  //   // Start the background service when the switch is turned on
                  //   await initializeService();
                  // } else {
                  //   // Stop the background service when the switch is turned off
                  //   final service = FlutterBackgroundService();
                  //   service.invoke('stopService');
                  // }

                  // await initializeService();
                  // final service = FlutterBackgroundService();
                  // bool isRunning = await service.isRunning();
                  // if (isRunning) {
                  //   service.invoke('stopService');
                  //   setState(() {
                  //     text = 'Start Service';
                  //   });
                  // } else {
                  //   service.startService();
                  //   setState(() {
                  //     text = 'Stop Service';
                  //   });
                  // }
                  // print("Widget Rebuild");
                  provider.updateDriverStatus(context);
                },
              );
            },
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TabBar(
                  tabs: [Text("Assigned Orders"), Text("Picked Up Orders")],
                )
              ],
            ),
          ),
          body: TabBarView(

            children: [
              Consumer<DeliveryScreenProvider>(
                builder: (context, provider, child) {
                  return ListView.builder(
                    itemCount: provider.assignedOrders.length,
                    itemBuilder: (context, index) {
                      final currentItem = provider.assignedOrders[index];

                      return InkWell(
                        onTap: () {
                          // context.push('/deliveryDetailScreen');
                        },
                        child: DeliveryCard(
                          applicationId: currentItem["order_id"],
                          status: currentItem["order_status"].toString(),
                          fromCity: currentItem["from_city"],
                          toCity: currentItem["to_city"],
                          date: '2020/03/27 - 09:00',
                          goodsType: 'Vegetable',
                          vehicleType: currentItem["pro_type"],
                          weight: currentItem["weight"].toString(),
                          price: currentItem["package_amt"].toDouble(),
                        ),
                      );
                    },
                  );
                },
              ),
              Consumer<DeliveryScreenProvider>(
                builder: (context, provider, child) {
                  return ListView.builder(
                    itemCount: provider.pickedUpOrders.length,
                    itemBuilder: (context, index) {
                      final currentItem = provider.pickedUpOrders[index];

                      return InkWell(
                        onTap: () {
                          // context.push('/deliveryDetailScreen');
                        },
                        child: DeliveryCard(
                          applicationId: currentItem["order_id"],
                          status: currentItem["order_status"].toString(),
                          fromCity: currentItem["from_city"],
                          toCity: currentItem["to_city"],
                          date: '2020/03/27 - 09:00',
                          goodsType: 'Vegetable',
                          vehicleType: currentItem["pro_type"],
                          weight: currentItem["weight"].toString(),
                          price: currentItem["package_amt"].toDouble(),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      // body: Consumer<DeliveryScreenProvider>(
      //   builder: (context, provider, child) {
      //     return ListView.builder(
      //       itemCount: provider.orders.length,
      //       itemBuilder: (context, index) {
      //         final currentItem = provider.orders[index];
      //
      //         return InkWell(
      //           onTap: () {
      //             // context.push('/deliveryDetailScreen');
      //           },
      //           child: DeliveryCard(
      //             applicationId: currentItem["order_id"],
      //             status: currentItem["order_status"].toString(),
      //             fromCity: currentItem["from_city"],
      //             toCity: currentItem["to_city"],
      //             date: '2020/03/27 - 09:00',
      //             goodsType: 'Vegetable',
      //             vehicleType: currentItem["pro_type"],
      //             weight: currentItem["weight"].toString(),
      //             price: currentItem["package_amt"].toDouble(),
      //           ),
      //         );
      //       },
      //     );
      //   },
      // ),
    );
  }
}
