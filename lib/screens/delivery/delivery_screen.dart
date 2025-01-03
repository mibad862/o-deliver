import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:o_deliver/providers/deliveryScreen_provider.dart';
import 'package:o_deliver/shared_pref_helper.dart';
import 'package:provider/provider.dart';
import '../../background_service.dart';
import '../../components/delivery_card.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {

  @override
  Widget build(BuildContext context) {
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

                  if (value) {
                    // Start the background service when the switch is turned on
                    await initializeService();
                  } else {
                    // Stop the background service when the switch is turned off
                    final service = FlutterBackgroundService();
                    service.invoke('stopService');
                  }

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
            flexibleSpace: const Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TabBar(
                  tabs: [
                    Text("Instant Delivery"),
                    Text("Picked Up Orders"),
                  ],
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [

              Consumer<DeliveryScreenProvider>(
                builder: (context, provider, child) {
                  return provider.driverAllOrders.isEmpty
                      ? Center(child: Text(provider.orderStatus))
                      : ListView.builder(
                    itemCount: provider.driverAllOrders.length,
                    itemBuilder: (context, index) {
                      final currentItem = provider.driverAllOrders[index];

                      final createdAt = currentItem["created_at"];
                      final formattedDate = DateFormat('MMM d, yyyy').format(
                        DateTime.parse(createdAt),
                      );

                      return InkWell(
                        onTap: () {
                          context.push(
                              "/updateOrderScreen/${currentItem["id"]}");
                        },
                        child: DeliveryCard(
                          orderId: currentItem["order_id"],
                          status: currentItem["order_status"].toString(),
                          fromCity: currentItem["from_city"],
                          toCity: currentItem["to_city"],
                          date: formattedDate,
                          goodsType: currentItem["pro_type"],
                          fromName: currentItem["from_name"],
                          toName: currentItem["to_name"],
                          weight: currentItem["weight"].toString(),
                          price: currentItem["package_amt"].toDouble(),
                        ),
                      );
                    },
                  );
                },
              ),

              // Consumer<DeliveryScreenProvider>(
              //   builder: (context, provider, child) {
              //     return provider.assignedOrders.isEmpty
              //         ? const Center(child: Text("No Assigned Orders Found"))
              //         : ListView.builder(
              //             itemCount: provider.assignedOrders.length,
              //             itemBuilder: (context, index) {
              //               final currentItem = provider.assignedOrders[index];
              //
              //               return InkWell(
              //                 onTap: () {
              //                   context.push(
              //                       "/updateOrderScreen/${currentItem["id"]}");
              //                 },
              //                 child: DeliveryCard(
              //                   applicationId: currentItem["order_id"],
              //                   status: currentItem["order_status"].toString(),
              //                   fromCity: currentItem["from_city"],
              //                   toCity: currentItem["to_city"],
              //                   date: '2020/03/27 - 09:00',
              //                   goodsType: 'Vegetable',
              //                   vehicleType: currentItem["pro_type"],
              //                   weight: currentItem["weight"].toString(),
              //                   price: currentItem["package_amt"].toDouble(),
              //                 ),
              //               );
              //             },
              //           );
              //   },
              // ),
              Consumer<DeliveryScreenProvider>(
                builder: (context, provider, child) {
                  return provider.pickedUpOrders.isEmpty
                      ? const Center(child: Text("No Picked Up Orders Found"))
                      : ListView.builder(
                          itemCount: provider.pickedUpOrders.length,
                          itemBuilder: (context, index) {
                            final currentItem = provider.pickedUpOrders[index];

                            return InkWell(
                              onTap: () {
                                context.push(
                                    "/updateOrderScreen/${currentItem["id"]}");
                              },
                              child: DeliveryCard(
                                orderId: currentItem["order_id"],
                                status: currentItem["order_status"].toString(),
                                fromCity: currentItem["from_city"],
                                toCity: currentItem["to_city"],
                                date: '2020/03/27 - 09:00',
                                goodsType: 'Vegetable',
                                toName: "hey",
                                fromName: "hello",
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
    );
  }
}
