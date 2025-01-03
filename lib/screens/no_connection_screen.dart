import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:o_deliver/shared_pref_helper.dart';

class NoConnectionScreen extends StatelessWidget {
  const NoConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("No Connection Available"),
      ),
    );
  }
}

class ConnectivityHandler extends StatefulWidget {
  const ConnectivityHandler({super.key});

  @override
  ConnectivityHandlerState createState() => ConnectivityHandlerState();
}

class ConnectivityHandlerState extends State<ConnectivityHandler> {
  late StreamSubscription internetConnectionStreamSubscription;
  bool isConnectedToInternet = false;

  Future<void> _checkAccessToken() async {
    String? accessToken = await SharedPrefHelper.getString('access-token');

    if (accessToken != null && accessToken.isNotEmpty) {
      // If access token exists, navigate to the Home screen
      context.go('/mainScreen');
    } else {
      // If no access token, navigate to the Login screen
      context.go('/signIn');
    }
  }

  @override
  void initState() {
    super.initState();

    internetConnectionStreamSubscription = InternetConnection().onStatusChange.listen((status) {
      final isConnected = status == InternetStatus.connected;
      setState(() {
        isConnectedToInternet = isConnected;
      });
    });
  }

  @override
  void dispose() {
    internetConnectionStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isConnectedToInternet) {
      // Show the "No Connection" screen if no internet connection is available
      return const NoConnectionScreen();
    } else {
      // Check for the access token when there is internet connectivity
      _checkAccessToken();
      return const Center(child: CircularProgressIndicator());
    }
  }
}
