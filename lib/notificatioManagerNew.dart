import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:o_deliver/main.dart';
import 'package:o_deliver/providers/deliveryScreen_provider.dart';
import 'package:o_deliver/screens/delivery/delivery_screen.dart';
import 'package:o_deliver/shared_pref_helper.dart';
import 'package:provider/provider.dart';

import 'api_handler/api_wrapper.dart';
import 'api_handler/network_constant.dart';

@pragma('vm:entry-point')
void handleNotificationActionBackground(NotificationResponse response) async {
  print('Background action handler triggered');
  print('Action ID: ${response.actionId}');

  // Fetch stored data
  final driverId = await SharedPrefHelper.getInt('driver-id');

  // print("Current Order Id ${message.data["orderId"]}");

  final params = {
    "status": response.actionId,
    "driver_id": driverId,
    // "order_id": message.data["orderId"],
  };

  print("Params sent to confirmOrder in background: $params");

  try {
    final responseData = await ApiService.postApiWithToken(
      endpoint: NetworkConstantsUtil.confirmOrder,
      body: params,
    );

    bool isSuccess = responseData['success'];
    String message = responseData['message'];
    print('isSuccess: $isSuccess, Message: $message');

    if (isSuccess) {
      print("Order successfully updated in the background.");
    } else {
      print("Failed to update order in the background: $message");
    }
  } catch (e) {
    print("Error in background action handler: $e");
  }
}

class NotificationManagerNew {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initLocalNotification(
      RemoteMessage message, BuildContext context) async {
    debugPrint('initLocalNotification');
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
      // This handles actions when the app is in the foreground or running in the background.
      print(
          'Foreground/Running: Action received with ID: ${response.actionId}');
      handleCallNotificationResponseForeground(context, response, message);
    },
        onDidReceiveBackgroundNotificationResponse:
            handleNotificationActionBackground);
  }

  void firebaseInit(BuildContext context) {
    debugPrint('firebaseInit');

    getDeviceToken();

    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('FirebaseMessaging.onMessage.listen');
      String? notificationType = message.data['notificationType'] as String?;
      // AndroidNotification? android = message.notification!.android;
      // if (Platform.isIOS) {
      //   if (notificationType == '1') {
      //     //to handle calls only, calls notifications are being handled by flutter local notification
      //     showNotificationButton(message);
      //   } else {
      //     foregroundMessage();
      //   }
      // }

      if (Platform.isAndroid) {
        debugPrint('isAndroid');
        initLocalNotification(message, context);
        if (notificationType == '1') {
          //to handle calls only, calls notifications are being handled by flutter local notification
          // showCallNotifications(message.data);
          showNotificationButton(message);
        } else {
          showNotification(message);
        }
      }
    });
  }


  Future<void> getDeviceToken() async {
    await FirebaseMessaging.instance.getToken().then((fcmToken) {
      if (fcmToken != null) {
        debugPrint('FCM TOKEN: $fcmToken');
        // SharedPrefs().setFCMToken(fcmToken);
      }
    }).catchError((e) {
      debugPrint('Error fetching FCM token: $e');
    });
  }

  Future<void> requestNotificationPermission() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: true,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('user granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('user granted provisional permission');
    } else {
      //upsetting.AppSettings.openNotificationSettings();
      debugPrint('user denied permission');
    }
  }

  /// Display a notification Button wali
  Future<void> showNotificationButton(
    RemoteMessage data,
  ) async {
    debugPrint('showNotification with button');

    // Define action buttons for the notification
    var acceptAction = const AndroidNotificationAction(
      'accepted', // ID of the action
      'Accept', // Title of the action
      showsUserInterface: true,
      titleColor: Colors.green,

    );
    var declineAction = const AndroidNotificationAction(
      'declined',
      'Decline',
      showsUserInterface: true,
      titleColor: Colors.red,
    );

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'default_channel',
      'default_channel Name',
      importance: Importance.high,
      priority: Priority.high,
      category: AndroidNotificationCategory.event,
      icon: "@mipmap/ic_launcher",
      visibility: NotificationVisibility.public,
      actions: [acceptAction, declineAction], // Add actions here
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(),
    );

    print("Notification Details Added");

    print("data.title ${data.data['title']}");
    print("data.body ${data.data['body']}");

    // try{
    await _flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      // "Hello",
      // "Hey sexy",
      data.data['title'], // data.notification?.title,
      data.data['body'], // data.notification?.body,
      notificationDetails,
      // payload: payload,
    );
    // }catch(e){
    //   print("catch: ${e.toString()}");
    // }

    print("Show Notifications will show now");
  }

  /// Display a notification  without Button wali
  Future<void> showNotification(RemoteMessage message) async {
    debugPrint('showNotification without button');
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'default_channel',
      'default_channel',
      importance: Importance.max,
      showBadge: true,
      playSound: true,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id, channel.name.toString(),
      //channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      ticker: 'ticker',
      sound: channel.sound,
      // icon: '@drawable/ic_stat_ic_launcher_foreground'
    );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero, () {
      /// 21 is type of notification received when liking own comment on any post (idk)
      /// making sure notification does not triggers when user likes his own comment

      _flutterLocalNotificationsPlugin.show(
        message.hashCode, // Unique ID for the notification
        message.data['title'],
        message.data['body'],
        notificationDetails,
      );
    });
  }

