import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:recipe_app/blocs/recipe/recipe_bloc.dart';
import 'package:recipe_app/data/repositories/recipe_repository.dart';
import 'package:recipe_app/data/services/get_it.dart';
import 'package:recipe_app/ui/views/home/screens/search_screen.dart';
import 'package:recipe_app/ui/views/home/widgets/new_recipe.dart';
import 'package:recipe_app/ui/views/home/widgets/profile_info_widget.dart';
import 'package:recipe_app/ui/views/home/widgets/search_field.dart';
import 'package:recipe_app/ui/views/home/widgets/stack_product_widget.dart';

import '../widgets/categories_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategoryId = 'all';

  @override
  void initState() {
    // context.read<RecipeBloc>().add(LoadRecipes());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const ProfileInfoWidget(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: MySearchField(
                  isSearch: true,
                  onTap: () async {
                    final list = await RecipeRepository().getAllRecipes();

                    showSearch(
                      context: context,
                      delegate: MySearchDelegate(list),
                    );
                  },
                ),
              ),
              const Gap(10.0),
              MyCategoriesRow(
                onCategorySelected: (categoryId) {
                  // setState(() {
                  //   selectedCategoryId = categoryId;
                  // });
                },
              ),
              // StackProductWidget(categoryId: selectedCategoryId),
              StackProductWidget(),

              //* Category text style
              const Padding(
                padding: EdgeInsets.all(16.0),
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
              // const NewRecipe(),
            ],
          ),
        ),
      ),
    );
  }
}
