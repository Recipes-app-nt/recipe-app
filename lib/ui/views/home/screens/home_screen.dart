import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:recipe_app/blocs/recipe/recipe_bloc.dart';
import 'package:recipe_app/blocs/recipe/recipe_event.dart';
import 'package:recipe_app/blocs/recipe/recipe_state.dart';
import 'package:recipe_app/ui/views/home/widgets/profile_info_widget.dart';
import 'package:recipe_app/ui/views/home/widgets/search_field.dart';

import '../widgets/categories_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileInfoWidget(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: MySearchField(),
            ),
            const Gap(10.0),
            const MyCategoriesRow(),
            const Gap(50.0),
            BlocBuilder<RecipeBloc, RecipeState>(
              bloc: context.read<RecipeBloc>()..add(LoadRecipes()),
              builder: (context, state) {
                print(state);
                if (state is RecipeLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is RecipeLoaded) {
                  return SizedBox(
                    height: 200,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: state.recipes.length,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) => const Gap(20.0),
                      itemBuilder: (context, index) {
                        final recipe = state.recipes[index];
                        return Container(
                          clipBehavior: Clip.none,
                          // height: 00,
                          decoration: const BoxDecoration(color: Colors.grey),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                top: -50,
                                left: 10,
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  height: 100,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.network(
                                    "https://images.pexels.com/photos/3872370/pexels-photo-3872370.jpeg?auto=compress&cs=tinysrgb&w=600",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text(recipe.title),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("Time"),
                                      Text("${recipe.cookingTime} Mins"),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Text("Malumotlar mavjud emas");
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
