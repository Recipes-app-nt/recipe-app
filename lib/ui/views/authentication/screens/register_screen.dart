import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:recipe_app/ui/views/authentication/widgets/social_button.dart';
import 'package:recipe_app/ui/widgets/custom_textfield.dart';
import 'package:recipe_app/ui/widgets/custom_button.dart';
import 'package:recipe_app/ui/widgets/custom_text.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmController = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(        
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create an account',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const Gap(8),
                const Text(
                  "Let's help you set up your account,\nit won't take long.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const Gap(20),
                _buildInputField('Name', 'Enter Name', nameController),
                _buildInputField('Email', 'Enter Email', emailController),
                _buildInputField(
                  'Password',
                  'Enter Password',
                  passwordController,
                  isPassword: true,
                ),
                _buildInputField(
                  'Confirm Password',
                  'Retype Password',
                  confirmController,
                  isPassword: true,
                ),
                Row(
                  children: [
                    Checkbox(
                      side: const BorderSide(color: Colors.orange, width: 2),
                      value: false,
                      onChanged: (value) {},
                      activeColor: Colors.orange,
                    ),
                    const Text(
                      'Accept terms & Condition',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ],
                ),
                const Gap(20),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(title: "Sign Up", onPressed: () {}),
                ),
                const Gap(14),
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
                const Gap(20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialButton(assetName: 'assets/images/google.png'),
                    Gap(16),
                    SocialButton(assetName: 'assets/images/facebook.png'),
                  ],
                ),
                const Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already a member? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  Widget _buildInputField(
    String hint,
    String label,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: hint,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        const Gap(5),
        CustomTextFormField(
          controller: controller,
          hintText: label,
        ),
        const Gap(16),
      ],
    );
  }
}
