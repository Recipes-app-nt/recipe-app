import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:recipe_app/blocs/auth/auth_bloc.dart';
import 'package:recipe_app/data/services/get_it.dart';
import 'package:recipe_app/ui/views/authentication/widgets/social_button.dart';
import 'package:recipe_app/ui/widgets/custom_textfield.dart';
import 'package:recipe_app/ui/widgets/custom_button.dart';
import 'package:recipe_app/ui/widgets/custom_text.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool checkBox = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: formKey,
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
                  _buildInputField(
                    'Name',
                    'Enter Name',
                    validateUserName,
                    nameController,
                  ),
                  _buildInputField(
                    'Email',
                    'Enter Email',
                    validateEmail,
                    emailController,
                  ),
                  _buildInputField(
                    'Password',
                    'Enter Password',
                    validatePassword,
                    passwordController,
                  ),
                  _buildInputField(
                    'Confirm Password',
                    'Retype Password',
                    validateConfirmPassword,
                    confirmController,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        side: const BorderSide(color: Colors.orange, width: 2),
                        value: checkBox,
                        onChanged: (value) {
                          checkBox = value!;
                          setState(() {});
                        },
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
                    child: BlocListener<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is AuthAuthenticated) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: CustomButton(
                        title: "Sign Up",
                        onPressed: checkBox
                            ? () {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  getIt.get<AuthBloc>().add(
                                        AuthRegister(
                                          emailController.text,
                                          passwordController.text,
                                          nameController.text,
                                        ),
                                      );
                                }
                              }
                            : null,
                      ),
                    ),
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
                        ),
                      ),
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
      ),
    );
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  String? validateUserName(String? value) {
    if (value == null || value.isEmpty) {
      return 'UserName is required';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    if (!value.contains(RegExp(r'[A-Z]')) ||
        !value.contains(RegExp(r'[a-z]')) ||
        !value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one uppercase letter, one lowercase letter, and one number';
    }

    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }

    if (value != passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  Widget _buildInputField(
    String hint,
    String label,
    String? Function(String?)? validator,
    TextEditingController controller,
  ) {
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
          validator: validator,
          controller: controller,
          hintText: label,
        ),
        const Gap(16),
      ],
    );
  }
}
