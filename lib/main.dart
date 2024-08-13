import 'package:flutter/material.dart';
import 'package:recipe_app/ui/recipe/screens/add_recipe.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AddRecipe(),
    );
  }
}
