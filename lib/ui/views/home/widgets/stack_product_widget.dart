import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../blocs/recipe/recipe_bloc.dart';
import '../../../../blocs/recipe/recipe_event.dart';
import '../../../../blocs/recipe/recipe_state.dart';

class StackProductWidget extends StatelessWidget {
  const StackProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeBloc, RecipeState>(
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
            height: 280,
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
                                Text(recipe.title),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Time"),
                                        Text("${recipe.cookingTime} Mins"),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {},
                                      splashColor: Colors.blue.withOpacity(0.9),
                                      highlightColor: Colors.transparent,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Image.asset(
                                          'assets/icons/bookmark.png',
                                          // color: const Color(0xff71B1A1),
                                          width: 16,
                                        ),
                                      ),
                                    ),
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
