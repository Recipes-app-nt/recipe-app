import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:recipe_app/ui/views/home/widgets/new_recipe.dart';
import 'package:recipe_app/ui/views/home/widgets/profile_info_widget.dart';
import 'package:recipe_app/ui/views/home/widgets/search_field.dart';
import 'package:recipe_app/ui/views/home/widgets/stack_product_widget.dart';

import '../widgets/categories_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
               ProfileInfoWidget(),
               Padding(
                padding: EdgeInsets.all(16.0),
                child: MySearchField(),
              ),
               Gap(10.0),
               MyCategoriesRow(),
              //  Gap(70.0),
               StackProductWidget(),

              //* Category text style
               Padding(
                padding:  EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Text(
                      "New Recipes",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              NewRecipe(),
            ],
          ),
        ),
      ),
    );
  }
}
