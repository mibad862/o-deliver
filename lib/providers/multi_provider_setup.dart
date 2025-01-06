import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'deliveryScreen_provider.dart';
import 'forgetpassword_provider.dart';
import 'resetpassword_provider.dart';
import 'settings_provider.dart';
import 'sigin_provider.dart';
import 'signup_provider.dart';
import 'update_order_provider.dart';
import 'verifyOtp_provider.dart';

class MultiProviderClass {
  static List<SingleChildWidget> get providersList => [
    ChangeNotifierProvider(create: (_) => SignInProvider()),
    ChangeNotifierProvider(create: (_) => SignUpProvider()),
    ChangeNotifierProvider(create: (_) => VerifyOtpProvider()),
    ChangeNotifierProvider(create: (_) => ForgetPasswordProvider()),
    ChangeNotifierProvider(create: (_) => ResetPasswordProvider()),
    ChangeNotifierProvider(create: (_) => DeliveryScreenProvider()),
    ChangeNotifierProvider(create: (_) => UpdateOrderProvider()),
    ChangeNotifierProvider(create: (_) => SettingsProvider()),

  ];
}
