import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:o_deliver/providers/sigin_provider.dart';
import 'package:o_deliver/screens/auth/forget_password.dart';
import 'package:o_deliver/screens/auth/reset_password.dart';
import 'package:o_deliver/screens/auth/signin.dart';
import 'package:o_deliver/screens/auth/signup.dart';
import 'package:o_deliver/screens/auth/verify_otp.dart';
import 'package:o_deliver/screens/delivery/delivery_complete_screen.dart';
import 'package:o_deliver/screens/delivery/delivery_detail_screen.dart';
import 'package:o_deliver/screens/delivery/delivery_screen.dart';
import 'package:o_deliver/screens/main_screen.dart';
import 'package:o_deliver/screens/pickup/pickup_detail_screen.dart';
import 'package:o_deliver/screens/splash_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'background_service.dart';
import 'firebase_options.dart';
import 'notification_services.dart';
import 'providers/deliveryScreen_provider.dart';
import 'providers/forgetpassword_provider.dart';
import 'providers/resetpassword_provider.dart';
import 'providers/signup_provider.dart';
import 'providers/verifyOtp_provider.dart';


@pragma("vm:entry-point")
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
 // NotificationServices().showNotification(message);
 //  print(message.notification!.title.toString());

  print("Handling a background message: ${message.messageId}");

  // // Ensure necessary setups
  // await setupNotificationChannel(); // Define this to create notification channels
  // await showNotification(message); // Function to display the notification

}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // await Permission.notification.isDenied.then(
  //         (value){
  //       if(value){
  //         Permission.notification.request();
  //       }
  //     }
  // );



  await requestPermissions();
  //  await initializeService();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

Future<void> requestPermissions() async {
  var status = await Permission.locationWhenInUse.status;
  if(!status.isGranted){
    var status = await Permission.locationWhenInUse.request();
    if(status.isGranted){
      var status = await Permission.locationAlways.request();
      if(status.isGranted){
        //Do some stuff
      }else{
        //Do another stuff
      }
    }else{
      //The user deny the permission
    }
    if(status.isPermanentlyDenied){
      //When the user previously rejected the permission and select never ask again
      //Open the screen of settings
      bool res = await openAppSettings();
    }
  }else{
    //In use is available, check the always in use
    var status = await Permission.locationAlways.status;
    if(!status.isGranted){
      var status = await Permission.locationAlways.request();
      if(status.isGranted){
        //Do some stuff
      }else{
        //Do another stuff
      }
    }else{
      //previously available, do some stuff or nothing
    }
  }
  // If permission is permanently denied, prompt user to go to settings
  if (status.isPermanentlyDenied) {
    bool res = await openAppSettings();
    if (res) {
      print('User was redirected to settings');
    } else {
      print('User didn\'t open settings');
    }
  }
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // requestLocationPermission();
  }
  //
  // bool locationPermissionGranted = false;
  // bool notificationPermissionGranted = false;
  //
  // Future<void> requestLocationPermission() async {
  //   PermissionStatus status = await Permission.location.request();
  //
  //   if (status.isGranted) {
  //     setState(() {
  //       locationPermissionGranted = true;
  //     });
  //     print("Location permission granted");
  //
  //     await initializeService();
  //
  //     // After location permission is granted, request notification permission
  //     requestNotificationPermission();
  //   } else {
  //     setState(() {
  //       locationPermissionGranted = false;
  //     });
  //     print("Location permission denied");
  //   }
  // }
  //
  // // Function to request notification permission
  // Future<void> requestNotificationPermission() async {
  //   NotificationServices notificationServices = NotificationServices();
  //   await notificationServices.getNotificationPermission();
  //   setState(() {
  //     notificationPermissionGranted = true;
  //   });
  //   print("Notification permission requested");
  // }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignInProvider()),
        ChangeNotifierProvider(create: (_) => SignUpProvider()),
        ChangeNotifierProvider(create: (_) => VerifyOtpProvider()),
        ChangeNotifierProvider(create: (_) => ForgetPasswordProvider()),
        ChangeNotifierProvider(create: (_) => ResetPasswordProvider()),
        ChangeNotifierProvider(create: (_) => DeliveryScreenProvider()),
      ],
      child: MaterialApp.router(
        builder: EasyLoading.init(),
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: router,
      ),
    );
  }
}

final GoRouter router = GoRouter(
  initialLocation: '/splash',
  routes: <RouteBase>[
    GoRoute(
      path: '/splash',
      builder: (context, state) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: '/signIn',
      builder: (context, state) {
        return const SignIn();
      },
    ),
    GoRoute(
      path: '/signUp',
      builder: (context, state) {
        return const SignUp();
      },
    ),
    GoRoute(
      path: '/verifyOtp/:emailText',
      builder: (context, state) {
        final String emailText = state.pathParameters["emailText"] ?? "";
        return VerifyOtp(emailText: emailText);
      },
    ),
    GoRoute(
      path: '/forgetPassword',
      builder: (context, state) {
        return const ForgetPassword();
      },
    ),
    GoRoute(
      path: '/pages/authentication/reset-password-v1',
      builder: (context, state) {
        final String? token = state.uri.queryParameters['token'];
        final String? email = state.uri.queryParameters['email'];
        return ResetPassword(email: email, token: token);
      },
    ),
    GoRoute(
      path: '/mainScreen',
      builder: (context, state) {
        return const MainScreen();
      },
    ),
    GoRoute(
      path: '/deliveryScreen',
      builder: (context, state) {
        return const DeliveryScreen();
      },
    ),
    GoRoute(
      path: '/deliveryDetailScreen',
      builder: (context, state) {
        return const DeliveryDetailScreen();
      },
    ),
    GoRoute(
      path: '/deliveryCompleteScreen',
      builder: (context, state) {
        return const DeliveryCompleteScreen();
      },
    ),
    GoRoute(
      path: '/pickupDetailScreen',
      builder: (context, state) {
        return const PickUpDetailScreen();
      },
    ),
  ],
);
