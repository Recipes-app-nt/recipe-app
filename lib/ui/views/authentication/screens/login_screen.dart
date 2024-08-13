import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:recipe_app/ui/views/authentication/screens/register_screen.dart';
import 'package:recipe_app/ui/views/authentication/widgets/social_button.dart';
import 'package:recipe_app/ui/views/recipe/widgets/custom_textfield.dart';
import 'package:recipe_app/ui/widgets/custom_button.dart';
import 'package:recipe_app/ui/widgets/custom_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(40),
                const Text(
                  'Hello,',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Welcome Back!',
                  style: TextStyle(fontSize: 24),
                ),
                const Gap(40),
                CustomTextFormField(
                  controller: emailController,
                  labelText: "Email",
                  hintText: "Enter email",
                ),
                const Gap(16),
                CustomTextFormField(
                  controller: passwordController,
                  labelText: "Password",
                  hintText: "Enter password",
                ),
                const Gap(8),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.orange,
                  ),
                  child: const Text('Forgot Password?'),
                ),
                const Gap(24),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    title: "Sign in",
                    onPressed: () {},
                  ),
                ),
                const Gap(24),
                Row(
                  children: [
                    const Expanded(
                        child: Divider(
                      color: Color(0xffD9D9D9),
                    )),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: CustomText(
                          text: "Or Sign in With",
                          color: const Color(0xffD9D9D9),
                        )),
                    const Expanded(
                        child: Divider(
                      color: Color(0xffD9D9D9),
                    )),
                  ],
                ),
                const Gap(24),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialButton(assetName: 'assets/images/google.png'),
                    Gap(16),
                    SocialButton(assetName: 'assets/images/facebook.png'),
                  ],
                ),
                const Gap(40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text('Sign up',
                          style: TextStyle(color: Colors.orange)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
