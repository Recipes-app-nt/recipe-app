import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:recipe_app/ui/views/home/widgets/shimmers/new_recipe_shimmer.dart';

import '../../../../blocs/recipe/recipe_bloc.dart';
import '../../../../blocs/recipe/recipe_event.dart';
import '../../../../blocs/recipe/recipe_state.dart';

class NewRecipe extends StatelessWidget {
  const NewRecipe({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeBloc, RecipeState>(
      bloc: context.read<RecipeBloc>()..add(LoadRecipes()),
      builder: (context, state) {
        print(state);
        if (state is RecipeLoading) {
          return SizedBox(
            height: 180,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: 5, 
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => const Gap(20.0),
              itemBuilder: (context, index) {
                return const NewRecipeShimmer();
              },
            ),
          );
        }
        if (state is RecipeLoaded) {
          return SizedBox(
            height: 180,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: state.recipes.length,
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => const Gap(20.0),
              itemBuilder: (context, index) {
                final recipe = state.recipes[index];
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 50),
                      width: 300,
                      height: 120,
                      clipBehavior: Clip.none,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10.0,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Text(
                                    recipe.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 20,
                                      color: Colors.amber,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.teal,
                                        ),
                                        Gap(10.0),
                                        Text(
                                          "By James Milner",
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "${recipe.cookingTime} mins",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        height: 100,
                        width: 120,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.network(
                          recipe.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              child: Image.network(
                                "https://images.pexels.com/photos/2097090/pexels-photo-2097090.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        } else {
          return const Text("Malumotlar mavjud emas");
        }
      },
    );
  }
}
