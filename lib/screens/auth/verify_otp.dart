import 'package:flutter/material.dart';
import 'package:o_deliver/providers/verifyOtp_provider.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_button.dart';

class VerifyOtp extends StatefulWidget {
  const VerifyOtp({
    super.key,
    required this.emailText,
  });

  final String emailText;

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  final defaultPinTheme = PinTheme(
    width: 60,
    height: 60,
    textStyle: const TextStyle(
      fontSize: 30,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.grey),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final otpProvider = Provider.of<VerifyOtpProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    appBar(),
                    Pinput(
                      obscureText: true,
                      length: 6,
                      controller: otpProvider.otpController,
                      defaultPinTheme: defaultPinTheme,
                      onChanged: (value) {
                        // Code to execute when there is a change in the entered values
                      },
                      errorPinTheme: defaultPinTheme.copyBorderWith(
                        border: Border.all(color: const Color(0xfff34147)),
                      ),
                    ),
                    const Spacer(),
                    otpProvider.isLoading
                        ? const Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator())
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: CustomButton(
                              onTap: () {
                                otpProvider.verifyOTP(
                                  widget.emailText,
                                  context,
                                );
                              },
                              buttonText: "Continue",
                              sizeWidth: double.infinity,
                              borderRadius: 30,
                              buttonColor: const Color(0xfff34147),
                            ),
                          ),
                    SizedBox(height: 20),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //App Bar
  Widget appBar() {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.deblur_outlined),
            ),
            const Text(
              "OTP Verification",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            )
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          "Enter otp number we've send to",
          style: TextStyle(color: Colors.grey),
        ),
        Text(
          widget.emailText,
          style: TextStyle(color: Color(0xfff34147)),
        ),
        const SizedBox(height: 25),
      ],
    );
  }

}
