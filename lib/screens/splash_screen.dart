import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';

import '../shared_pref_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StreamSubscription<String?>? linkSubscription;

  @override
  void initState() {
    super.initState();
    _initUniLinks();
  }


  Future<void> _checkLoginStatus() async {
    // Retrieve the login status from SharedPreferences
    final isLoggedIn = await SharedPrefHelper.getString("access-token");

    Timer(const Duration(seconds: 2), () {
      if (isLoggedIn != null) {
        context.go('/mainScreen'); // Navigate to the home screen if logged in
      } else {
        context.go('/signIn'); // Navigate to the login screen otherwise
      }
    });
  }


  Future<void> _initUniLinks() async {
    linkSubscription = linkStream.listen((String? link) {
      if (link != null) {
        debugPrint("Incoming link from stream: $link");
        _handleDeepLink(link);
      }
    }, onError: (err) {
      print('Error listening for links: $err');
    });

    // Check the initial link when the app starts
    try {
      final initialLink = await getInitialLink();
      if (initialLink != null) {
        debugPrint("Initial link: $initialLink");
        log("INITIAL $initialLink");
        _handleDeepLink(initialLink);
      }
      else {
        _checkLoginStatus();
        // _navigateToLogin();
      }
    } catch (e) {
      debugPrint("Failed to get link: $e");
      _checkLoginStatus();
      // _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    Timer(const Duration(seconds: 2), () {
      context.go('/signIn'); // Change this to your actual login route
    });
  }

  void _handleDeepLink(String link) {
    debugPrint("Received link: $link");
    final uri = Uri.parse(link);

    if (uri.pathSegments.length >= 5 &&
        uri.pathSegments[0] == 'build' &&
        uri.pathSegments[1] == 'pages' &&
        uri.pathSegments[2] == 'authentication' &&
        uri.pathSegments[3] == 'reset-password-v1') {
      final token = uri.queryParameters['token'];
      final email = uri.queryParameters['email'];

      debugPrint("Token: $token");
      debugPrint("Email: $email");

      // context.go('/pages/authentication/reset-password-v1?token=$token&email=$email');

      Timer(const Duration(seconds: 2), () {
        context.go('/pages/authentication/reset-password-v1/', extra: {email, token});
        // context.go('/signIn');
      });
    } else {
      print('Invalid deep link');
      _navigateToLogin();
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   // initUniLinks();
  //   // print("STEP 1");
  //   // _navigateAfterDelay();
  //   // print("STEP 2");
  // }

  // Future<void> initUniLinks() async {
  //   try {
  //     final initialLink = await getInitialLink();
  //     print("STEP 3: INITIAL LINK $initialLink");
  //
  //     if (initialLink != null) {
  //       print("STEP 4: LINK DETECTED");
  //       _handleDeepLink(initialLink);
  //     } else {
  //       print("STEP 4: NO INITIAL LINK DETECTED");
  //     }
  //
  //     linkSubscription = linkStream.listen((String? link) {
  //       print("STEP 5: LINK RECEIVED FROM STREAM $link");
  //       if (link != null) {
  //         _handleDeepLink(link);
  //       }
  //     }, onError: (err) {
  //       print('Error listening for links: $err');
  //     });
  //   } catch (e) {
  //     print('Failed to initialize uni links: $e');
  //   }
  // }
  //
  //
  // void _handleDeepLink(String link) {
  //   final uri = Uri.parse(link);
  //   final token = uri.queryParameters['token'];
  //   final email = uri.queryParameters['email'];
  //
  //   if (token != null && email != null) {
  //     context.goNamed('reset-password', queryParameters: {
  //       'token': token,
  //       'email': email,
  //     });
  //   } else {
  //     print('Invalid deep link');
  //   }
  // }



  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("SPLASH SCREEN"),
    );
  }

  @override
  void dispose() {
    linkSubscription?.cancel();
    super.dispose();
  }
}

