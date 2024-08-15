import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:recipe_app/ui/widgets/favorite_button.dart';

import '../../blocs/recipe/recipe_bloc.dart';
import '../../blocs/user/user_bloc.dart';
import '../../data/models/user_model.dart';

class SavedRecipesScreen extends StatefulWidget {
  const SavedRecipesScreen({super.key});

  @override
  State<SavedRecipesScreen> createState() => _SavedRecipesScreenState();
}

class _SavedRecipesScreenState extends State<SavedRecipesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Recipes"),
        centerTitle: true,
      ),
      body: BlocBuilder<UserBloc, UserStates>(
        builder: (context, userState) {
          if (userState is ErrorUserState) {
            return Center(
              child: Text(userState.message),
            );
          }

          User? user;
          if (userState is LoadedUserState) {
            user = userState.user;
          }

          if (user == null) {
            return const Center(
              child: Text("User not found"),
            );
          }

          return BlocBuilder<RecipeBloc, RecipeState>(
            bloc: context.read<RecipeBloc>()..add(LoadRecipes()),
            builder: (context, recipeState) {
              if (recipeState is RecipeLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (recipeState is RecipeError) {
                return const Center(
                  child: Text("Malumotlar kelishda muammo bor"),
                );
              }

              if (recipeState is RecipeLoaded) {
                print(recipeState.recipes);
                final favoriteRecipes = recipeState.recipes
                    .where((recipe) => user!.favoriteDishes.contains(recipe.id))
                    .toList();

                if (favoriteRecipes.isEmpty) {
                  return const Center(
                    child: Text("Malumotlar mavjud emas"),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: favoriteRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = favoriteRecipes[index];

                      return Container(
                        clipBehavior: Clip.hardEdge,
                        margin: const EdgeInsets.only(top: 20),
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: const DecorationImage(
                            image: NetworkImage(
                              "https://i.pinimg.com/originals/82/68/69/826869734a6637abf7efe5fc8aa8e11d.jpg",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          clipBehavior: Clip.hardEdge,
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0),
                                Colors.black,
                              ],
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          recipe.title,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          "By ${user!.username}",
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/timer.svg",
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "${recipe.cookingTime} mins",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFFD9D9D9),
                                          ),
                                        ),
                                        const Gap(10.0),
                                        FavoriteButton(
                                          favoriteRecipeId: recipe.id,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return const Center(
                  child: Text("Malumotlar mavjud emas"),
                );
              }
            },
          );
        },
      ),
    );
  }
}