//method to handle taps in backgroun/terminated
  Future<void> setupInteractMessage(BuildContext context) async {
    debugPrint('setupInteractMessage');

    WidgetsFlutterBinding.ensureInitialized();

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      if (context.mounted) {
        // Navigate to the desired screen
        await Future.delayed(
            const Duration(milliseconds: 0)); // Delay to avoid race condition
        // handleMessage(initialMessage, context);
      }
    }

    // Handle when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (context.mounted) {
        //handleMessage(message, context);
      }
    });
  }

  //IOS FOREGROUND
  Future<void> foregroundMessage() async {
    debugPrint("FOREGROUND INITIALIZED");

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// Handle notification payload for navigation or other actions
  void _handleNotification(Map<String, dynamic>? data) {
    if (data != null && data.containsKey('payload')) {
      final String? payload = data['payload'];
      // Handle navigation or custom actions based on payload
      debugPrint('Notification Payload: $payload');
    }
  }

  /// Handle notification payload for navigation or other actions
  void _onNotificationResponseAction(NotificationResponse response) {
    _handleNotification({'payload': response.payload});
  }

  //Api to handle actions response
  Future<void> handleNotificationAction(BuildContext context,
      NotificationResponse response, RemoteMessage message) async {
    final currentDriverId = await SharedPrefHelper.getInt('driver-id');

    print("DRIVER ID $currentDriverId");
    print("RESPONSE ACTION ${response.actionId}");
    print("ORDER ID ${message.data["orderId"]}");

    final Map<String, dynamic> params = {
      "status": response.actionId,
      "driver_id": currentDriverId,
      "order_id": message.data["orderId"]
    };
    print("Params sent to confirmOrder: $params");

    try {
      final responseData = await ApiService.postApiWithToken(
        endpoint: NetworkConstantsUtil.confirmOrder,
        body: params,
      );

      bool isSuccess = responseData['success'];
      String message = responseData['message'];

      print('isSuccess $isSuccess');
      print('message $message');

      if (isSuccess) {
        final deliveryScreenProvider =
            Provider.of<DeliveryScreenProvider>(context, listen: false);

        Future.delayed(Duration(seconds: 3), () {
          deliveryScreenProvider.fetchAllOrders();
        });
        // await deliveryScreenProvider.fetchAllOrders();

        /*Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DeliveryScreen(initialTabIndex: 1),
          ),
        );*/
        print(message);
      } else {
        print(message);
      }
    } catch (e) {
      print('ErrorMessage::::::::: $message');
      print("Error: $e");
      // showCustomSnackBar(context, e.toString());
    } finally {
      // _isLoading = false;
      // notifyListeners();
    }
  }


  handleCallNotificationResponseForeground(
      BuildContext context, NotificationResponse response, message) {
    print('handleCallNotificationResponseForegroundddddddd Called');
    String? notificationType = message!.data['notificationType'];

    print(' response.actionId ${response.actionId}');
    if (notificationType != null) {
      if (response.actionId == 'accepted') {
        handleNotificationAction(context, response, message);
      } else if (response.actionId == 'declined') {
        handleNotificationAction(context, response, message);
      }
    }
  }
}

// Background notification action handler

// @pragma('vm:entry-point')
// void handleNotificationActionBackground(NotificationResponse response) async {
//   print('Background action handler triggered');
//   print('Action ID: ${response.actionId}');
//   if (response.actionId == 'accepted') {
//     print('Order Accepted - Background');
//     // Add logic, such as an API call or state update.
//   } else if (response.actionId == 'declined') {
//     print('Order Rejected - Background');
//     // Add logic for reject action.
//   }
// }
