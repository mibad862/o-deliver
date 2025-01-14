import 'package:flutter/material.dart';
import 'package:o_deliver/notificatioManagerNew.dart';
import 'package:o_deliver/notification_services.dart';
import 'package:o_deliver/screens/pickup/pickup_screen.dart';
import 'package:o_deliver/screens/settings_screen.dart';
import '../components/custom_bottom_bar.dart';
import 'analytics/analytics_screen.dart';
import 'delivery/delivery_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

 // NotificationServices notificationService = NotificationServices();
  NotificationManagerNew notificationManagerNew = NotificationManagerNew();
  // LocationService locationService = LocationService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // locationService.requestLocationPermission();
   /* notificationService.getNotificationPermission();
    notificationService.firebaseInit(context);*/
    notificationManagerNew.requestNotificationPermission();
    notificationManagerNew.firebaseInit(context);
    notificationManagerNew.setupInteractMessage(context);
    notificationManagerNew.foregroundMessage();

    print("ALL SERVICES HAS BEEN INITIALIZED");
  }

  // Future<void> _requestPermissions() async {
  //   // Request location permission
  //   bool locationPermissionGranted = await locationService.requestLocationPermission();
  //
  //   // Once location permission is granted, request notification permission
  //   if (locationPermissionGranted) {
  //     await notificationService.getNotificationPermission();
  //   } else {
  //     // Handle case when location permission is not granted
  //     print("Location permission not granted");
  //   }
  //
  //   // Initialize notifications after permission is granted
  //   notificationService.firebaseInit(context);
  // }



  int _selectedIndex = 0;

  // List of screens for each tab
  final List<Widget> _screens = [
    const DeliveryScreen(),
    const PickupScreen(),
    const AnalyticsScreen(),
    const SettingsScreen(),  // Add a settings screen or any other screen if needed
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],  // Show screen based on selected index
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
