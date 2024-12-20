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
  Widget build(BuildContext context) {

    String? text = 'Start Service';
    print("Rebuilding");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery'),
        actions: [
          Consumer<DeliveryScreenProvider>(
            builder: (context, provider, child){
              return /*Switch(
                value: provider.isSwitched,
                onChanged: (value) async {
                  print("Widget Rebuild");

                  // Get the background service instance
                  final service = FlutterBackgroundService();

                  bool isRunning = await service.isRunning();

                  if (isRunning) {
                    // If service is running, stop it
                    service.invoke('stopService');
                    setState(() {
                      // Update switch value and any necessary text or state
                      provider.isSwitched = false;
                      text = 'Start Service'; // Update your text or state if needed
                    });
                  } else {
                    // If service is not running, start it
                    service.startService();
                    setState(() {
                      // Update switch value and any necessary text or state
                      provider.isSwitched = true;
                      text = 'Stop Service'; // Update your text or state if needed
                    });
                  }

                  // Optionally, you can also call provider.changeDriverStatus or other methods:
                  provider.changeDriverStatus(value);
                  provider.updateDriverStatus(context);
                },
              );*/

              Switch(
                value: provider.isSwitched ?? false,
                onChanged: (value) async{

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
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              context.push('/deliveryDetailScreen');
            },
            child: const DeliveryCard(
              applicationId: '30528',
              status: 'In-Progress',
              fromCity: 'Arena',
              toCity: 'Acono',
              date: '2020/03/27 - 09:00',
              goodsType: 'Vegetable',
              vehicleType: 'Truck',
              weight: '12 Kg',
              price: 254.08,
            ),
          );
        },
      ),
    );
  }
}
