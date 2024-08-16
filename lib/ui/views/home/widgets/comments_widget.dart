/* import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:recipe_app/blocs/recipe/recipe_bloc.dart';
import 'package:recipe_app/data/models/recipe_model.dart';

import '../../../../blocs/social_functions/social_function_bloc.dart';
import '../../../../data/models/comment_model.dart';

class CommentsWidget extends StatefulWidget {
  final Recipe recipe;
  const CommentsWidget({
    super.key,
    required this.recipe,
  });

  @override
  State<CommentsWidget> createState() => _CommentsWidgetState();
}

class _CommentsWidgetState extends State<CommentsWidget> {
  final _commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeBloc, RecipeState>(
      builder: (context, state) {
        if (state is RecipeLoaded) {
          final updatedRecipe = state.recipes;
          return Column(
            children: [
              Expanded(
                child: updatedRecipe[0].comments.isNotEmpty
                    ? ListView.separated(
                        itemCount: widget.recipe.comments.length,
                        separatorBuilder: (context, index) => const Gap(20.0),
                        itemBuilder: (context, index) {
                          final comments = widget.recipe.comments[index];
                          final date =
                              DateTime.parse(comments.timestamp.toString());
                          final formattedDate =
                              DateFormat('hh:mm').format(date);
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.grey.withOpacity(0.5),
                              ),
                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Anonimous"),
                                    Text(
                                      formattedDate,
                                      style: const TextStyle(
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Text(comments.text),
                              ),
                            ),
                          );
                        },
                      )
                    : const Text("Commentlar mavjud emas"),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff1D1617).withOpacity(0.14),
                        blurRadius: 40,
                        spreadRadius: 0.0,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.all(15),
                      label: const Text('Leave comment'),
                      hintStyle: const TextStyle(
                          color: Color(0xffDDDADA), fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: BlocBuilder<SocialFunctionsBloc,
                          SocialFunctionsState>(
                        builder: (context, state) {
                          if (state is SocialFunctionsLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (state is SocialFunctionsSuccess) {
                            return IconButton(
                              onPressed: () {
                                context.read<SocialFunctionsBloc>().add(
                                      AddCommentEvent(
                                        widget.recipe.id,
                                        Comment(
                                          userId: "userId",
                                          text: _commentController.text,
                                          timestamp: DateTime.now(),
                                        ),
                                      ),
                                    );

                                _commentController.clear();
                              },
                              icon: const Icon(Icons.send),
                            );
                          } else {
                            return const Center(
                              child: Text("Qo'shishda nimadur muammo"),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }else {
          return const Center(child: Text("Malumotlarda nimadir muammo"),);
        }
        
      },
    );
  }
}
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:recipe_app/blocs/recipe/recipe_bloc.dart';
import 'package:recipe_app/data/models/recipe_model.dart';

import '../../../../blocs/social_functions/social_function_bloc.dart';
import '../../../../data/models/comment_model.dart';

class CommentsWidget extends StatefulWidget {
  final Recipe recipe;
  const CommentsWidget({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  @override
  State<CommentsWidget> createState() => _CommentsWidgetState();
}

class _CommentsWidgetState extends State<CommentsWidget> {
  final _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeBloc, RecipeState>(
      builder: (context, state) {
        if (state is RecipeLoaded) {
          final updatedRecipe = state.recipes.firstWhere(
            (recipe) => recipe.id == widget.recipe.id,
            orElse: () => widget.recipe,
          );
          return Column(
            children: [
              Expanded(
                child: updatedRecipe.comments.isNotEmpty
                    ? ListView.separated(
                        itemCount: updatedRecipe.comments.length,
                        separatorBuilder: (context, index) => const Gap(20.0),
                        itemBuilder: (context, index) {
                          final comment = updatedRecipe.comments[index];
                          final date =
                              DateTime.parse(comment.timestamp.toString());
                          final formattedDate =
                              DateFormat('HH:mm').format(date);
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.grey.withOpacity(0.5),
                              ),
                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Anonim"),
                                    Text(
                                      formattedDate,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                                subtitle: Text(comment.text),
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(child: Text("Izohlar mavjud emas")),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff1D1617).withOpacity(0.14),
                        blurRadius: 40,
                        spreadRadius: 0.0,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.all(15),
                      labelText: 'Izoh qoldiring',
                      hintStyle: const TextStyle(
                          color: Color(0xffDDDADA), fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: BlocBuilder<SocialFunctionsBloc,
                          SocialFunctionsState>(
                        builder: (context, state) {
                          if (state is SocialFunctionsLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          return IconButton(
                            onPressed: () {
                              if (_commentController.text.isNotEmpty) {
                                context.read<SocialFunctionsBloc>().add(
                                      AddCommentEvent(
                                        updatedRecipe.id,
                                        Comment(
                                          userId: "userId",
                                          text: _commentController.text,
                                          timestamp: DateTime.now(),
                                        ),
                                      ),
                                    );
                                _commentController.clear();
                              }
                            },
                            icon: const Icon(Icons.send),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
