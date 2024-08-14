import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:recipe_app/blocs/recipe/recipe_bloc.dart';
import 'package:recipe_app/blocs/recipe/recipe_event.dart';
import 'package:recipe_app/blocs/recipe/recipe_state.dart';
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
              const ProfileInfoWidget(),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: MySearchField(),
              ),
              const Gap(10.0),
              const MyCategoriesRow(),
              // const Gap(70.0),
              const StackProductWidget(),

              //* Category text style
              const Padding(
                padding: const EdgeInsets.all(16.0),
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
