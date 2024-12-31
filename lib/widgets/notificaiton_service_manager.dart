import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class NotificationServiceManager {
  // Singleton instance
  static final NotificationServiceManager _instance =
  NotificationServiceManager._internal();

  factory NotificationServiceManager() => _instance;

  NotificationServiceManager._internal();

  // FlutterLocalNotificationsPlugin instance
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Request notification permissions
    await _requestPermissions();

    // Create notification channel for Android
    await _createNotificationChannel();

    // Android initialization
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization
    const DarwinInitializationSettings iosInitializationSettings =
    DarwinInitializationSettings();

    // Initialization settings for both platforms
    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    // Initialize local notifications
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationResponseAction,
    );

    // Firebase Messaging setup for foreground and background
    FirebaseMessaging.onMessage.listen(_onMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // Handle terminated state notification
    final RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleNotification(initialMessage.data);
    }
  }

  /// Request notification permissions for Android and iOS
  Future<void> _requestPermissions() async {
    // Request permissions for Android 13+
    if (await Permission.notification.isDenied ||
        await Permission.notification.isRestricted) {
      final status = await Permission.notification.request();
      if (status.isGranted) {
        debugPrint("Android notification permissions granted.");
      } else {
        debugPrint("Android notification permissions denied.");
      }
    }

    // Request permissions for iOS
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    final NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    switch (settings.authorizationStatus) {
      case AuthorizationStatus.authorized:
        debugPrint('iOS notification permissions granted.');
        break;
      case AuthorizationStatus.provisional:
        debugPrint('iOS provisional notification permissions granted.');
        break;
      case AuthorizationStatus.denied:
        debugPrint('iOS notification permissions denied.');
        break;
      default:
        debugPrint('iOS notification permissions status unknown.');
    }
  }

  /// Create a notification channel for Android devices
  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'default_channel', // The id of the channel.
      'channel_name', // The name of the channel.
      description: 'This is the description of the channel',
      importance: Importance.max, // Set the level of importance
      showBadge: true,
      playSound: true
    );

    // Create the channel on Android devices
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Handle notifications received in the foreground
  Future<void> _onMessage(RemoteMessage message) async {
    if (message.notification != null) {
      showNotification(
        title: message.notification?.title,
        body: message.notification?.body,
        payload: message.data['payload'],
      );
    }
  }

  /// Handle notifications when opened from the background
  void _onMessageOpenedApp(RemoteMessage message) {
    _handleNotification(message.data);
  }

  /// Handle notifications when opened in the terminated state
  void _onNotificationResponseAction(NotificationResponse response) {
    _handleNotification({'payload': response.payload});
  }

  /// Display a notification using `flutter_local_notifications`
  Future<void> showNotification({
    required String? title,
    required String? body,
    String? payload,
  }) async {
    // Define action buttons for the notification
    const AndroidNotificationAction acceptAction = AndroidNotificationAction(
      'accept', // Action ID
      'Accept', // Button text
    );

    const AndroidNotificationAction declineAction = AndroidNotificationAction(
      'decline', // Action ID
      'Decline', // Button text
    );

    AndroidNotificationDetails androidDetails = const AndroidNotificationDetails(
      'channel_id',
      // This should match the channel ID defined in _createNotificationChannel
      'Channel Name',
      importance: Importance.high,
      priority: Priority.high,
      actions: [acceptAction, declineAction], // Add actions here
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(),
    );

    await _flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      notificationDetails,
      payload: payload,
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

  /// Handle notification action button responses (foreground, background, terminated)
  Future<void> _onNotificationResponse(NotificationResponse response) async {
    if (response.actionId == 'accept') {
      // Handle accept action
      debugPrint('Accepted notification action: ${response.payload}');
      // Navigate or perform action on "Accept"
    } else if (response.actionId == 'decline') {
      // Handle decline action
      debugPrint('Declined notification action: ${response.payload}');
      // Navigate or perform action on "Decline"
    }
  }
}




// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:flutter/material.dart';
//
//
// class NotificationServiceManager {
//   static final NotificationServiceManager _instance = NotificationServiceManager._internal();
//
//   factory NotificationServiceManager() => _instance;
//
//   NotificationServiceManager._internal();
//
//   Future<void> initializeNotifications() async {
//     await AwesomeNotifications().initialize(
//       null, // Default icon for notifications (can be a resource path like 'resource://drawable/res_app_icon')
//       [
//         NotificationChannel(
//           channelKey: 'basic_channel',
//           channelName: 'Basic Notifications',
//           channelDescription: 'Notification channel for basic notifications',
//           defaultColor: const Color(0xFF9D50DD),
//           ledColor: Colors.white,
//           importance: NotificationImportance.High,
//           channelShowBadge: true,
//         ),
//       ],
//       debug: true,
//     );
//
//     // Request notification permissions
//     if (!await AwesomeNotifications().isNotificationAllowed()) {
//       await AwesomeNotifications().requestPermissionToSendNotifications();
//     }
//
//     // Listen to notification actions
//     listenToNotificationActions();
//   }
//
//   void listenToNotificationActions() {
//     AwesomeNotifications().setListeners(
//       onActionReceivedMethod: (ReceivedAction receivedAction) async {
//         print('Notification tapped: ${receivedAction.toMap()}');
//         // Handle notification action (e.g., navigate to a specific screen)
//       },
//       onNotificationCreatedMethod: (ReceivedNotification receivedNotification) async {
//         print('Notification created: ${receivedNotification.toMap()}');
//       },
//       onDismissActionReceivedMethod: (ReceivedAction receivedAction) async {
//         print('Notification dismissed: ${receivedAction.toMap()}');
//       },
//       onNotificationDisplayedMethod: (ReceivedNotification receivedNotification) async {
//         print('Notification displayed: ${receivedNotification.toMap()}');
//       },
//     );
//   }
//
//   Future<void> showNotification({
//     required int id,
//     required String title,
//     required String body,
//     String channelKey = 'basic_channel',
//     String? payload,
//   }) async {
//     await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: id,
//         channelKey: channelKey,
//         title: title,
//         body: body,
//         payload: {'payload': payload ?? ''},
//       ),
//     );
//   }
//
//   Future<void> handleNotificationInTerminatedState() async {
//     AwesomeNotifications().getInitialNotificationAction().then((notification) {
//       if (notification != null) {
//         print('App launched via notification: ${notification.toMap()}');
//         // Add logic to handle the notification
//       }
//     });
//   }
//
//   Future<void> cancelNotification(int id) async {
//     await AwesomeNotifications().cancel(id);
//   }
//
//   Future<void> cancelAllNotifications() async {
//     await AwesomeNotifications().cancelAll();
//   }
// }


