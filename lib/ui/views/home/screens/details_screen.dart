import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:recipe_app/blocs/social_functions/social_function_bloc.dart';
import 'package:recipe_app/data/models/comment_model.dart';
import 'package:recipe_app/ui/views/home/widgets/comments_widget.dart';
import 'package:recipe_app/ui/views/home/widgets/like_button.dart';
import 'package:recipe_app/ui/views/home/widgets/search_field.dart';
import 'package:recipe_app/ui/widgets/favorite_button.dart';

import '../../../../data/models/recipe_model.dart';

class DetailsScreen extends StatefulWidget {
  final Recipe recipe;
  const DetailsScreen({
    super.key,
    required this.recipe,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26.0),
                  ),
                  width: double.infinity,
                  child: widget.recipe.imageUrl.isNotEmpty
                      ? Image.network(
                          widget.recipe.imageUrl,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          "https://images.pexels.com/photos/2097090/pexels-photo-2097090.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                          fit: BoxFit.cover,
                        ),
                ),
                Positioned(
                  top: 12,
                  right: 80,
                  child: LikeButton(
                      likeRecipeId: widget.recipe.id,
                      likes: widget.recipe.likes),
                ),
                Positioned(
                  top: 16,
                  right: 16,
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
                        Text(widget.recipe.rating.toString()),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 150,
                  right: 16,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/timer.svg",
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "${widget.recipe.cookingTime} mins",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFD9D9D9),
                        ),
                      ),
                      const Gap(10.0),
                      FavoriteButton(
                        favoriteRecipeId: widget.recipe.id,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 22.0,
              vertical: 10.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.recipe.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "(${widget.recipe.likes.length} Likes)",
                  style: const TextStyle(color: Colors.grey),
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TabBar(
                    dividerHeight: 0,
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                    indicator: BoxDecoration(
                      color: const Color(0xff129575),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    indicatorPadding: const EdgeInsets.all(5.0),
                    indicatorSize: TabBarIndicatorSize.tab,
                    controller: _tabController,
                    tabs: const [
                      Tab(
                        text: "Ingrident",
                      ),
                      Tab(
                        text: "Procedure",
                      ),
                      Tab(
                        text: "Commints",
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      ListView.separated(
                        itemCount: widget.recipe.ingredients.length,
                        separatorBuilder: (context, index) => const Gap(20.0),
                        itemBuilder: (context, index) {
                          final ingredient = widget.recipe.ingredients[index];
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.grey.withOpacity(0.5),
                              ),
                              child: ListTile(
                                leading: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white,
                                  ),
                                  child:
                                      const Icon(Icons.free_breakfast_outlined),
                                ),
                                title: Text(ingredient),
                              ),
                            ),
                          );
                        },
                      ),
                      ListView.separated(
                        itemCount: widget.recipe.ingredients.length,
                        separatorBuilder: (context, index) => const Gap(20.0),
                        itemBuilder: (context, index) {
                          final instruction = widget.recipe.instructions[index];
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.grey.withOpacity(0.5),
                              ),
                              child: ListTile(
                                title: Text("Stem ${index + 1}"),
                                subtitle: Text(instruction),
                              ),
                            ),
                          );
                        },
                      ),
                      CommentsWidget(recipe: widget.recipe)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
