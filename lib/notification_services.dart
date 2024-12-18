import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final _flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();

  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _flutterLocalNotificationPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) {
      // handleMessage(context, message);
    });
  }

  // void firebaseInit(BuildContext context){
  //   FirebaseMessaging.onMessage.listen((message) {
  //
  //     RemoteNotification? notification = message.notification ;
  //     AndroidNotification? android = message.notification!.android ;
  //
  //     if (kDebugMode) {
  //       print("notifications title:${notification!.title}");
  //       print("notifications body:${notification.body}");
  //       print('count:${android!.count}');
  //       print('data:${message.data.toString()}');
  //     }
  //
  //     if(Platform.isIOS){
  //       // forgroundMessage();
  //     }
  //
  //     if(Platform.isAndroid){
  //       initLocalNotifications(context, message);
  //       showNotification(message);
  //     }
  //   });
  // }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      // print(message.data['title']);
      // print(message.data['body']);
      // // print(message.data['body']);
      // print(message.data['imageUrl']);

      print("HELLO");
      // print(message.data);
      // print(message.data['distance']);
      print(message.data['body']);
      print(message.data['title']);
      print(message.data['orderId']);

      // print(message.notification!.title);
      // print(message.notification!.body);



      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotification(message);
      }

      showNotification(message);
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      "1",
      "High Important Notification",
      importance: Importance.max,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      actions: [
        const AndroidNotificationAction(
          'accept', // Action ID
          'Accept', // Button Label
          showsUserInterface: true, // Open app on button press
        ),
        const AndroidNotificationAction(
          'decline', // Action ID
          'Decline', // Button Label
          showsUserInterface: true,
        ),
      ],
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: "Your Channel Description",
      importance: Importance.high,
      priority: Priority.high,
      ticker: "Ticker",
      // icon: "@mipmap/ic_launcher",
    );

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationPlugin.show(
        0,
        message.data['title'].toString(),
        message.data['body'].toString(),

        // message.notification!.title.toString(),
        // message.notification!.body.toString(),
        notificationDetails,
      );
    });
  }

   Future<void> getNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      sound: true,
      provisional: true,
      criticalAlert: true,
      carPlay: true,
      badge: true,
      announcement: true,
      alert: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User Granted Permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User Granted Provisional Permission");
    } else {
      AppSettings.openAppSettings(type: AppSettingsType.notification);
      print("User Denied Permission");
    }
  }

  Future<String?> getDeviceToken() async {
    final deviceToken = messaging.getToken();
    return deviceToken;
  }

  void isTokenRefresh() {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      print("Refresh");
    });
  }
}

// import 'dart:io';
// import 'dart:math';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class NotificationServices {
//   //initialising firebase message plugin
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//
//   //initialising firebase message plugin
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   //function to initialise flutter local notification plugin to show notifications for android when app is active
//   void initLocalNotifications(
//       BuildContext context, RemoteMessage message) async {
//     var androidInitializationSettings =
//         const AndroidInitializationSettings('@mipmap/ic_launcher');
//     var iosInitializationSettings = const DarwinInitializationSettings();
//
//     var initializationSetting = InitializationSettings(
//         android: androidInitializationSettings, iOS: iosInitializationSettings);
//
//     await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
//         onDidReceiveNotificationResponse: (payload) {
//       // handle interaction when app is active for android
//       handleMessage(context, message);
//     });
//   }
//
//   void firebaseInit(BuildContext context) {
//     FirebaseMessaging.onMessage.listen((message) {
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification!.android;
//
//       if (kDebugMode) {
//         print("notifications title:${notification!.title}");
//         print("notifications body:${notification.body}");
//         print('count:${android!.count}');
//         print('data:${message.data.toString()}');
//       }
//
//       if (Platform.isIOS) {
//         forgroundMessage();
//       }
//
//       if (Platform.isAndroid) {
//         initLocalNotifications(context, message);
//         showNotification(message);
//       }
//     });
//   }
//
//   void requestNotificationPermission() async {
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: true,
//       badge: true,
//       carPlay: true,
//       criticalAlert: true,
//       provisional: true,
//       sound: true,
//     );
//
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       if (kDebugMode) {
//         print('user granted permission');
//       }
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       if (kDebugMode) {
//         print('user granted provisional permission');
//       }
//     } else {
//       //appsetting.AppSettings.openNotificationSettings();
//       if (kDebugMode) {
//         print('user denied permission');
//       }
//     }
//   }
//
//   // function to show visible notification when app is active
//   Future<void> showNotification(RemoteMessage message) async {
//     AndroidNotificationChannel channel = AndroidNotificationChannel(
//         message.notification!.android!.channelId.toString(),
//         message.notification!.android!.channelId.toString(),
//         importance: Importance.max,
//         showBadge: true,
//         playSound: true,
//         sound: const RawResourceAndroidNotificationSound('jetsons_doorbell'));
//
//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//             channel.id.toString(), channel.name.toString(),
//             channelDescription: 'your channel description',
//             importance: Importance.high,
//             priority: Priority.high,
//             playSound: true,
//             ticker: 'ticker',
//             sound: channel.sound
//             //     sound: RawResourceAndroidNotificationSound('jetsons_doorbell')
//             //  icon: largeIconPath
//             );
//
//     const DarwinNotificationDetails darwinNotificationDetails =
//         DarwinNotificationDetails(
//             presentAlert: true, presentBadge: true, presentSound: true);
//
//     NotificationDetails notificationDetails = NotificationDetails(
//         android: androidNotificationDetails, iOS: darwinNotificationDetails);
//
//     Future.delayed(Duration.zero, () {
//       _flutterLocalNotificationsPlugin.show(
//         message.hashCode, // Unique ID for the notification
//         message.notification!.title.toString(),
//         message.notification!.body.toString(),
//         notificationDetails,
//       );
//     });
//   }
//
//   //function to get device token on which we will send the notifications
//   Future<String> getDeviceToken() async {
//     String? token = await messaging.getToken();
//     return token!;
//   }
//
//   void isTokenRefresh() async {
//     messaging.onTokenRefresh.listen((event) {
//       event.toString();
//       if (kDebugMode) {
//         print('refresh');
//       }
//     });
//   }
//
//   //handle tap on notification when app is in background or terminated
//   Future<void> setupInteractMessage(BuildContext context) async {
//     // when app is terminated
//     RemoteMessage? initialMessage =
//         await FirebaseMessaging.instance.getInitialMessage();
//
//     if (initialMessage != null) {
//       handleMessage(context, initialMessage);
//     }
//
//     //when app ins background
//     FirebaseMessaging.onMessageOpenedApp.listen((event) {
//       handleMessage(context, event);
//     });
//   }
//
//   void handleMessage(BuildContext context, RemoteMessage message) {
//     if (message.data['type'] == 'msj') {
//       // Navigator.push(
//       //   context,
//       //   MaterialPageRoute(
//       //     builder: (context) => MessageScreen(
//       //       id: message.data['id'],
//       //     ),
//       //   ),
//       // );
//     }
//   }
//
//   Future forgroundMessage() async {
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }
// }
