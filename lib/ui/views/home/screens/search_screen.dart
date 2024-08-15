import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:recipe_app/data/models/recipe_model.dart';
import 'package:recipe_app/ui/views/home/screens/details_screen.dart';
import 'package:recipe_app/ui/views/home/widgets/categories_widget.dart';
import 'package:recipe_app/ui/widgets/favorite_button.dart';

class MySearchDelegate extends SearchDelegate<String> {
  final List<Recipe> data;

  MySearchDelegate(this.data);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<Recipe> results = data
        .where((element) =>
            element.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return SearchWidget(results: results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Recipe> results = data
        .where((element) =>
            element.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return SearchWidget(results: results);
  }
}

class SearchWidget extends StatelessWidget {
  final List<Recipe> results;
  const SearchWidget({
    super.key,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 220,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: results.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        final recipe = results[index];
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
                height: 150,
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
                          const Gap(20),
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
                right: 20,
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
    );
  }
}
