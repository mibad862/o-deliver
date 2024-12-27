import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'deliveryScreen_provider.dart';
import 'forgetpassword_provider.dart';
import 'resetpassword_provider.dart';
import 'sigin_provider.dart';
import 'signup_provider.dart';
import 'update_order_provider.dart';
import 'verifyOtp_provider.dart';


class MultiProviderSetup extends StatelessWidget {
  final Widget child;

  const MultiProviderSetup({super.key, required this.child});

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
        ChangeNotifierProvider(create: (_) => UpdateOrderProvider()),
      ],
      child: child,
    );
  }
}
