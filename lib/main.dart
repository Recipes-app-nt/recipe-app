import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/core/app.dart';
import 'package:recipe_app/data/services/fcm_service.dart';
import 'package:recipe_app/data/services/get_it.dart';
import 'package:recipe_app/firebase_options.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setUp();
  setUpAuth();
  await FCMService().requestPermission();
  runApp(const MyApp());
}
