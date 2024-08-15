import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:recipe_app/data/models/recipe_model.dart';
import 'package:recipe_app/ui/views/home/screens/details_screen.dart';
import 'package:recipe_app/ui/views/home/widgets/shimmers/stack_product_shimmer.dart';
import 'package:recipe_app/ui/widgets/favorite_button.dart';

import '../../../../blocs/recipe/recipe_bloc.dart';

class StackProductWidget extends StatefulWidget {
  // final String categoryId;

  const StackProductWidget({
    super.key,
    // required this.categoryId,
  });

  @override
  State<StackProductWidget> createState() => _StackProductWidgetState();
}

class _StackProductWidgetState extends State<StackProductWidget> {
  @override
  void initState() {
    super.initState();
    // context.read<RecipeBloc>().add(LoadRecipes());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeBloc, RecipeState>(
      bloc: context.read<RecipeBloc>()..add(LoadRecipes()),
      builder: (context, state) {
        if (state is RecipeLoading) {
          return SizedBox(
            height: 280,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: 5,
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => const Gap(20.0),
              itemBuilder: (context, index) {
                return const StackProductShimmer();
              },
            ),
          );
        }

        if (state is RecipeLoaded) {
          return RecipeContainer(recipes: state.recipes);
        } else {
          return const Text("Malumotlar mavjud emas");
        }
      },
    );
  }
}

class RecipeContainer extends StatelessWidget {
  List<Recipe> recipes;
  RecipeContainer({
    super.key,
    required this.recipes,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: recipes.length,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const Gap(20.0),
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailsScreen(
                    recipe: recipe,
                  ),
                ),
              );
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 80),
                  width: 150,
                  height: 200,
                  clipBehavior: Clip.none,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: const Color(0xffD9D9D9),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(),
                            Text(
                              recipe.title,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Time",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      "${recipe.cookingTime} Mins",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                //! Ushbu qism to'g'rilanishi kerak
                                FavoriteButton(
                                  favoriteRecipeId: recipe.id,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 10,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    height: 110,
                    width: 130,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.network(
                      recipe.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                          "https://images.pexels.com/photos/2097090/pexels-photo-2097090.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 45,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: const Color(0xffFFE1B3),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16.0,
                          color: Color(0xffFFAD30),
                        ),
                        const Gap(3.0),
                        Text(recipe.rating.toString()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
