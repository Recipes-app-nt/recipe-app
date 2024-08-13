import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recipe_app/core/app.dart';
import 'package:recipe_app/data/services/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  
  // sharedPreferences.remove('userData');
  setUp();
  setUpAuth();
  runApp(const MyApp());
/*
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_app/ui/views/authentication/screens/splash_screen.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      // home: AddRecipe(),
      home: SplashScreen(),
    );
  }
  */
}
