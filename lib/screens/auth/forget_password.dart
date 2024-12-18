import 'package:flutter/material.dart';
import 'package:o_deliver/providers/forgetpassword_provider.dart';
import 'package:provider/provider.dart';

import '../../values/app_colors.dart';
import '../../widgets/custom_button.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.symmetric(vertical: size.height * .02, horizontal: 15),
          child: Consumer<ForgetPasswordProvider>(
            builder: (context, provider, child) {
              return Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.wallet),
                          SizedBox(width: size.width * .02),
                          const Text(
                            "Forgot Password",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          )
                        ],
                      ),
                      SizedBox(height: size.height * .01),
                      const Text(
                        "Dont't worry! we got you covered.Please enter select password recovery method below",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * .05),
                  TextFormField(
                    controller: provider.emailController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      hintText: "Email Address",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const Spacer(),

                  //button
                  provider.isLoading ? const Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator()) : CustomButton(
                    onTap: () {
                      provider.forgetPass(context);
                    },
                    buttonText: "Continue",
                    sizeWidth: double.infinity,
                    borderRadius: 30,
                    buttonColor: AppColors.appThemeColor,
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
