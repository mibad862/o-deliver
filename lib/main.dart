import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:o_deliver/providers/multi_provider_setup.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'screens/auth/signin.dart';
import 'screens/auth/signup.dart';
import 'screens/auth/verify_otp.dart';
import 'screens/auth/forget_password.dart';
import 'screens/auth/reset_password.dart';
import 'screens/main_screen.dart';
import 'screens/delivery/delivery_screen.dart';
import 'screens/delivery/delivery_detail_screen.dart';
import 'screens/delivery/delivery_complete_screen.dart';
import 'screens/no_connection_screen.dart';
import 'screens/pickup/pickup_detail_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/update_order_screen.dart';
import 'widgets/notificaiton_service_manager.dart';

@pragma("vm:entry-point")
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check connectivity
  final connectivityResult = await Connectivity().checkConnectivity();

  // Initialize Firebase if connected
  if (connectivityResult.contains(ConnectivityResult.none)) {
    print("No Internet Connection Available");
  } else {
    print('Internet is available, initializing Firebase...');
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await requestPermissions();
  }

  runApp(MyApp(
    initialRoute: connectivityResult.contains(ConnectivityResult.none)
        ? '/noConnectionScreen'
        : '/splash',
  ));
}

Future<void> requestPermissions() async {
  var status = await Permission.locationWhenInUse.status;
  if (!status.isGranted) {
    var status = await Permission.locationWhenInUse.request();
    if (status.isGranted) {
      var status = await Permission.locationAlways.request();
      if (status.isGranted) {
        //Do some stuff
      } else {
        //Do another stuff
      }
    } else {
      //The user deny the permission
    }
    if (status.isPermanentlyDenied) {
      //When the user previously rejected the permission and select never ask again
      //Open the screen of settings
      bool res = await openAppSettings();
    }
  } else {
    //In use is available, check the always in use
    var status = await Permission.locationAlways.status;
    if (!status.isGranted) {
      var status = await Permission.locationAlways.request();
      if (status.isGranted) {
        //Do some stuff
      } else {
        //Do another stuff
      }
    } else {
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

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({required this.initialRoute, super.key});

  @override
  Widget build(BuildContext context) {
    print(initialRoute);
    return MultiProvider(
      providers: MultiProviderClass.providersList,
      child: MaterialApp.router(
        builder: EasyLoading.init(),
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: GoRouter(
          initialLocation: initialRoute,
          routes: <RouteBase>[
            GoRoute(
              path: '/splash',
              builder: (context, state) => const SplashScreen(),
            ),
            GoRoute(
              path: '/signIn',
              builder: (context, state) => const SignIn(),
            ),
            GoRoute(
              path: '/signUp',
              builder: (context, state) => const SignUp(),
            ),
            GoRoute(
              path: '/verifyOtp/:emailText/:otp',
              builder: (context, state) {
                final emailText = state.pathParameters["emailText"] ?? "";
                final otp = state.pathParameters["otp"] ?? "";
                return VerifyOtp(emailText: emailText, otp: otp);
              },
            ),
            GoRoute(
              path: '/forgetPassword',
              builder: (context, state) => const ForgetPassword(),
            ),
            GoRoute(
              path: '/pages/authentication/reset-password-v1',
              builder: (context, state) {
                final token = state.uri.queryParameters['token'];
                final email = state.uri.queryParameters['email'];
                return ResetPassword(email: email, token: token);
              },
            ),
            GoRoute(
              path: '/mainScreen',
              builder: (context, state) => const MainScreen(),
            ),
            GoRoute(
              path: '/deliveryScreen',
              builder: (context, state) => const DeliveryScreen(),
            ),
            GoRoute(
              path: '/deliveryDetailScreen',
              builder: (context, state) => const DeliveryDetailScreen(),
            ),
            GoRoute(
              path: '/updateOrderScreen/:currentOrderId',
              builder: (context, state) {
                final currentOrderId =
                    state.pathParameters["currentOrderId"] ?? "";
                return UpdateOrderScreen(currentOrderId: currentOrderId);
              },
            ),
            GoRoute(
              path: '/deliveryCompleteScreen',
              builder: (context, state) => const DeliveryCompleteScreen(),
            ),
            GoRoute(
              path: '/pickupDetailScreen',
              builder: (context, state) => const PickUpDetailScreen(),
            ),
            GoRoute(
              path: '/noConnectionScreen',
              builder: (context, state) => const ConnectivityHandler(),
            ),
          ],
        ),
      ),
    );
  }
}
