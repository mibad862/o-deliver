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
    print("Rebuilding Delivery Screen");
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
                    final service = FlutterBackgroundService();

                    if (value) {
                      // Start the background service only if not already running
                      if (!(await service.isRunning())) {
                        await service
                            .startService(); // Explicitly start the service
                      }
                    } else {
                      // Stop the background service
                      service.invoke('stopService');
                    }

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
                    return RefreshIndicator(
                      onRefresh: () async {
                        await provider.fetchAllOrders();
                      },
                      child: provider.hubAndSpokeOrders.isEmpty
                          ? SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: Center(
                                  child: Text(provider.orderStatus),
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: provider.hubAndSpokeOrders.length,
                              itemBuilder: (context, index) {
                                final currentItem =
                                    provider.hubAndSpokeOrders[index];
                                final createdAt = currentItem["created_at"];
                                final formattedDate =
                                    DateFormat('MMM d, yyyy').format(
                                  DateTime.parse(createdAt),
                                );

                                return InkWell(
                                  onTap: () {
                                    context.push(
                                      "/updateOrderScreen/${currentItem["id"]}",
                                      extra: currentItem,
                                    );
                                  },
                                  child: DeliveryCard(
                                    orderLat: double.parse(
                                        currentItem["to_latitude"]),
                                    orderLng: double.parse(
                                        currentItem["to_longitude"]),
                                    orderId: currentItem["order_id"],
                                    status: currentItem["has_order_status"]
                                        ["name"],
                                    fromCity: currentItem["from_city"],
                                    toCity: currentItem["to_city"],
                                    date: formattedDate,
                                    goodsType: currentItem["pro_type"],
                                    organizationName:
                                        currentItem["organization_id"],
                                    deliveryType: currentItem["delivery_type"],
                                    weight: currentItem["weight"].toString(),
                                    price:
                                        currentItem["package_amt"].toDouble(),
                                    itemCost: currentItem["item_cost"],
                                  ),
                                );
                              },
                            ),
                    );
                  },
                ),

                Consumer<DeliveryScreenProvider>(
                  builder: (context, provider, child) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        await provider.fetchAllOrders();
                      },
                      child: provider.instantDeliveryOrders.isEmpty
                          ? SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: Center(
                                  child: Text(provider.orderStatus),
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: provider.instantDeliveryOrders.length,
                              itemBuilder: (context, index) {
                                final currentItem =
                                    provider.instantDeliveryOrders[index];
                                final createdAt = currentItem["created_at"];
                                final formattedDate =
                                    DateFormat('MMM d, yyyy').format(
                                  DateTime.parse(createdAt),
                                );

                                return InkWell(
                                  onTap: () {
                                    context.push(
                                      "/updateOrderScreen/${currentItem["id"]}",
                                      extra: currentItem,
                                    );
                                  },
                                  child: DeliveryCard(
                                    orderLat: double.parse(
                                        currentItem["to_latitude"]),
                                    orderLng: double.parse(
                                        currentItem["to_longitude"]),
                                    orderId: currentItem["order_id"],
                                    status: currentItem["has_order_status"]
                                        ["name"],
                                    fromCity: currentItem["from_city"],
                                    toCity: currentItem["to_city"],
                                    date: formattedDate,
                                    goodsType: currentItem["pro_type"],
                                    deliveryType: currentItem["delivery_type"],
                                    organizationName:
                                        currentItem["organization_id"],
                                    weight: currentItem["weight"].toString(),
                                    price:
                                        currentItem["package_amt"].toDouble(),
                                    itemCost: currentItem["item_cost"],
                                  ),
                                );
                              },
                            ),
                    );
                  },
                ),
                // Consumer<DeliveryScreenProvider>(
                //   builder: (context, provider, child) {
                //     return provider.hubAndSpokeOrders.isEmpty
                //         ? Center(child: Text(provider.orderStatus))
                //         : ListView.builder(
                //             itemCount: provider.hubAndSpokeOrders.length,
                //             itemBuilder: (context, index) {
                //               final currentItem =
                //                   provider.hubAndSpokeOrders[index];
                //
                //               final createdAt = currentItem["created_at"];
                //               final formattedDate =
                //                   DateFormat('MMM d, yyyy').format(
                //                 DateTime.parse(createdAt),
                //               );
                //
                //               return InkWell(
                //                 onTap: () {
                //                   context.push(
                //                       "/updateOrderScreen/${currentItem["id"]}",
                //                       extra: currentItem);
                //                 },
                //                 child: DeliveryCard(
                //                   orderLat:
                //                       double.parse(currentItem["to_latitude"]),
                //                   orderLng:
                //                       double.parse(currentItem["to_longitude"]),
                //                   // orderId: "",
                //                   // status: "",
                //                   // fromCity: "",
                //                   // toCity: "",
                //                   // date: "",
                //                   // goodsType: "",
                //                   // organizationName: "",
                //                   // deliveryType: "",
                //                   // weight: "",
                //                   // price: 1,
                //                   // itemCost: "",
                //                   orderId: currentItem["order_id"],
                //                   status: currentItem["has_order_status"]
                //                       ["name"],
                //                   fromCity: currentItem["from_city"],
                //                   toCity: currentItem["to_city"],
                //                   date: formattedDate,
                //                   goodsType: currentItem["pro_type"],
                //                   organizationName:
                //                       currentItem["organization_id"],
                //                   deliveryType: currentItem["delivery_type"],
                //                   weight: currentItem["weight"].toString(),
                //                   price: currentItem["package_amt"].toDouble(),
                //                   itemCost: currentItem["item_cost"],
                //                 ),
                //               );
                //             },
                //           );
                //   },
                // ),
                // Consumer<DeliveryScreenProvider>(
                //   builder: (context, provider, child) {
                //     return provider.instantDeliveryOrders.isEmpty
                //         ? Center(child: Text(provider.orderStatus))
                //         : ListView.builder(
                //             itemCount: provider.instantDeliveryOrders.length,
                //             itemBuilder: (context, index) {
                //               final currentItem =
                //                   provider.instantDeliveryOrders[index];
                //               final createdAt = currentItem["created_at"];
                //               final formattedDate =
                //                   DateFormat('MMM d, yyyy').format(
                //                 DateTime.parse(createdAt),
                //               );
                //
                //               return InkWell(
                //                 onTap: () {
                //                   context.push(
                //                     "/updateOrderScreen/${currentItem["id"]}",
                //                     extra: currentItem,
                //                   );
                //                 },
                //                 child: DeliveryCard(
                //                   orderLat:
                //                       double.parse(currentItem["to_latitude"]),
                //                   orderLng:
                //                       double.parse(currentItem["to_longitude"]),
                //                   orderId: currentItem["order_id"],
                //                   status: currentItem["has_order_status"]
                //                       ["name"],
                //                   fromCity: currentItem["from_city"],
                //                   toCity: currentItem["to_city"],
                //                   date: formattedDate,
                //                   goodsType: currentItem["pro_type"],
                //                   deliveryType: currentItem["delivery_type"],
                //                   organizationName:
                //                       currentItem["organization_id"],
                //                   weight: currentItem["weight"].toString(),
                //                   price: currentItem["package_amt"].toDouble(),
                //                   itemCost: currentItem["item_cost"],
                //                 ),
                //               );
                //             },
                //           );
                //   },
                // ),
              ],
            ),
          ),
        ));
  }
}
