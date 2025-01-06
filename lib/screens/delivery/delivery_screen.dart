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
  void initState() {
    super.initState();
    // Fetch all orders when the screen loads
    Provider.of<DeliveryScreenProvider>(context, listen: false).fetchAllOrders();
  }
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
                    Text("Hub & Spoke"),
                    Text("Instant Delivery"),
                  ],
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Consumer<DeliveryScreenProvider>(
                builder: (context, provider, child) {
                  return provider.hubAndSpokeOrders.isEmpty
                      ? Center(child: Text(provider.orderStatus))
                      : ListView.builder(
                          itemCount: provider.hubAndSpokeOrders.length,
                          itemBuilder: (context, index) {
                            final currentItem = provider.hubAndSpokeOrders[index];

                            final createdAt = currentItem["created_at"];
                            final formattedDate =
                                DateFormat('MMM d, yyyy').format(
                              DateTime.parse(createdAt),
                            );

                            return InkWell(
                              onTap: () {
                                context.push(
                                  "/updateOrderScreen/${currentItem["id"]}",
                                  extra: currentItem
                                );
                              },
                              child: DeliveryCard(
                                orderLat:
                                    double.parse(currentItem["to_latitude"]),
                                orderLng:
                                    double.parse(currentItem["to_longitude"]),
                                orderId: currentItem["order_id"],
                                status: currentItem["has_order_status"]["name"],
                                fromCity: currentItem["from_city"],
                                toCity: currentItem["to_city"],
                                date: formattedDate,
                                goodsType: currentItem["pro_type"],
                                organizationName: currentItem["organization_id"],
                                deliveryType: currentItem["delivery_type"],
                                weight: currentItem["weight"].toString(),
                                price: currentItem["package_amt"].toDouble(),
                                itemCost: currentItem["item_cost"],
                              ),
                            );
                          },
                        );
                },
              ),

              Consumer<DeliveryScreenProvider>(
                builder: (context, provider, child) {
                  return provider.instantDeliveryOrders.isEmpty
                      ? const Center(
                          child: Text("No Instant Delivery Orders Found"))
                      : ListView.builder(
                          itemCount: provider.instantDeliveryOrders.length,
                          itemBuilder: (context, index) {
                            final currentItem = provider.instantDeliveryOrders[index];

                            return InkWell(
                              onTap: () {
                                context.push(
                                    "/updateOrderScreen/${currentItem["id"]}");
                              },
                              child: DeliveryCard(
                                orderLng: 1.0,
                                orderLat: 1.0,
                                orderId: currentItem["order_id"],
                                status: currentItem["has_order_status"]["name"],
                                fromCity: currentItem["from_city"],
                                toCity: currentItem["to_city"],
                                date: '2020/03/27 - 09:00',
                                goodsType: 'Vegetable',
                                deliveryType: "hey",
                                organizationName: "hello",
                                weight: currentItem["weight"].toString(),
                                price: currentItem["package_amt"].toDouble(),
                                itemCost: currentItem["item_cost"],
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
