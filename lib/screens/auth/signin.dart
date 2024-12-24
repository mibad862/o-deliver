import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:o_deliver/providers/sigin_provider.dart';
import 'package:provider/provider.dart';
import '../../values/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => SignInState();
}

class SignInState extends State<SignIn> {

  @override

  @override
  Widget build(BuildContext context) {
    final signInProvider = Provider.of<SignInProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
            child: Form(
              key: signInProvider.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  appBar(),

                  Text("EMAIL : ${signInProvider.emailController.text}"),
                  Text("PASS ${signInProvider.passwordController.text}"),

                  //Email
                  CustomTextField(
                    controller: signInProvider.emailController,
                    maxLines: 1,
                    // prefixIcon: const Icon(UniconsLine.envelope_alt),
                    hintText: "Enter your mail",
                    validate: (value) {
                      if (value.isEmpty) {
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

                  //Password
                  CustomTextField(
                    controller: signInProvider.passwordController,
                    maxLines: 1,
                    obscureText: signInProvider.passVisible,
                    // prefixIcon: const Icon(UniconsLine.lock_alt),
                    hintText: "Enter your password",
                    suffixIcon: IconButton(
                      color: Colors.grey,
                      icon: Icon(
                        signInProvider.passVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        signInProvider.passwordVisibility();
                      },
                    ),
                    validate: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters long';
                      }

                      return null;
                    },
                  ),

                  //Rember me & Forgot password
                  Row(
                    children: [
                      //CheckBox
                      Checkbox(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        activeColor: const Color(0xfff34147),
                        value: signInProvider.rememberMe,
                        onChanged: (val) {
                          signInProvider.updateRememberMe(val ?? false);
                        },
                      ),
                      const Text("Remember Me"),
                      const Spacer(),

                      //Text button
                      TextButton(
                        onPressed: () {
                          context.push('/forgetPassword');
                        },
                        child: const Text(
                          "Forgot Password",
                          style: TextStyle(
                              color: Color(0xfff34147),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  //Button
                  signInProvider.isLoading
                      ? const Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.appThemeColor,
                            ),
                          ),
                        )
                      : CustomButton(
                          onTap: () {
                            if (signInProvider.formKey.currentState!
                                .validate()) {
                              signInProvider.signIn(context);
                            }
                          },
                          buttonText: "Sign In",
                          sizeWidth: double.infinity,
                          borderRadius: 30,
                          buttonColor: AppColors.appThemeColor,
                        ),
                  const SizedBox(height: 20),

                  const Row(
                    children: [
                      Flexible(child: Divider()),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text("OR")),
                      Flexible(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 20),

                  //Create account text
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(color: Colors.grey.shade600),
                        children: <TextSpan>[
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.push('/signUp');
                              },
                            text: ' Create an account',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xfff34147),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget appBar() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Welcom Text
        Text(
          "Welcome",
          style: TextStyle(
            height: 1.0,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(
              0xfff34147,
            ),
          ),
        ),
        Text(
          "back!",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),

        //Login Details
        Text(
          "Log in to your account to explore personalized features and services tailored just for you",
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 25),
      ],
    );
  }
}
