import 'package:flutter/material.dart';
import 'package:o_deliver/providers/resetpassword_provider.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key, this.token, this.email});

  final String? token;
  final String? email;

  @override
  Widget build(BuildContext context) {
    debugPrint(token);
    debugPrint(email);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Consumer<ResetPasswordProvider>(
              builder: (context, provider, child) {
                return Form(
                  key: provider.formKey, // Assign formKey here
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Reset Password $email",
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xfff34147),
                        ),
                      ),

                      Text(
                        "Token $token",
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xfff34147),
                        ),
                      ),

                      const SizedBox(height: 20),

                      CustomTextField(
                        controller: provider.emailController,
                        hintText: "Email Address",
                        prefixIcon: const Icon(Icons.mail),
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      // Password Field
                      CustomTextField(
                        controller: provider.passwordController,
                        hintText: "Password",
                        obscureText: provider.passwordVisible,
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(provider.passwordVisible
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: provider.togglePasswordVisibility,
                        ),
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters long';
                          }
                          // if (!value.contains(RegExp(r'[A-Z]'))) {
                          //   return 'Password must contain at least one uppercase letter';
                          // }
                          // if (!value
                          //     .contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                          //   return 'Password must contain at least one special character';
                          // }
                          return null;
                        },
                        maxLines: 1,
                      ),

                      const SizedBox(height: 20),

                      // Confirm Password Field
                      CustomTextField(
                        controller: provider.confirmPasswordController,
                        hintText: "Confirm Password",
                        obscureText: provider.confirmPassVisible,
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(provider.confirmPassVisible
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: provider.toggleConfirmPasswordVisibility,
                        ),
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 8) {
                            return 'Confirm Password must be at least 8 characters long';
                          }
                          // if (!value.contains(RegExp(r'[A-Z]'))) {
                          //   return 'Confirm Password must contain at least one uppercase letter';
                          // }
                          if (value != provider.passwordController.text) {
                            return 'Confirm Password do not match';
                          }
                          // if (!value
                          //     .contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                          //   return 'Password must contain at least one special character';
                          // }
                          return null;
                        },
                        maxLines: 1,
                      ),

                      const SizedBox(height: 20),

                      // Sign Up Button
                      provider.isLoading ? const Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator()) : CustomButton(
                        onTap: () {
                          if (provider.formKey.currentState!.validate()) {
                            provider.resetPassword(
                              context,
                              token ?? "",
                            );
                          }
                        },
                        buttonText: "Reset Password",
                        sizeWidth: double.infinity,
                        borderRadius: 30,
                        buttonColor: const Color(0xfff34147),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
